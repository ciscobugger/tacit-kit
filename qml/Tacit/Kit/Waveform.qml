// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// The scrubbing line for anything that plays: the sound as bars, the played part in the accent, the rest in the quiet
// ink. `peaks` are the app's levels, 0 to 1, as many as it has; the part folds them into as many bars as fit (the
// loudest of each stretch). `position` is the played part, 0 to 1. A stage page shows the playhead. Click or drag to
// seek; with the keyboard, ← and → step by `keyStep`, Home and End go to the ends. The app moves `position` when it
// hears `seek`. A screen reader hears `position` as the slider's value (`value`, 0 to 1, in steps of `keyStep`).
Item {
    id: wave
    property var peaks: []
    property real position: 0
    property real bar: 3
    property bool playhead: false
    property bool seekable: true
    property real keyStep: 0.02
    property string previewState: ""
    readonly property real value: position
    readonly property real minimumValue: 0
    readonly property real maximumValue: 1
    readonly property real stepSize: keyStep
    signal seek(real at)

    readonly property int count: Math.max(1, Math.floor(width / (bar * 2)))
    readonly property real step: width / count
    readonly property var levels: {
        const n = wave.count, p = wave.peaks, out = [];
        for (let i = 0; i < n; i++) {
            const a = Math.floor(i * p.length / n), b = Math.max(a + 1, Math.floor((i + 1) * p.length / n));
            let m = 0;
            for (let j = a; j < b && j < p.length; j++) m = Math.max(m, p[j]);
            out.push(m);
        }
        return out;
    }

    implicitWidth: 380
    implicitHeight: 32
    activeFocusOnTab: seekable
    Accessible.role: Accessible.Slider
    Accessible.name: "Position"
    Accessible.focusable: seekable

    Repeater {
        model: wave.count
        Rectangle {
            required property int index
            x: index * wave.step + (wave.step - wave.bar) / 2
            width: wave.bar
            radius: wave.bar / 2
            height: Math.max(wave.bar, wave.height * (wave.levels[index] ?? 0))
            y: (wave.height - height) / 2
            color: (index + 0.5) / wave.count < wave.position ? Kit.tokens.accent : Kit.tokens.quiet
        }
    }
    Rectangle {
        visible: wave.playhead
        x: wave.width * wave.position - 1
        y: -8
        width: 2; height: wave.height + 16; radius: 1
        color: Kit.tokens.inkMain
    }
    FocusRing { shown: (wave.activeFocus && Kit.focusVisible) || wave.previewState === "focus"; corner: Kit.tokens.radius.art }

    function at(x) { return Math.max(0, Math.min(1, x / wave.width)); }
    HoverHandler { enabled: wave.seekable; cursorShape: Qt.PointingHandCursor }
    DragHandler {
        enabled: wave.seekable
        target: null
        xAxis.enabled: true; yAxis.enabled: false
        onCentroidChanged: if (active) wave.seek(wave.at(centroid.position.x))
    }
    TapHandler {
        enabled: wave.seekable
        onTapped: (point) => { Kit.focusVisible = false; wave.seek(wave.at(point.position.x)); }
    }
    Keys.onPressed: event => {
        Kit.focusVisible = true;
        if (!wave.seekable) return;
        const to = event.key === Qt.Key_Left ? wave.position - wave.keyStep
                 : event.key === Qt.Key_Right ? wave.position + wave.keyStep
                 : event.key === Qt.Key_Home ? 0
                 : event.key === Qt.Key_End ? 1 : -1;
        if (to < -0.5) return;
        wave.seek(Math.max(0, Math.min(1, to)));
        event.accepted = true;
    }
}
