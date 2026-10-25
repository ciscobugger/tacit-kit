// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// An action as words, in a list of them (a docked panel's actions, a menu): 40 high, the secondary ink, a wash on
// hover. risk: the risk ink after the warning symbol (a risk is never said by colour alone); it goes last. It is 280
// wide unless the place sets `width`; `wordsWidth` is how wide the words themselves are (a lone action in a bar).
// `confirm` is the question for what cannot be undone ("Delete 12 files for good"): the first press does not act, the
// words become `confirm` in the risk tone (the warning symbol, the risk ink) and a second press says `activated()`. Esc,
// the keyboard leaving, the pointer leaving when the pointer asked, or `motion.confirmWait` (4 s) untouched put the
// words back and say `confirmCancelled()`. The swap fades through nothing (instant with reduced motion). A screen
// reader hears the question as the name. `previewState: "confirming"` shows it.
Item {
    id: action
    property string text
    property bool risk: false
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
    readonly property bool risky: risk || shownAsking

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
    Timer { id: wait; interval: Kit.motion("confirmWait").ms; onTriggered: action.cancelAsk() }
    SequentialAnimation {
        id: swap
        NumberAnimation { target: words; property: "opacity"; to: 0; duration: Kit.ms(Kit.motion("fadeFast").ms / 2) }
        ScriptAction { script: action.shownAsking = action.asking }
        NumberAnimation { target: words; property: "opacity"; to: 1; duration: Kit.ms(Kit.motion("fadeFast").ms / 2) }
    }
    onActiveFocusChanged: if (!activeFocus) cancelAsk()
    onHoveredChanged: if (!hovered && askedByPointer) cancelAsk()

    readonly property bool hovered: hover.hovered || previewState === "hover"
    readonly property bool down: tap.pressed || previewState === "pressed"

    readonly property real wordsWidth: words.implicitWidth
    implicitWidth: 280
    implicitHeight: Kit.tokens.height.action
    activeFocusOnTab: true
    Accessible.role: Accessible.Button
    Accessible.name: action.asking ? action.confirm : action.text
    Accessible.onPressAction: action.press(false)

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: -Kit.tokens.space.m
        anchors.rightMargin: -Kit.tokens.space.m
        radius: Kit.tokens.radius.row
        // asking: the same faint risk fill as a Slab that asks
        color: action.shownAsking ? Kit.tokens.risk : Kit.tokens.inkMain
        opacity: action.shownAsking ? 0.14 : action.down ? Kit.tokens.wash.pressed : action.hovered ? Kit.tokens.wash.hover : 0
        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
    }
    // a sibling of the wash, not inside it: the wash is invisible at rest and would take the ring with it
    Item {
        anchors.fill: parent
        anchors.leftMargin: -Kit.tokens.space.m
        anchors.rightMargin: -Kit.tokens.space.m
        FocusRing { shown: (action.activeFocus && Kit.focusVisible) || action.previewState === "focus" }
    }
    Row {
        id: words
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8
        Symbol {
            visible: action.risky
            anchors.verticalCenter: parent.verticalCenter
            text: "warning"
            size: 15
            color: Kit.tokens.risk
        }
        TacitText {
            text: action.shownText
            ink: action.risky ? "risk" : action.hovered ? "main" : "sec"
        }
    }
    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
    TapHandler { id: tap; onTapped: { Kit.focusVisible = false; action.press(true); } }
    Keys.onPressed: event => {
        Kit.focusVisible = true;
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            action.press(false);
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape && action.asked) {
            action.cancelAsk();
            event.accepted = true;
        }
    }
}
