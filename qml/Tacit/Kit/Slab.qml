// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// The owner's ring button (the shell's Slab, 2026-10-08), on the kit's tokens. A pill drawn as a ring, no fill at
// rest. tone "default": the way forward (Enter), a 1.5 px ring in the accent, its word Medium in the main ink, wider.
// "risk": a quiet ring in the risk ink, the warning symbol before its word. "": the quiet ring, 1 px of the main ink at
// 42 %, its word in the secondary ink. Hover lifts it with a faint fill; pressing shrinks it to 0.97; keyboard focus
// is the kit's ring. Always the forward ring's height, so rings of both kinds centre on one line.
// `waiting` is a Slab that cannot be pressed now (a job running): the ring in the quiet ink, the word in the secondary
// ink, presses ignored (it is disabled: no Tab stop, a screen reader hears it so). `maxWidth` (0 = none) caps the
// width; the word elides in the middle of the room that is left.
// `confirm` is the question for what cannot be undone ("Delete 12 files for good"): the first press does not act, the
// words become `confirm` in the risk tone (the warning symbol, the risk ink, whatever the tone was) and the Slab is as
// wide as they need, where it is anchored; a second press says `activated()`. Esc, the keyboard leaving, the pointer
// leaving when the pointer asked, or `motion.confirmWait` (4 s) untouched put the words back and say
// `confirmCancelled()`. The swap fades through nothing (instant with reduced motion). A screen reader hears the
// question as the name. `previewState: "confirming"` shows it.
Item {
    id: slab
    property string text
    property string tone: ""
    property bool large: false
    property bool waiting: false
    property real maxWidth: 0
    property string confirm: ""
    property string previewState: ""
    signal activated()
    signal confirmCancelled()

    property bool asked: false
    property bool askedByPointer: false
    readonly property bool asking: confirm !== "" && (asked || previewState === "confirming")
    // what is drawn: it follows `asking` at the middle of the fade
    property bool shownAsking: false
    readonly property string shownText: shownAsking ? confirm : text
    readonly property bool forward: tone === "default" && !shownAsking
    readonly property bool risky: tone === "risk" || shownAsking

    function press(byPointer) {
        if (confirm !== "" && !asked) {
            askedByPointer = byPointer;
            asked = true;
            forceActiveFocus();
            wait.restart();
        } else {
            settle();
            activated();
        }
    }
    function settle() { asked = false; wait.stop(); }
    function cancelAsk() {
        if (!asked) return;
        settle();
        confirmCancelled();
    }
    onAskingChanged: swap.restart()
    onConfirmChanged: if (confirm === "") settle()
    Component.onCompleted: shownAsking = asking
    Timer { id: wait; interval: Kit.motion("confirmWait").ms; onTriggered: slab.cancelAsk() }
    SequentialAnimation {
        id: swap
        NumberAnimation { target: row; property: "opacity"; to: 0; duration: Kit.ms(Kit.motion("fadeFast").ms / 2) }
        ScriptAction { script: slab.shownAsking = slab.asking }
        NumberAnimation { target: row; property: "opacity"; to: 1; duration: Kit.ms(Kit.motion("fadeFast").ms / 2) }
    }
    onActiveFocusChanged: if (!activeFocus) cancelAsk()
    onHoveredChanged: if (!hovered && askedByPointer) cancelAsk()

    readonly property bool hovered: area.containsMouse || previewState === "hover"
    readonly property bool down: area.pressed || previewState === "pressed"
    readonly property int forwardHeight: large ? 50 : Kit.tokens.height.action
    readonly property int quietHeight: large ? 44 : Kit.tokens.height.field
    readonly property string inkName: waiting ? "sec" : forward ? "main" : risky ? "risk" : hovered ? "main" : "sec"

    readonly property real padding: forward ? (large ? 72 : 52) : (large ? 52 : 36)
    readonly property real natural: forward ? Math.max(large ? 190 : 104, row.implicitWidth + padding) : row.implicitWidth + padding
    implicitWidth: maxWidth > 0 ? Math.min(natural, maxWidth) : natural
    implicitHeight: forwardHeight
    enabled: !waiting          // presses, keys and the Tab stop go; a screen reader hears it as disabled
    activeFocusOnTab: true
    scale: down ? Kit.tokens.state.pressScale : 1
    Behavior on scale { NumberAnimation { duration: Kit.ms(Kit.motion("press").ms); easing.type: Easing.BezierSpline; easing.bezierCurve: Kit.motion("press").curve } }
    Accessible.role: Accessible.Button
    Accessible.name: slab.asking ? slab.confirm : slab.text
    Accessible.onPressAction: slab.press(false)

    Rectangle {
        id: pill
        width: parent.width
        height: slab.forward ? slab.forwardHeight : slab.quietHeight
        anchors.verticalCenter: parent.verticalCenter
        radius: height / 2
        // asking: a faint fill of the risk ink, so the press that acts reads at a glance as armed
        color: slab.shownAsking ? Qt.alpha(Kit.tokens.risk, 0.14) : Qt.alpha(Kit.tokens.inkMain, slab.hovered ? 0.05 : 0)
        border.width: slab.forward ? 1.5 : 1
        border.color: slab.shownAsking ? Qt.alpha(Kit.tokens.risk, 0.85)
                    : slab.waiting ? Kit.tokens.quiet
                    : slab.forward ? Qt.alpha(Kit.tokens.accent, 0.75)
                    : slab.risky ? Qt.alpha(Kit.tokens.risk, 0.55)
                    : Qt.alpha(Kit.tokens.inkMain, 0.42)
        Behavior on color { ColorAnimation { duration: Kit.ms(Kit.motion("tone").ms) } }
        FocusRing { shown: (slab.activeFocus && Kit.focusVisible) || slab.previewState === "focus"; corner: pill.radius }
    }
    Row {
        id: row
        anchors.centerIn: parent
        spacing: 7
        Symbol {
            id: warnSign
            visible: slab.risky
            anchors.verticalCenter: word.verticalCenter
            text: "warning"
            size: slab.large ? 17 : 15
            color: Kit.tokens.risk
        }
        TacitText {
            id: word
            text: slab.shownText
            elide: Text.ElideMiddle
            width: slab.maxWidth > 0 ? Math.min(implicitWidth, Math.max(0, slab.maxWidth - slab.padding - (slab.risky ? row.spacing + warnSign.width : 0))) : implicitWidth
            size: slab.forward && slab.large ? "body" : "row"
            weight: slab.forward ? "medium" : "regular"
            ink: slab.inkName
        }
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: { Kit.focusVisible = false; slab.press(true); }
    }
    Keys.onPressed: event => {
        Kit.focusVisible = true;
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            slab.press(false);
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape && slab.asked) {
            slab.cancelAsk();
            event.accepted = true;
        }
    }
}
