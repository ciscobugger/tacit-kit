// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A continuous amount as Praxis's slim bar (Settings' Ruler): a 6 px track, the reached part in the secondary ink, a
// knob only under the pointer, while dragged or with the keyboard, the value as a word at the end (`word`). ← → and ↑ ↓ step,
// Page Up and Down step ten times, Home and End go to the ends. The app sets `value` when it hears `moved`. A screen
// reader reads `value` against `minimumValue` and `maximumValue` (0 and 1) in steps of `stepSize` (= `step`) and can
// raise or lower it by one step. `enabled` is the Item's own: disabled, the bar and the word are in the faint ink and
// nothing answers.
// previewState: hover, focus, pressed (the knob held by the pointer, grown by six times the press shrink of a Slab).
Item {
    id: slider
    property real value: 0              // 0 to 1
    property real step: 0.01
    property string word: ""
    property string label
    property string previewState: ""
    readonly property real minimumValue: 0
    readonly property real maximumValue: 1
    readonly property real stepSize: step
    signal moved(real value)

    readonly property real wordArea: word !== "" ? 72 : 0
    readonly property real trackWidth: width - wordArea
    readonly property bool held: drag.active || tap.pressed || previewState === "pressed"
    readonly property bool lit: hover.hovered || held || previewState === "hover" || previewState === "focus"
                                || (activeFocus && Kit.focusVisible)
    implicitWidth: 260
    implicitHeight: 28
    activeFocusOnTab: enabled
    Accessible.role: Accessible.Slider
    Accessible.name: label
    Accessible.description: word
    Accessible.onIncreaseAction: if (slider.enabled) slider.set(slider.value + slider.step)
    Accessible.onDecreaseAction: if (slider.enabled) slider.set(slider.value - slider.step)

    function set(v) { slider.moved(Math.max(0, Math.min(1, Math.round(v / slider.step) * slider.step))); }

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: slider.trackWidth; height: 6; radius: height / 2
        color: Qt.alpha(Kit.tokens.inkMain, 0.12)
        Rectangle {
            width: Math.max(track.height, track.width * slider.value)
            height: parent.height; radius: parent.radius
            color: slider.enabled ? Kit.tokens.inkSec : Kit.tokens.inkFaint
        }
    }
    Rectangle {
        x: slider.value * (slider.trackWidth - width)
        anchors.verticalCenter: parent.verticalCenter
        width: 14; height: 14; radius: width / 2
        color: Kit.tokens.inkMain
        opacity: slider.lit ? 1 : 0
        scale: slider.held ? 1 + 6 * (1 - Kit.tokens.state.pressScale) : 1
        Behavior on scale { NumberAnimation { duration: Kit.ms(Kit.motion("press").ms); easing.type: Easing.BezierSpline; easing.bezierCurve: Kit.motion("press").curve } }
        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.motion("reveal").ms) } }
        FocusRing { shown: (slider.activeFocus && Kit.focusVisible) || slider.previewState === "focus"; corner: parent.radius }
    }
    TacitText {
        visible: slider.word !== ""
        anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
        width: slider.wordArea - Kit.tokens.space.m
        horizontalAlignment: Text.AlignRight
        text: slider.word; ink: slider.enabled ? "sec" : "faint"; cut: "numbers"
        elide: Text.ElideRight
    }
    HoverHandler { id: hover; enabled: slider.enabled; cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.PointingHandCursor }
    DragHandler {
        id: drag
        enabled: slider.enabled
        target: null
        yAxis.enabled: false
        onCentroidChanged: if (active) slider.set(centroid.position.x / slider.trackWidth)
    }
    TapHandler { id: tap; enabled: slider.enabled; onTapped: (point) => { Kit.focusVisible = false; slider.set(point.position.x / slider.trackWidth); } }
    Keys.onPressed: event => {
        if (!slider.enabled) return;
        Kit.focusVisible = true;
        const k = event.key, v = slider.value, s = slider.step;
        const to = k === Qt.Key_Left || k === Qt.Key_Down ? v - s : k === Qt.Key_Right || k === Qt.Key_Up ? v + s : k === Qt.Key_PageDown ? v - 10 * s
                 : k === Qt.Key_PageUp ? v + 10 * s : k === Qt.Key_Home ? 0 : k === Qt.Key_End ? 1 : NaN;
        if (isNaN(to)) return;
        slider.set(to);
        event.accepted = true;
    }
}
