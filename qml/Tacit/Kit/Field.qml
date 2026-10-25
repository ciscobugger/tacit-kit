// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A line to type in, inside a panel (the search field is the page's own): 36 high, a faint wash of the main
// ink on the panel's colour, the words in the main ink, a hint in the meta ink while empty (the faint ink fell to
// Lc 55 on a panel), the caret in the accent. While
// it has the keyboard the accent ring shows (a field always shows where typing goes). Enter sends `accepted`.
// `input` is the TextInput, for selection ranges and keys. `error` puts the ring (always shown) and the caret in the
// risk ink and says so to a screen reader. The hint goes once there is text unless `persistentHint`: then it stays as
// a label at the field's end in the meta ink.
// `enabled: false` is a field that cannot be used now: the words and the hint in the faint ink, no hover, no caret,
// no keyboard, not editable, and a screen reader hears it as disabled.
// A screen reader finds the field as the TextInput itself, which carries the text, the role and the name: `label`,
// or the hint when there is no label (give one; a field with neither is read as nothing).
Item {
    id: field
    property alias text: input.text
    property string hint: ""
    property bool error: false
    property bool persistentHint: false
    readonly property alias input: input
    property string label
    property string previewState: ""
    signal accepted()
    signal edited()

    readonly property bool hovered: enabled && (hover.hovered || previewState === "hover")
    implicitWidth: 320
    implicitHeight: Kit.tokens.height.field
    Accessible.ignored: true          // the TextInput is the field's one node (a second editable one would hide the typed text)

    function focusIn() { input.forceActiveFocus(); }

    Rectangle {
        anchors.fill: parent
        radius: Kit.tokens.radius.slab
        color: Kit.tokens.inkMain
        opacity: field.hovered && !input.activeFocus ? Kit.tokens.wash.action + Kit.tokens.wash.hover : Kit.tokens.wash.action
        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
    }
    FocusRing {
        shown: field.enabled && (input.activeFocus || field.previewState === "focus" || field.error); corner: Kit.tokens.radius.slab
        border.color: field.error ? Kit.tokens.risk : Kit.tokens.accent
    }
    TextInput {
        id: input
        x: Kit.tokens.space.m; width: parent.width - 2 * Kit.tokens.space.m - (endHint.visible ? endHint.width + Kit.tokens.space.m : 0)
        anchors.verticalCenter: parent.verticalCenter
        clip: true
        activeFocusOnTab: field.enabled      // a TextInput is not a stop for Tab by itself
        color: field.enabled ? Kit.tokens.inkMain : Kit.tokens.inkFaint
        readOnly: !field.enabled
        selectionColor: Qt.alpha(Kit.tokens.accent, 0.4)
        selectedTextColor: Kit.tokens.inkMain
        font.family: Kit.tokens.font.main
        font.pixelSize: Kit.tokens.size.row
        font.variableAxes: ({ "wght": Kit.tokens.weight.regular, "wdth": 100 })
        font.hintingPreference: Font.PreferNoHinting
        renderType: Text.NativeRendering
        cursorDelegate: Rectangle { width: 1.5; color: field.error ? Kit.tokens.risk : Kit.tokens.accent; visible: input.cursorVisible }
        onAccepted: field.accepted()
        onTextEdited: field.edited()
        Keys.onPressed: event => { Kit.focusVisible = true; }
        Accessible.role: Accessible.EditableText
        Accessible.name: field.label !== "" ? field.label : field.hint
        Accessible.description: field.error ? "Error: the entry is not valid" : ""
        Accessible.readOnly: !field.enabled
    }
    TacitText {
        id: endHint
        visible: field.persistentHint && input.text !== "" && field.hint !== ""
        anchors { right: parent.right; rightMargin: Kit.tokens.space.m; verticalCenter: parent.verticalCenter }
        text: field.hint; ink: field.enabled ? "meta" : "faint"
    }
    TacitText {
        visible: input.text === ""
        x: input.x; anchors.verticalCenter: parent.verticalCenter
        text: field.hint; ink: field.enabled ? "meta" : "faint"
    }
    HoverHandler { id: hover; cursorShape: Qt.IBeamCursor }
}
