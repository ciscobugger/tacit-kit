// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// Scrolling for a Flickable (a list, a page), as the shell's GlideWheel: on a touchpad the view follows the fingers
// one to one and, after a flick, glides on at the release speed, slowing by 0.998 per millisecond (UIKit's normal
// deceleration); a slow scroll stops where the fingers stop. A mouse wheel moves one eased step per notch
// (`mouseStep`, 120 px as the shell's setting; the easing is the `scroll` motion token). A mostly sideways scroll is left to the view. Put it inside the view's
// parent, over the view: Glide { view: list }.
MouseArea {
    id: glide
    required property Flickable view
    property real mouseStep: 120
    // UIKit's normal deceleration rate: a touchpad flick keeps this share of its speed each millisecond
    readonly property real flickDecay: 0.998
    // the `scroll` token; a shell whose tokens predate it (the kit's Defaults and Live have it) gets the same values
    readonly property var scrollMotion: Kit.tokens.motion.scroll ?? ({ ms: 200, curve: [0, 0, 0, 1, 1, 1] })
    property real velocity: 0       // px per ms, in contentY's direction
    // true while it moves the view: a view that eases its own contentY turns that easing off meanwhile
    readonly property bool active: glide.touching || momentum.running || step.running
    property bool touching: false
    property var samples: []        // [ms, dy] of the last moves
    // a view inside another scrolling view passes on what it can't take at its end
    property bool chain: false

    anchors.fill: view
    acceptedButtons: Qt.NoButton

    function range() {
        const minY = glide.view.originY - glide.view.topMargin;
        return [minY, Math.max(minY, glide.view.contentHeight + glide.view.bottomMargin - glide.view.height + glide.view.originY)];
    }
    // returns false at an end
    function moveBy(dy) {
        const r = glide.range();
        const y = Math.max(r[0], Math.min(glide.view.contentY + dy, r[1]));
        const moved = y !== glide.view.contentY;
        glide.view.contentY = y;
        return moved;
    }
    function touch(dy, phase, now) {
        glide.touching = phase !== Qt.ScrollEnd;
        idle.restart();
        if (phase === Qt.ScrollBegin) {
            momentum.stop();
            glide.samples = [];
        }
        if (dy !== 0) {
            momentum.stop();
            glide.moveBy(dy);
            glide.samples = glide.samples.filter(s => now - s[0] <= 80).concat([[now, dy]]);
        }
        if (phase === Qt.ScrollEnd && !momentum.running) {
            // the speed of the last 80 ms, if the fingers were still moving when they lifted
            const recent = glide.samples.filter(s => now - s[0] <= 80);
            const moving = recent.length > 1 && now - recent[recent.length - 1][0] <= 40;
            const span = moving ? Math.max(16, now - recent[0][0]) : 0;
            glide.velocity = moving ? recent.reduce((a, s) => a + s[1], 0) / span : 0;
            glide.samples = [];
            if (Math.abs(glide.velocity) > 0.1)
                momentum.start();
        }
    }

    onWheel: e => {
        if (Math.abs(e.pixelDelta.x) + Math.abs(e.angleDelta.x) > Math.abs(e.pixelDelta.y) + Math.abs(e.angleDelta.y)) {
            e.accepted = false;
            return;
        }
        if (glide.chain) {
            const dy = e.pixelDelta.y !== 0 ? -e.pixelDelta.y : -e.angleDelta.y;
            const r = glide.range();
            if ((dy > 0 && glide.view.contentY >= r[1] - 0.5) || (dy < 0 && glide.view.contentY <= r[0] + 0.5)) {
                momentum.stop();
                e.accepted = false;
                return;
            }
        }
        if (e.phase !== Qt.NoScrollPhase || e.pixelDelta.y !== 0) {
            step.stop();
            glide.touch(-e.pixelDelta.y, e.phase, Date.now());
        } else {
            momentum.stop();
            const r = glide.range();
            const from = step.running ? step.to : glide.view.contentY;
            step.stop();
            step.to = Math.max(r[0], Math.min(from - e.angleDelta.y / 120 * glide.mouseStep, r[1]));
            step.start();
        }
        e.accepted = true;
    }

    // a pad that sends no end phase still lets go
    Timer { id: idle; interval: 150; onTriggered: glide.touching = false }
    FrameAnimation {
        id: momentum
        onTriggered: {
            const dt = Math.min(frameTime * 1000, 50);
            glide.velocity *= Math.pow(glide.flickDecay, dt);
            if (!glide.moveBy(glide.velocity * dt) || Math.abs(glide.velocity) < 0.02)
                momentum.stop();
        }
    }
    // one notch: the shell's scroll step
    NumberAnimation {
        id: step
        target: glide.view
        property: "contentY"
        duration: Kit.ms(glide.scrollMotion.ms)
        easing.type: Easing.BezierSpline
        easing.bezierCurve: glide.scrollMotion.curve
    }
}
