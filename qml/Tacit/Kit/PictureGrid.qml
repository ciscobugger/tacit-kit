// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick
import QtQuick.Effects

// Pictures by group (the day they were taken), each at its own shape: rows about `rowHeight` high, 6 apart, filled
// edge to edge; a picture never stands alone on a row (a lone last one joins the row above). A heading over each group.
// The selection is a wash over the picture (the pressed amount: 22 %, so it shows on a photograph), which keeps its size; the cursor, while the keyboard has it, is
// the focus ring 4 px around its picture (never the selection's mark, so the two read apart). `label` names the grid for
// a screen reader ("Pictures"). It is one tab stop and owns the keyboard as a RowList does: ← → step, ↑ ↓ go to the nearest picture in the row above or below, Home End, Shift
// extends, Ctrl+A, Enter opens; click, Ctrl+click and Shift+click as in a list; double-click opens.
// `pictures`: [{ source, ratio (width / height), group, name }], in the order they are shown. Only the rows on screen
// are made.
FocusScope {
    id: grid
    property var pictures: []
    property real rowHeight: 200
    property real gap: 6
    property int cursor: -1
    property var selection: ({})
    property int selectionCount: 0
    property int anchorIndex: -1
    property string label: "Pictures"
    property int previewHover: -1        // a picture shown under the pointer, for the catalogue and the docs
    signal activated(int index)
    signal contextRequested(int index, point at)

    readonly property int count: pictures.length
    readonly property int ringRoom: 6    // the selection ring reaches 4 px past a picture, 2 px wide
    activeFocusOnTab: true
    Accessible.role: Accessible.List
    Accessible.name: label
    implicitWidth: 900
    implicitHeight: 600

    // the layout: headings and rows of cells, for the ListView; place[i] = [row, cell] for the keyboard
    readonly property var layout: {
        const W = Math.max(1, view.width - 2 * grid.ringRoom), H = grid.rowHeight, g = grid.gap, P = grid.pictures;
        const rows = [], place = [];
        let k = 0;
        while (k < P.length) {
            const group = P[k].group ?? "";
            const items = [];
            while (k < P.length && (P[k].group ?? "") === group) { items.push(k); k++; }
            if (group !== "") rows.push({ heading: group });
            // fill rows until they are no taller than H
            let lines = [], line = [], sum = 0;
            for (const i of items) {
                line.push(i); sum += P[i].ratio ?? 1.5;
                if ((W - g * (line.length - 1)) / sum <= H) { lines.push(line); line = []; sum = 0; }
            }
            if (line.length) {
                if (line.length === 1 && lines.length) lines[lines.length - 1] = lines[lines.length - 1].concat(line);
                else lines.push(line);
            }
            for (const l of lines) {
                const total = l.reduce((t, i) => t + (P[i].ratio ?? 1.5), 0);
                let h = (W - g * (l.length - 1)) / total;
                if (h > H * 1.3) h = H;       // a short last row keeps the usual height, not a giant one
                let x = 0;
                const cells = [];
                for (const i of l) {
                    const w = (P[i].ratio ?? 1.5) * h;
                    place[i] = [rows.length, cells.length];
                    cells.push({ i: i, x: x, w: w });
                    x += w + g;
                }
                rows.push({ cells: cells, h: h });
            }
        }
        return { rows: rows, place: place };
    }

    function isSelected(i) { return grid.selectionCount >= 0 && grid.selection[i] === true; }
    function setSelection(indexes) {
        const s = {};
        for (const i of indexes) s[i] = true;
        grid.selection = s;
        grid.selectionCount = indexes.length;
    }
    function selected() { return Object.keys(grid.selection).map(Number).sort((a, b) => a - b); }
    function moveTo(i, how) {
        if (grid.count === 0) return;
        i = Math.max(0, Math.min(grid.count - 1, i));
        if (how === "extend") {
            if (grid.anchorIndex < 0) grid.anchorIndex = grid.cursor < 0 ? i : grid.cursor;
            const a = Math.min(grid.anchorIndex, i), b = Math.max(grid.anchorIndex, i);
            const r = [];
            for (let k = a; k <= b; k++) r.push(k);
            grid.setSelection(r);
        } else {
            grid.anchorIndex = i;
            grid.setSelection([i]);
        }
        grid.cursor = i;
        const p = grid.layout.place[i];
        if (p) view.positionViewAtIndex(p[0], ListView.Contain);
    }
    // the picture in the row above or below whose middle is nearest this one's
    function vertical(from, by) {
        const L = grid.layout, p = L.place[from];
        if (!p) return from;
        const c = L.rows[p[0]].cells[p[1]], mid = c.x + c.w / 2;
        for (let r = p[0] + by; r >= 0 && r < L.rows.length; r += by) {
            const cells = L.rows[r].cells;
            if (!cells) continue;     // a heading
            let best = cells[0];
            for (const d of cells) if (Math.abs(d.x + d.w / 2 - mid) < Math.abs(best.x + best.w / 2 - mid)) best = d;
            return best.i;
        }
        return from;
    }
    function clickAt(i, modifiers) {
        grid.forceActiveFocus(Qt.MouseFocusReason);
        Kit.focusVisible = false;
        if (modifiers & Qt.ShiftModifier) {
            grid.moveTo(i, "extend");
        } else if (modifiers & Qt.ControlModifier) {
            const s = Object.assign({}, grid.selection);
            if (s[i]) delete s[i]; else s[i] = true;
            grid.selection = s;
            grid.selectionCount = Object.keys(s).length;
            grid.cursor = i;
            grid.anchorIndex = i;
        } else {
            grid.moveTo(i, "select");
        }
    }

    ListView {
        id: view
        anchors.fill: parent
        anchors.margins: -grid.ringRoom
        leftMargin: grid.ringRoom; rightMargin: grid.ringRoom; topMargin: grid.ringRoom; bottomMargin: grid.ringRoom
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        reuseItems: true
        model: grid.layout.rows
        delegate: Item {
            id: line
            required property var modelData
            width: view.width - 2 * grid.ringRoom
            height: modelData.heading !== undefined ? 50 : modelData.h + grid.gap
            SectionHeading { visible: line.modelData.heading !== undefined; x: -Kit.tokens.space.l; text: line.modelData.heading ?? "" }
            Repeater {
                model: line.modelData.cells ?? []
                Item {
                    id: cell
                    required property var modelData
                    readonly property int i: modelData.i
                    readonly property bool chosen: grid.isSelected(i)
                    readonly property bool hovered: hover.hovered || grid.previewHover === i
                    x: modelData.x; width: modelData.w; height: line.modelData.h
                    Accessible.role: Accessible.ListItem
                    Accessible.name: grid.pictures[cell.i]?.name ?? ""
                    Accessible.selected: cell.chosen

                    Image {
                        id: pic
                        visible: false
                        anchors.fill: parent
                        source: grid.pictures[cell.i]?.source ?? ""
                        sourceSize: Qt.size(cell.width * 2, cell.height * 2)
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                    }
                    Rectangle { id: mask; visible: false; anchors.fill: parent; radius: Kit.tokens.radius.row; layer.enabled: true }
                    MultiEffect { anchors.fill: parent; source: pic; maskEnabled: true; maskSource: mask }
                    Rectangle {
                        anchors.fill: parent
                        radius: Kit.tokens.radius.row
                        color: Kit.tokens.inkMain
                        opacity: tap.pressed ? Kit.tokens.wash.pressed
                            : cell.chosen ? Kit.tokens.wash.pressed
                            : cell.hovered ? Kit.tokens.wash.hover : 0
                        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
                    }
                    FocusRing { shown: grid.activeFocus && Kit.focusVisible && cell.i === grid.cursor; corner: Kit.tokens.radius.row }
                    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
                    TapHandler {
                        id: tap
                        onTapped: (point, button) => grid.clickAt(cell.i, point.modifiers)
                        onDoubleTapped: grid.activated(cell.i)
                    }
                    TapHandler {
                        acceptedButtons: Qt.RightButton
                        onTapped: (point) => {
                            if (!grid.isSelected(cell.i)) grid.clickAt(cell.i, 0);
                            grid.contextRequested(cell.i, point.position);
                        }
                    }
                }
            }
        }
    }
    Glide { view: view }

    Keys.onPressed: event => {
        Kit.focusVisible = true;
        const shift = event.modifiers & Qt.ShiftModifier, ctrl = event.modifiers & Qt.ControlModifier;
        const how = shift ? "extend" : "select";
        const at = grid.cursor;
        switch (event.key) {
        case Qt.Key_Right: grid.moveTo(at + 1, how); break;
        case Qt.Key_Left: grid.moveTo(at < 0 ? 0 : at - 1, how); break;
        case Qt.Key_Down: grid.moveTo(at < 0 ? 0 : grid.vertical(at, 1), how); break;
        case Qt.Key_Up: grid.moveTo(at < 0 ? 0 : grid.vertical(at, -1), how); break;
        case Qt.Key_Home: grid.moveTo(0, how); break;
        case Qt.Key_End: grid.moveTo(grid.count - 1, how); break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
            if (grid.cursor >= 0) grid.activated(grid.cursor);
            break;
        case Qt.Key_Menu:
            if (grid.cursor >= 0) grid.contextRequested(grid.cursor, Qt.point(view.width / 2, 0));
            break;
        case Qt.Key_A:
            if (!ctrl) return;
            grid.setSelection(grid.pictures.map((p, k) => k));
            break;
        default:
            return;
        }
        event.accepted = true;
    }
}
