// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// One choice from a short set (the radio group), laid out as the menus show a choice in force: a column of lines of
// words, the chosen one carrying the menu's check (the accent) and set in the main ink and strong weight, as Tabs and the
// Settings choice row set the chosen word; the others in the secondary ink, a wash under the pointer. `model` is a
// list of labels, or of { label, detail } (a quiet line under the label in the meta ink). `current` is the chosen
// index and the app sets it when it hears `picked(index)`. For up to six; more is a Select. One Tab stop for the whole
// group; Up and Down (and Left and Right) move to the next or previous option and choose it, Home and End go to
// the ends, the focus ring on the chosen line after a key press. A click chooses. `enabled: false` sets every line in
// the faint ink and ignores pointer and keys. A screen reader hears a group named by `label` whose options are radio
// buttons, one checked.
Column {
    id: choices
    property var model: []
    property int current: -1
    property string label
    property string previewState: ""      // "focus" rings the chosen line; "hover" washes the second line
    signal picked(int index)

    activeFocusOnTab: enabled
    width: implicitWidth
    Accessible.role: Accessible.Grouping
    Accessible.name: label

    function labelOf(o) { return typeof o === "string" ? o : (o.label ?? ""); }
    function detailOf(o) { return typeof o === "string" ? "" : (o.detail ?? ""); }
    function move(to) {
        if (!choices.enabled || to < 0 || to >= choices.model.length || to === choices.current) return;
        choices.picked(to);
    }

    Keys.onPressed: event => {
        Kit.focusVisible = true;
        const c = Math.max(0, choices.current);
        const to = (event.key === Qt.Key_Down || event.key === Qt.Key_Right) ? (choices.current < 0 ? 0 : c + 1)
                 : (event.key === Qt.Key_Up || event.key === Qt.Key_Left) ? (choices.current < 0 ? 0 : c - 1)
                 : event.key === Qt.Key_Home ? 0 : event.key === Qt.Key_End ? choices.model.length - 1 : -1;
        if (to < 0) return;
        choices.move(to);
        event.accepted = true;
    }

    Repeater {
        model: choices.model
        Item {
            id: line
            required property var modelData
            required property int index
            readonly property bool chosen: index === choices.current
            readonly property bool hovered: choices.enabled && (lineHover.hovered || (choices.previewState === "hover" && index === 1))
            readonly property string detail: choices.detailOf(modelData)
            width: Math.max(180, Math.max(words.implicitWidth, note.visible ? note.implicitWidth : 0) + 34 + Kit.tokens.space.m)
            height: Math.max(Kit.tokens.height.menuRow, Kit.tokens.space.s * 2 + words.implicitHeight + (detail !== "" ? note.implicitHeight : 0))
            Accessible.role: Accessible.RadioButton
            Accessible.name: choices.labelOf(modelData)
            Accessible.description: detail
            Accessible.checkable: true
            Accessible.checked: chosen
            Accessible.onPressAction: choices.move(index)

            Rectangle {
                anchors.fill: parent
                radius: Kit.tokens.radius.row
                color: Kit.tokens.inkMain
                opacity: line.hovered ? Kit.tokens.wash.hover : 0
                Behavior on opacity { NumberAnimation { duration: Kit.tokens.motion.hover.ms } }
            }
            FocusRing { shown: line.chosen && choices.enabled && ((choices.activeFocus && Kit.focusVisible) || choices.previewState === "focus") }
            Symbol {
                visible: line.chosen
                x: 10; y: Kit.tokens.space.s + (words.implicitHeight - height) / 2
                size: 16
                text: "check"
                color: choices.enabled ? Kit.tokens.accent : Kit.tokens.inkFaint
            }
            TacitText {
                id: words
                x: 34; y: Kit.tokens.space.s
                text: choices.labelOf(line.modelData)
                weight: line.chosen ? "strong" : "regular"
                ink: !choices.enabled ? "faint" : line.chosen || line.hovered ? "main" : "sec"
            }
            TacitText {
                id: note
                visible: line.detail !== ""
                x: 34; y: Kit.tokens.space.s + words.implicitHeight
                text: line.detail
                size: "meta"; ink: choices.enabled ? "meta" : "faint"
            }
            HoverHandler { id: lineHover; enabled: choices.enabled; cursorShape: Qt.PointingHandCursor }
            TapHandler { enabled: choices.enabled; onTapped: { Kit.focusVisible = false; choices.forceActiveFocus(); choices.move(line.index); } }
        }
    }
}
