// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A list of ListRows that is one tab stop and owns the keyboard: Up and Down move, Home and End, Page Up and Down,
// Shift extends the selection from where it started, Ctrl moves without selecting and Ctrl+Space toggles, Ctrl+A
// selects all, Enter opens (activated), Space asks for a look without opening (peeked: the app's docked panel),
// F2 asks to rename the row with the cursor (editRequested: the app sets that row's `editing`, see ListRow; the row
// takes the keyboard while it edits and these keys do nothing then), typing jumps to the first name that starts with
// what was typed. A click selects one,
// Ctrl+click toggles, Shift+click extends. The app gives the delegate (a ListRow) and binds it to the list:
//     width: list.rowWidth (the list's own width); selected: list.isSelected(index); ring: list.ringAt(index); focusable: false
//     joinAbove: list.isSelected(index - 1); joinBelow: list.isSelected(index + 1)
//     onClicked: m => list.clickAt(index, m); onActivated: list.activated(index)
// Rows start at the list's left edge. For rows beside something (a cover), make the delegate an Item of rowWidth that
// holds the ListRow at x: inset, width: rowWidth - inset; selection, ring and joins still come from the list.
// nameAt(i) tells type-to-jump each row's name (the model's `name` role by default).
FocusScope {
    id: list

    property alias model: view.model
    property alias delegate: view.delegate
    property alias section: view.section
    property alias view: view
    property int cursor: -1
    property var selection: ({})
    property int selectionCount: 0
    property int anchorIndex: -1
    property string label: "List"     // what a screen reader calls the list

    signal activated(int index)
    signal peeked(int index)
    signal editRequested(int index)
    signal contextRequested(int index, point at)

    readonly property int count: view.count
    // the list clips its rows; its view reaches this far past the list's edges so the focus ring (2 px, 2 px out)
    // stays whole while the rows themselves line up with the list's box, and with headings and headers above it
    readonly property int ringSpace: Kit.tokens.state.focusGap + Kit.tokens.state.focusRing
    readonly property real rowWidth: list.width
    property string typed: ""

    function nameAt(i) {
        const m = view.model;
        const item = Array.isArray(m) ? m[i] : m.get ? m.get(i) : null;
        return item ? String(item.name ?? "") : "";
    }
    function isSelected(i) {
        return list.selectionCount >= 0 && list.selection[i] === true;
    }
    function ringAt(i) {
        return list.activeFocus && i === list.cursor;
    }
    function setSelection(indexes) {
        const s = {};
        for (const i of indexes) s[i] = true;
        list.selection = s;
        list.selectionCount = indexes.length;
    }
    function selected() {
        return Object.keys(list.selection).map(Number).sort((a, b) => a - b);
    }
    function moveTo(i, how) {
        if (list.count === 0) return;
        i = Math.max(0, Math.min(list.count - 1, i));
        if (how === "extend") {
            if (list.anchorIndex < 0) list.anchorIndex = list.cursor < 0 ? i : list.cursor;
            const a = Math.min(list.anchorIndex, i), b = Math.max(list.anchorIndex, i);
            const r = [];
            for (let k = a; k <= b; k++) r.push(k);
            list.setSelection(r);
        } else if (how !== "cursor") {
            list.anchorIndex = i;
            list.setSelection([i]);
        }
        list.cursor = i;
        view.positionViewAtIndex(i, ListView.Contain);
    }
    function clickAt(i, modifiers) {
        list.forceActiveFocus(Qt.MouseFocusReason);
        if (modifiers & Qt.ShiftModifier) {
            list.moveTo(i, "extend");
        } else if (modifiers & Qt.ControlModifier) {
            const s = Object.assign({}, list.selection);
            if (s[i]) delete s[i]; else s[i] = true;
            list.selection = s;
            list.selectionCount = Object.keys(s).length;
            list.cursor = i;
            list.anchorIndex = i;
        } else {
            list.moveTo(i, "select");
        }
    }

    activeFocusOnTab: true
    Accessible.role: Accessible.List
    Accessible.name: label
    implicitWidth: 480
    implicitHeight: 400

    ListView {
        id: view
        anchors.fill: parent
        anchors.margins: -list.ringSpace
        clip: true
        leftMargin: list.ringSpace
        rightMargin: list.ringSpace
        topMargin: list.ringSpace
        bottomMargin: list.ringSpace
        boundsBehavior: Flickable.StopAtBounds
        keyNavigationEnabled: false
        reuseItems: true
    }
    Glide { view: view }

    // typing pauses for 0.8 s and starts again
    Timer { id: typeReset; interval: 800; onTriggered: list.typed = "" }

    Keys.onPressed: event => {
        Kit.focusVisible = true;
        const shift = event.modifiers & Qt.ShiftModifier, ctrl = event.modifiers & Qt.ControlModifier;
        const how = shift ? "extend" : ctrl ? "cursor" : "select";
        const page = Math.max(1, Math.floor(view.height / Kit.tokens.height.row) - 1);
        const at = list.cursor < 0 ? -1 : list.cursor;
        switch (event.key) {
        case Qt.Key_Down: list.moveTo(at + 1, how); break;
        case Qt.Key_Up: list.moveTo(at < 0 ? 0 : at - 1, how); break;
        case Qt.Key_Home: list.moveTo(0, how); break;
        case Qt.Key_End: list.moveTo(list.count - 1, how); break;
        case Qt.Key_PageDown: list.moveTo(at + page, how); break;
        case Qt.Key_PageUp: list.moveTo(at - page, how); break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
            if (list.cursor >= 0) list.activated(list.cursor);
            break;
        case Qt.Key_F2:
            if (list.cursor >= 0) list.editRequested(list.cursor);
            break;
        case Qt.Key_Menu:
            if (list.cursor >= 0) list.contextRequested(list.cursor, Qt.point(view.width / 2, 0));
            break;
        case Qt.Key_Space:
            if (ctrl && list.cursor >= 0) list.clickAt(list.cursor, Qt.ControlModifier);
            else if (list.cursor >= 0) list.peeked(list.cursor);
            break;
        case Qt.Key_A:
            if (ctrl) {
                const r = [];
                for (let k = 0; k < list.count; k++) r.push(k);
                list.setSelection(r);
                break;
            }
            // fall through to typing
        default:
            if (event.text.length === 1 && !ctrl && event.text.trim() !== "") {
                list.typed += event.text.toLowerCase();
                typeReset.restart();
                for (let k = 0; k < list.count; k++) {
                    if (list.nameAt(k).toLowerCase().startsWith(list.typed)) { list.moveTo(k, "select"); break; }
                }
                break;
            }
            return;
        }
        event.accepted = true;
    }
}
