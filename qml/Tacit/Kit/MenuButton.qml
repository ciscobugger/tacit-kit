// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// Words that open a menu (the sort order: "Newest first ⌄"). The search field's padding and shape, so header tools
// line up: a hover wash on that shape, the chevron after the words, the menu opening under it, aligned to its right.
// When the menu closes the button has the keyboard again (opened by pointer or by key), unless the click that closed it
// landed on something else that took the keyboard.
// With no items it is a button that shows more of the page (a ViewBar's Filter): `activated` instead of a menu.
Item {
    id: button
    property string text
    property alias items: menu.items
    property string previewState: ""
    signal picked(int index)
    signal activated()

    readonly property bool hovered: hover.hovered || previewState === "hover" || menu.opened

    implicitWidth: 12 + words.implicitWidth + 4 + 18 + 8
    implicitHeight: Kit.tokens.height.field
    activeFocusOnTab: true
    Accessible.role: Accessible.ButtonMenu
    Accessible.name: button.text
    Accessible.onPressAction: button.show()

    function show() {
        if (button.items.length === 0) { button.activated(); return; }
        menu.openAt(button, button.width - menu.implicitWidth, button.height + 6);
    }

    Rectangle {
        anchors.fill: parent
        radius: Kit.tokens.radius.slab
        color: Kit.tokens.inkMain
        opacity: tap.pressed ? Kit.tokens.wash.current : button.hovered ? Kit.tokens.wash.hover : 0
        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
    }
    Item {
        anchors.fill: parent
        FocusRing { shown: (button.activeFocus && Kit.focusVisible) || button.previewState === "focus"; corner: Kit.tokens.radius.slab }
    }
    TacitText {
        id: words
        x: 12
        anchors.verticalCenter: parent.verticalCenter
        text: button.text
        ink: button.hovered ? "main" : "sec"
    }
    Symbol {
        x: words.x + words.implicitWidth + 4
        anchors.verticalCenter: parent.verticalCenter
        size: 18
        text: "expand_more"
        color: button.hovered ? Kit.tokens.inkMain : Kit.tokens.inkSec
    }
    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
    TapHandler { id: tap; onTapped: { Kit.focusVisible = false; button.show(); } }
    Keys.onPressed: event => {
        Kit.focusVisible = true;
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space || event.key === Qt.Key_Down) {
            button.show();
            menu.cursor = 0;
            event.accepted = true;
        }
    }
    Menu {
        id: menu
        onPicked: i => button.picked(i)
        onClosed: {
            // the focus is the menu's own, or nobody's, when nothing else claimed it
            let f = button.Window.activeFocusItem;
            while (f && f !== menu.contentItem) f = f.parent;
            if (f || !button.Window.activeFocusItem) button.forceActiveFocus();
        }
    }
}
