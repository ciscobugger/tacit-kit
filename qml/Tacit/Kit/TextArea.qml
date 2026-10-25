// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// Several lines to type in, inside a panel: the Field's look (a faint wash of the main ink on the panel's
// colour, the slab corner, words in the main ink, a hint in the meta ink while empty, the caret in the accent, the accent ring
// while typing) with the multi-line behaviour of Praxis's message box. The text wraps at the width. The box is
// `minLines` high (1 is a Field's 36) and grows with the text to `maxLines`, on the field-growing motion (250 ms),
// then scrolls, the caret kept in view. Enter makes a new line; Ctrl+Enter sends `submitted(text)` (the app decides
// what that does with the text); Esc sends `dismissed()` (the app closes the panel or gives the focus away). Tab moves
// on to the next control, it does not type a tab.
// `input` is the TextEdit, for selection ranges and keys. `error` puts the ring (always shown) and the caret in the
// risk ink and says so to a screen reader. `enabled: false`: words and hint in the faint ink, no hover, no caret, no
// keyboard, not editable, and a screen reader hears it as disabled. A screen reader hears a multi-line text entry
// named by `label`.
Item {
    id: area
    property alias text: input.text
    property string hint: ""
    property bool error: false
    property int minLines: 3
    property int maxLines: 8
    readonly property alias input: input
    property string label
    property string previewState: ""
    signal submitted(string text)
    signal dismissed()
    signal edited()

    readonly property bool hovered: enabled && (hover.hovered || previewState === "hover")
    readonly property real pad: Kit.tokens.space.s
    readonly property real line: lineMetrics.lineSpacing
    implicitWidth: 320
    // never shorter than a Field (36), so a one-line text area lines up with the fields beside it
    implicitHeight: Math.max(Kit.tokens.height.field, 2 * pad + Math.max(minLines * line, Math.min(maxLines * line, input.contentHeight)))
    Behavior on implicitHeight { NumberAnimation { duration: Kit.tokens.motion.arriveSmall.ms; easing.type: Easing.BezierSpline; easing.bezierCurve: Kit.tokens.motion.arriveSmall.curve } }
    Accessible.role: Accessible.EditableText
    Accessible.name: label
    Accessible.description: error ? "Error: the entry is not valid" : ""
    Accessible.multiLine: true

    function focusIn() { input.forceActiveFocus(); }

    FontMetrics {
        id: lineMetrics
        font.family: Kit.tokens.font.main
        font.pixelSize: Kit.tokens.size.row
    }
    Rectangle {
        anchors.fill: parent
        radius: Kit.tokens.radius.slab
        color: Kit.tokens.inkMain
        opacity: area.hovered && !input.activeFocus ? Kit.tokens.wash.action + Kit.tokens.wash.hover : Kit.tokens.wash.action
        Behavior on opacity { NumberAnimation { duration: Kit.tokens.motion.hover.ms } }
    }
    FocusRing {
        shown: area.enabled && (input.activeFocus || area.previewState === "focus" || area.error); corner: Kit.tokens.radius.slab
        border.color: area.error ? Kit.tokens.risk : Kit.tokens.accent
    }
    Flickable {
        id: flick
        x: Kit.tokens.space.m; y: area.pad
        width: parent.width - 2 * Kit.tokens.space.m; height: parent.height - 2 * area.pad
        contentWidth: width; contentHeight: input.contentHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        interactive: contentHeight > height

        TextEdit {
            id: input
            width: flick.width
            wrapMode: TextEdit.Wrap
            color: area.enabled ? Kit.tokens.inkMain : Kit.tokens.inkFaint
            readOnly: !area.enabled
            selectionColor: Qt.alpha(Kit.tokens.accent, 0.4)
            selectedTextColor: Kit.tokens.inkMain
            font.family: Kit.tokens.font.main
            font.pixelSize: Kit.tokens.size.row
            font.variableAxes: ({ "wght": Kit.tokens.weight.regular, "wdth": 100 })
            font.hintingPreference: Font.PreferNoHinting
            renderType: Text.NativeRendering
            activeFocusOnTab: area.enabled
            cursorDelegate: Rectangle { width: 1.5; color: area.error ? Kit.tokens.risk : Kit.tokens.accent; visible: input.cursorVisible }
            onTextChanged: area.edited()
            onCursorRectangleChanged: {
                const r = input.cursorRectangle;
                if (r.y < flick.contentY) flick.contentY = r.y;
                else if (r.y + r.height > flick.contentY + flick.height) flick.contentY = r.y + r.height - flick.height;
            }
            Keys.onPressed: event => {
                Kit.focusVisible = true;
                if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && (event.modifiers & Qt.ControlModifier)) {
                    area.submitted(input.text);
                    event.accepted = true;
                } else if (event.key === Qt.Key_Escape) {
                    area.dismissed();
                    event.accepted = true;
                } else if (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab) {
                    const next = input.nextItemInFocusChain(event.key === Qt.Key_Tab);
                    if (next) next.forceActiveFocus(event.key === Qt.Key_Tab ? Qt.TabFocusReason : Qt.BacktabFocusReason);
                    event.accepted = true;
                }
            }
        }
    }
    TacitText {
        visible: input.text === "" && input.preeditText === ""
        x: flick.x; y: area.pad
        width: flick.width
        text: area.hint; ink: area.enabled ? "meta" : "faint"
        wrapMode: Text.Wrap
    }
    HoverHandler { id: hover; enabled: area.enabled; cursorShape: Qt.IBeamCursor }
    TapHandler { enabled: area.enabled; onTapped: area.focusIn() }
}
