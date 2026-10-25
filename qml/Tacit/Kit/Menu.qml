// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick
import QtQuick.Controls

// A menu over the page (the sort order, a file's actions, More…). Solid, on the overlay colour, a faint edge, the slab
// corner; it fades in and grows from 0.96 (150 ms). Lines are words, 34 high; a choice in force carries a check; a
// risk goes last with the warning symbol; a rule separates groups. Up and Down move, Home and End, typing jumps,
// Enter or Space picks, Esc closes and gives the focus back to what opened it. After a key the line under the cursor
// has the focus ring (the pointer's line has the wash only). A screen reader hears a menu of menu items: a line with
// `checked` as a checkable one, a risk line as "<label>, warning", Press picks it.
//   items: [{ label, checked, risk, detail, rule, heading, keepOpen }]
//     label: the words (typing jumps to the next label that starts with the letter)
//     checked: a check before the words, the choice in force
//     risk: the warning symbol and the risk ink; goes last
//     detail: a quiet word or number at the line's end (a count, a key)
//     rule: true draws a separating line (not a line to pick; typing and the arrows skip it)
//     heading: true makes a group's name in the meta ink (not pressable; typing and the arrows skip it)
//     keepOpen: true picks without closing the menu (ticking several kinds in a filter)
Popup {
    id: menu
    property var items: []
    property int cursor: -1
    property bool previewOpen: false
    signal picked(int index)

    readonly property var t: Kit.tokens

    padding: 0
    implicitWidth: surface.implicitWidth
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    function openAt(item, x, y) {
        menu.parent = item;
        menu.x = x;
        menu.y = y;
        menu.cursor = -1;
        menu.open();
    }
    function pick(i) {
        if (i < 0 || menu.items[i].rule || menu.items[i].heading) return;
        menu.picked(i);
        if (menu.items[i].keepOpen !== true) menu.close();
    }
    function step(d) {
        let i = menu.cursor;
        for (let n = 0; n < menu.items.length; n++) {
            i = (i + d + menu.items.length) % menu.items.length;
            if (!menu.items[i].rule && !menu.items[i].heading) { menu.cursor = i; return; }
        }
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Kit.ms(menu.t.motion.fadeFast.ms); easing.type: Easing.BezierSpline; easing.bezierCurve: menu.t.motion.fadeFast.curve }
        NumberAnimation { property: "scale"; from: 0.96; to: 1; duration: Kit.ms(menu.t.motion.fadeFast.ms); easing.type: Easing.BezierSpline; easing.bezierCurve: menu.t.motion.fadeFast.curve }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Kit.ms(Kit.motion("dismiss").ms) }
    }

    background: null
    // a Popup is not an Item: the keys and the screen reader's node sit on its content
    contentItem: MenuSurface {
        id: surface
        items: menu.items
        cursor: menu.cursor
        focus: true
        keyboard: Kit.focusVisible
        onPicked: i => menu.pick(i)
        Accessible.role: Accessible.PopupMenu
        Keys.onPressed: event => {
            Kit.focusVisible = true;
            switch (event.key) {
            case Qt.Key_Down: menu.step(1); break;
            case Qt.Key_Up: menu.step(-1); break;
            case Qt.Key_Home: menu.cursor = -1; menu.step(1); break;
            case Qt.Key_End: menu.cursor = menu.items.length; menu.step(-1); break;
            case Qt.Key_Return:
            case Qt.Key_Enter:
            case Qt.Key_Space: menu.pick(menu.cursor); break;
            default:
                if (event.text.length === 1 && event.text.trim() !== "") {
                    const ch = event.text.toLowerCase();
                    for (let k = 1; k <= menu.items.length; k++) {
                        const i = (menu.cursor + k) % menu.items.length;
                        if (!menu.items[i].rule && !menu.items[i].heading && (menu.items[i].label ?? "").toLowerCase().startsWith(ch)) { menu.cursor = i; break; }
                    }
                    break;
                }
                return;
            }
            event.accepted = true;
        }
    }
}
