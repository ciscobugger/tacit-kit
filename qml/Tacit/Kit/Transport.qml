// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// Previous, play or pause in an accent ring, next: the controls of anything that plays. `size` is the ring's
// diameter (64 on a stage page, 40 in a player bar); the symbols are half of it. The ring answers like a Slab: a
// faint fill under the pointer, 0.97 while pressed, the kit's focus ring after a key. Space in the app toggles play;
// that key belongs to the window, not to this part.
Row {
    id: transport
    property int size: 64
    property bool playing: false
    property bool canPrevious: true
    property bool canNext: true
    property string label: "Playback"  // what a screen reader calls the controls
    property string previewState: ""   // the ring's state for the catalogue and the docs
    signal previous()
    signal playPause()
    signal next()

    spacing: Math.round(size * 0.35)
    Accessible.role: Accessible.ToolBar
    Accessible.name: label

    IconButton {
        anchors.verticalCenter: parent.verticalCenter
        symbol: "skip_previous"; label: "Previous"
        size: transport.size / 2
        enabled: transport.canPrevious
        onActivated: transport.previous()
    }
    Item {
        id: ring
        anchors.verticalCenter: parent.verticalCenter
        width: transport.size; height: transport.size
        readonly property bool hovered: ringHover.hovered || transport.previewState === "hover"
        readonly property bool down: ringTap.pressed || transport.previewState === "pressed"
        activeFocusOnTab: true
        scale: down ? Kit.tokens.state.pressScale : 1
        Behavior on scale { NumberAnimation { duration: Kit.ms(Kit.motion("press").ms); easing.type: Easing.BezierSpline; easing.bezierCurve: Kit.motion("press").curve } }
        Accessible.role: Accessible.Button
        Accessible.name: transport.playing ? "Pause" : "Play"
        Accessible.onPressAction: transport.playPause()

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Qt.alpha(Kit.tokens.inkMain, ring.hovered ? Kit.tokens.wash.hover : 0)
            border.width: 2
            border.color: Qt.alpha(Kit.tokens.accent, 0.8)
            Behavior on color { ColorAnimation { duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
        }
        FocusRing { shown: (ring.activeFocus && Kit.focusVisible) || transport.previewState === "focus"; corner: ring.width / 2 }
        Symbol {
            anchors.centerIn: parent
            text: transport.playing ? "pause" : "play_arrow"
            size: transport.size / 2
            color: Kit.tokens.inkMain
        }
        HoverHandler { id: ringHover; cursorShape: Qt.PointingHandCursor }
        TapHandler { id: ringTap; onTapped: { Kit.focusVisible = false; transport.playPause(); } }
        Keys.onPressed: event => {
            Kit.focusVisible = true;
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                transport.playPause();
                event.accepted = true;
            }
        }
    }
    IconButton {
        anchors.verticalCenter: parent.verticalCenter
        symbol: "skip_next"; label: "Next"
        size: transport.size / 2
        enabled: transport.canNext
        onActivated: transport.next()
    }
}
