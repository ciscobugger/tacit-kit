// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A line at the window's foot that says what just happened ("Moved 3 files to Documents") and offers at most one
// way back (Undo): Files' status line and its Undo pill, as a part. The pill is Files' too: 32 high, round, the
// accent filled, its words Medium in the on-accent ink. The line sits on the overlay colour with the menus' faint
// edge, because over content it needs a ground of its own. Put it in the window's root item; it centres itself at the
// foot, `space.l` up. `show(text, actionWords)` shows it (a second show replaces the line and starts the time again;
// actionWords "" shows no pill); `hide()` closes it. It stays `motion.notice` (6 s). While the pointer is on it or the
// keyboard is in it, it stays, and the full time starts again when both have left. The action says `activated()` and
// closes it; Esc closes it from the pill; `closed()` always follows (time, action, Esc, hide()).
// Give the app's own shortcut for the action too (Ctrl+Z): the pill is a Tab stop only while the notice is up.
// Accessibility: role AlertMessage, named by the line, so a screen reader reads it when it appears (a screen
// reader's live-region behaviour is the platform's; see the catalogue notes). The pill is a button.
// `previewState`: "shown", "held" (the pointer on it), "focus" (the pill has the ring); for the catalogue.
Item {
    id: notice
    property string text: ""
    property string actionWords: ""
    property string previewState: ""
    readonly property real maxWidth: parent.width - 2 * Kit.tokens.space.l
    readonly property bool shown: notice.isShown
    readonly property bool held: bubbleHover.hovered || pill.activeFocus || previewState === "held"
    signal activated()
    signal closed()

    property bool isShown: previewState !== ""
    function show(line, words) {
        notice.text = line;
        notice.actionWords = words ?? "";
        notice.isShown = true;
        stay.restart();
    }
    function hide() {
        if (!notice.isShown) return;
        notice.isShown = false;
        stay.stop();
        notice.closed();
    }
    onHeldChanged: if (notice.isShown && notice.previewState === "") { if (notice.held) stay.stop(); else stay.restart(); }
    Timer { id: stay; interval: Kit.tokens.motion.notice.ms; onTriggered: if (!notice.held) notice.hide() }

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: Kit.tokens.space.l
    width: Math.min(bubble.implicitWidth, notice.maxWidth)
    height: bubble.implicitHeight
    visible: bubbleShift.progress > 0.001 || notice.isShown
    z: 90
    Accessible.role: Accessible.AlertMessage
    Accessible.name: notice.text
    Accessible.description: notice.actionWords !== "" ? "Action: " + notice.actionWords : ""
    Keys.onEscapePressed: notice.hide()

    // arrives by rising from below (Arrive), leaves faster (Leave), fading with it
    QtObject {
        id: bubbleShift
        property real progress: notice.isShown ? 1 : 0
        Behavior on progress {
            enabled: notice.previewState === ""
            NumberAnimation {
                duration: notice.isShown ? Kit.tokens.motion.arriveSmall.ms : Kit.tokens.motion.leave.ms
                easing.type: Easing.BezierSpline
                easing.bezierCurve: notice.isShown ? Kit.tokens.motion.arriveSmall.curve : Kit.tokens.motion.leave.curve
            }
        }
    }
    Rectangle {
        id: bubble
        width: notice.width
        implicitWidth: row.implicitWidth + 2 * Kit.tokens.space.l
        implicitHeight: Kit.tokens.height.row
        radius: Kit.tokens.radius.slab
        color: Kit.tokens.overlay
        border.width: 1
        border.color: Qt.alpha(Kit.tokens.inkMain, 0.10)
        opacity: bubbleShift.progress
        transform: Translate { y: (1 - bubbleShift.progress) * Kit.tokens.space.l }
        HoverHandler { id: bubbleHover }

        Row {
            id: row
            anchors.verticalCenter: parent.verticalCenter
            x: Kit.tokens.space.l
            spacing: Kit.tokens.space.m
            TacitText {
                id: line
                anchors.verticalCenter: parent.verticalCenter
                width: Math.min(implicitWidth, notice.maxWidth - 2 * Kit.tokens.space.l - (pill.visible ? pill.width + row.spacing : 0))
                text: notice.text
                elide: Text.ElideRight
            }
            Item {
                id: pill
                visible: notice.actionWords !== ""
                anchors.verticalCenter: parent.verticalCenter
                width: pillWords.implicitWidth + 2 * Kit.tokens.space.l
                height: Kit.tokens.height.field - Kit.tokens.space.xs
                activeFocusOnTab: true
                readonly property bool hovered: pillHover.hovered
                Accessible.role: Accessible.Button
                Accessible.name: notice.actionWords
                Accessible.onPressAction: pill.press()
                function press() { notice.activated(); notice.hide(); }
                scale: pillTap.pressed ? Kit.tokens.state.pressScale : 1
                Behavior on scale { NumberAnimation { duration: Kit.tokens.motion.hover.ms } }
                Rectangle {
                    id: pillFace
                    anchors.fill: parent
                    radius: height / 2
                    color: Kit.tokens.accent
                    Rectangle { anchors.fill: parent; radius: parent.radius; color: Kit.tokens.inkOnAccent; opacity: pill.hovered ? Kit.tokens.wash.hover : 0
                                Behavior on opacity { NumberAnimation { duration: Kit.tokens.motion.hover.ms } } }
                }
                FocusRing { shown: (pill.activeFocus && Kit.focusVisible) || notice.previewState === "focus"; corner: pillFace.radius }
                TacitText {
                    id: pillWords
                    anchors.centerIn: parent
                    text: notice.actionWords
                    weight: "medium"
                    ink: "onAccent"
                }
                HoverHandler { id: pillHover; cursorShape: Qt.PointingHandCursor }
                TapHandler { id: pillTap; onTapped: { Kit.focusVisible = false; pill.press(); } }
                Keys.onPressed: event => {
                    Kit.focusVisible = true;
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        pill.press();
                        event.accepted = true;
                    }
                }
            }
        }
    }
}
