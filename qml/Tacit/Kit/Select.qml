// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A value chosen from a list, for a form or a settings row (the Settings app's RowMenu, which MenuButton shares): the
// current label in the secondary ink and the menu's chevron after it, on the Field's shape (36 high, slab corner, the
// faint wash) so it sits in a panel beside fields; a hover wash. It opens the kit's Menu under itself, aligned to its
// right, with the current option checked, and the keyboard on that option. `options` is a list of labels, or of
// { label, detail }; `current` the chosen index (-1 shows `hint` in the meta ink) and the app sets it when it hears
// `picked(index)`. One Tab stop. Closed, Up and Down choose the previous or next option without opening (as desktop
// selects do), Home and End the ends; Enter, Space or Alt+Down open the menu (Up and Down move in it, Enter picks, Esc
// closes and the select has the keyboard again). The focus ring after a key press. `enabled: false`: label and
// chevron in the faint ink, no hover, no keys. A screen reader hears a combo box named by `label` with the current
// label as its value.
// It is built on Menu, not on MenuButton: MenuButton opens on Down and is its own words-only button, the select needs
// Up and Down to choose and a field's fixed shape.
Item {
    id: select
    property var options: []
    property int current: -1
    property string hint: "Choose"
    property string label
    property string previewState: ""    // hover, focus, open
    signal picked(int index)

    readonly property string text: current >= 0 && current < options.length ? labelOf(options[current]) : ""
    readonly property bool opened: menu.opened || previewState === "open"
    readonly property bool hovered: enabled && (hover.hovered || previewState === "hover" || opened)

    implicitWidth: 220
    implicitHeight: Kit.tokens.height.field
    activeFocusOnTab: enabled
    Accessible.role: Accessible.ComboBox
    Accessible.name: label
    Accessible.description: text
    Accessible.onPressAction: select.show()

    function labelOf(o) { return typeof o === "string" ? o : (o.label ?? ""); }
    function show() {
        if (!select.enabled || select.options.length === 0) return;
        menu.items = select.options.map((o, i) => ({ label: select.labelOf(o), detail: typeof o === "string" ? "" : (o.detail ?? ""), checked: i === select.current }));
        menu.openAt(select, select.width - menu.implicitWidth, select.height + 6);
        menu.cursor = Math.max(0, select.current);
    }
    function move(to) {
        if (to >= 0 && to < select.options.length && to !== select.current) select.picked(to);
    }

    Rectangle {
        anchors.fill: parent
        radius: Kit.tokens.radius.slab
        color: Kit.tokens.inkMain
        opacity: select.hovered ? Kit.tokens.wash.action + Kit.tokens.wash.hover : Kit.tokens.wash.action
        Behavior on opacity { NumberAnimation { duration: Kit.tokens.motion.hover.ms } }
    }
    Item {
        anchors.fill: parent
        FocusRing { shown: select.enabled && ((select.activeFocus && Kit.focusVisible) || select.previewState === "focus"); corner: Kit.tokens.radius.slab }
    }
    TacitText {
        x: Kit.tokens.space.m
        width: parent.width - 2 * Kit.tokens.space.m - 4 - 18
        anchors.verticalCenter: parent.verticalCenter
        text: select.text !== "" ? select.text : select.hint
        elide: Text.ElideRight
        ink: !select.enabled ? "faint" : select.text === "" ? "meta" : select.hovered ? "main" : "sec"
    }
    Symbol {
        anchors { right: parent.right; rightMargin: Kit.tokens.space.s; verticalCenter: parent.verticalCenter }
        size: 18
        text: "expand_more"
        color: !select.enabled ? Kit.tokens.inkFaint : select.hovered ? Kit.tokens.inkMain : Kit.tokens.inkSec
    }
    HoverHandler { id: hover; enabled: select.enabled; cursorShape: Qt.PointingHandCursor }
    TapHandler { enabled: select.enabled; onTapped: { Kit.focusVisible = false; select.forceActiveFocus(); select.show(); } }
    Keys.onPressed: event => {
        Kit.focusVisible = true;
        if (!select.enabled) return;
        const c = select.current;
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space
                || (event.key === Qt.Key_Down && (event.modifiers & Qt.AltModifier))) select.show();
        else if (event.key === Qt.Key_Down) select.move(c < 0 ? 0 : c + 1);
        else if (event.key === Qt.Key_Up) select.move(c < 0 ? 0 : c - 1);
        else if (event.key === Qt.Key_Home) select.move(0);
        else if (event.key === Qt.Key_End) select.move(select.options.length - 1);
        else return;
        event.accepted = true;
    }
    Menu {
        id: menu
        onPicked: i => select.picked(i)
        onClosed: {
            let f = select.Window.activeFocusItem;
            while (f && f !== menu.contentItem) f = f.parent;
            if (f || !select.Window.activeFocusItem) select.forceActiveFocus();
        }
    }
}
