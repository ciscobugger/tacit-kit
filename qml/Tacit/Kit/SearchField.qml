// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// Search for the page, named by what it covers ("Search Downloads", "Search Music"). Quiet until used: the symbol and
// the words, with the field's own padding so nothing moves when it opens; a faint wash on hover says it can be
// pressed. Pressed, focused or typed into, the field's colour fades in behind the same symbol and words and it grows
// to its open width (Arrive, 250 ms), with a clear button once there is text. Esc clears, then leaves. The clear button is 32 square. A screen reader
// finds the TextInput (role, name and the typed text), not this item.
FocusScope {
    id: search
    property string scope: ""
    property alias text: input.text
    property real fieldWidth: 300
    property string previewState: ""
    signal accepted()
    signal dismissed()          // Esc on an empty field: it gave the keyboard back (not "left": every item has a left anchor line)
    signal down()               // ↓ in the field: the page's list takes the keyboard
    function selectAll() { input.selectAll(); }

    readonly property bool open: input.activeFocus || input.text.length > 0 || previewState === "open" || previewState === "typed"
    readonly property real quietWidth: 36 + quietWords.implicitWidth + 14
    readonly property bool hovered: hover.hovered || previewState === "hover"
    property real openness: open ? 1 : 0
    Behavior on openness {
        NumberAnimation {
            duration: Kit.ms(Kit.tokens.motion.arriveSmall.ms)
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Kit.tokens.motion.arriveSmall.curve
        }
    }

    implicitWidth: quietWidth + (fieldWidth - quietWidth) * openness
    implicitHeight: Kit.tokens.height.field
    activeFocusOnTab: true
    Accessible.ignored: true          // the TextInput is the one node; a second editable one would hide the typed text

    Rectangle {
        anchors.fill: parent
        radius: Kit.tokens.radius.slab
        color: Kit.tokens.container
        opacity: (1 - Kit.tokens.windowSeeThrough) * search.openness
    }
    // at rest: the hover wash, on the field's own shape
    Rectangle {
        anchors.fill: parent
        radius: Kit.tokens.radius.slab
        color: Kit.tokens.inkMain
        opacity: search.hovered && !search.open ? Kit.tokens.wash.hover : 0
        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
    }
    // a sibling of the fill: the fill is invisible while the field is quiet and would take the ring with it
    Item {
        anchors.fill: parent
        FocusRing { shown: (input.activeFocus && Kit.focusVisible) || search.previewState === "focus"; corner: Kit.tokens.radius.slab }
    }
    Symbol {
        x: 10
        anchors.verticalCenter: parent.verticalCenter
        text: "search"
        color: search.hovered || search.open ? Kit.tokens.inkMain : Kit.tokens.inkSec
    }
    TacitText {
        id: quietWords
        x: 36
        anchors.verticalCenter: parent.verticalCenter
        text: "Search " + search.scope
        ink: "sec"
        visible: input.text.length === 0 && search.previewState !== "typed"
        opacity: input.activeFocus ? 0.0 : 1
    }
    TextInput {
        id: input
        x: 36
        width: parent.width - 36 - 40
        anchors.verticalCenter: parent.verticalCenter
        focus: true
        clip: true
        color: Kit.tokens.inkMain
        selectionColor: Qt.alpha(Kit.tokens.accent, 0.35)
        selectedTextColor: Kit.tokens.inkMain
        cursorDelegate: Rectangle { width: 1.5; color: Kit.tokens.accent }
        renderType: Text.NativeRendering
        font.family: Kit.tokens.font.main
        font.pixelSize: Kit.tokens.size.row
        font.weight: Kit.tokens.weight.regular
        font.variableAxes: ({ "wght": Kit.tokens.weight.regular, "wdth": 100 })
        font.hintingPreference: Font.PreferNoHinting
        text: search.previewState === "typed" ? "lease" : ""
        Accessible.role: Accessible.EditableText
        Accessible.name: search.scope !== "" ? "Search " + search.scope : "Search"
        onAccepted: search.accepted()
        Keys.onPressed: event => {
            Kit.focusVisible = true;
            if (event.key === Qt.Key_Escape) {
                if (input.text.length > 0) input.text = "";
                else { input.focus = false; search.dismissed(); }
                event.accepted = true;
            } else if (event.key === Qt.Key_Down) {
                search.down();
                event.accepted = true;
            }
        }
    }
    IconButton {
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.verticalCenter: parent.verticalCenter
        width: 32; height: 32
        visible: input.text.length > 0
        symbol: "close"
        size: 18
        label: "Clear the search"
        onActivated: { input.text = ""; input.forceActiveFocus(); }
    }
    HoverHandler { id: hover; cursorShape: search.open ? Qt.IBeamCursor : Qt.PointingHandCursor }
    TapHandler { onTapped: { Kit.focusVisible = false; input.forceActiveFocus(Qt.MouseFocusReason); } }
}
