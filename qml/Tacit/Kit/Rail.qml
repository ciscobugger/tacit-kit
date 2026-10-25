// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// The app's places down the left edge (Praxis's rail): 300 wide, a hairline on its right; the toggle at the top folds
// it to 56, its symbols only, and back. One action may sit at the top (Music's Shuffle all). Put RailSection and
// RailRow inside it; they scroll when there are more than fit. The rail is one stop for Tab: it lands on the current
// row, and ↑ ↓ Home End move between rows, scrolling the places so the row with the keyboard is in view. Folded, a row names
// itself in a tooltip (RailRow) for the pointer and the keyboard. Folding is the toggle's alone: the rail never opens under a passing pointer. The toggle names itself in a tooltip (its `tip`), for the pointer and the keyboard.
// `foot` takes RailRows kept at the rail's bottom, 16 from the edge (Trash in Files); the places scroll above them.
Item {
    id: rail
    property bool folded: false
    property string action: ""          // the one action at the top, its words
    property string actionSymbol: ""
    default property alias content: column.data
    property alias foot: footColumn.data
    signal toggle()
    signal actionActivated()

    readonly property bool isTacitRail: true
    property var rows: []               // the RailRows inside, as they register

    implicitWidth: folded ? Kit.tokens.width.railFolded : Kit.tokens.width.rail
    implicitHeight: 600
    width: implicitWidth
    clip: true
    Behavior on implicitWidth {
        NumberAnimation {
            duration: Kit.ms(rail.folded ? Kit.tokens.motion.leave.ms : Kit.tokens.motion.arrive.ms)
            easing.type: Easing.BezierSpline
            easing.bezierCurve: rail.folded ? Kit.tokens.motion.leave.curve : Kit.tokens.motion.arrive.curve
        }
    }
    Accessible.role: Accessible.Pane
    Accessible.name: "Places"

    // the rows in the order they stand, the ones shown and available (a disabled row is no stop)
    function ordered() {
        return rail.rows.filter(r => r.visible && r.enabled).sort((a, b) => a.mapToItem(rail, 0, 0).y - b.mapToItem(rail, 0, 0).y);
    }
    function step(from, by) {
        const list = rail.ordered();
        const i = list.indexOf(from);
        const to = by === -Infinity ? list[0] : by === Infinity ? list[list.length - 1]
                 : list[Math.max(0, Math.min(list.length - 1, i + by))];
        if (to) to.forceActiveFocus();
    }
    // scroll the places so a focused row is whole in view (the arrows, and Tab landing on a row that is out of sight)
    function reveal(row) {
        let inside = false;
        for (let p = row; p; p = p.parent) if (p === column) inside = true;
        if (!inside) return;
        const room = Kit.tokens.state.focusGap + Kit.tokens.state.focusRing;
        const y = row.mapToItem(column, 0, 0).y;
        if (y - room < places.contentY) places.contentY = Math.max(0, y - room);
        else if (y + row.height + room > places.contentY + places.height)
            places.contentY = Math.min(places.contentHeight - places.height, y + row.height + room - places.height);
    }
    // the one row Tab lands on: the current one, else the first
    function tabStop(row) {
        const list = rail.ordered();
        const cur = list.find(r => r.current);
        return row === (cur ?? list[0]);
    }

    Rectangle { anchors.right: parent.right; width: 1; height: parent.height; color: Kit.tokens.hairline }
    IconButton {
        x: rail.folded ? (Kit.tokens.width.railFolded - width) / 2 : 12; y: 8
        symbol: rail.folded ? "left_panel_open" : "left_panel_close"
        label: rail.folded ? "Show the places" : "Fold the places"
        tip: label
        onActivated: rail.toggle()
    }
    // the one action: a wash of its own, the symbol and its words in the main ink
    Item {
        id: act
        visible: rail.action !== ""
        // folded, the action keeps its place as its symbol, its wash as wide as a row's
        x: rail.folded ? 8 : 12; y: 52
        width: rail.width - 2 * x; height: 36
        readonly property bool hovered: actHover.hovered
        activeFocusOnTab: visible
        Accessible.role: Accessible.Button
        Accessible.name: rail.action
        Accessible.onPressAction: rail.actionActivated()
        Rectangle {
            anchors.fill: parent
            radius: Kit.tokens.radius.row
            color: Kit.tokens.inkMain
            opacity: actTap.pressed ? Kit.tokens.wash.pressed : act.hovered ? Kit.tokens.wash.current : Kit.tokens.wash.action
            Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
        }
        FocusRing { shown: act.activeFocus && Kit.focusVisible }
        Symbol { x: rail.folded ? (act.width - width) / 2 : 8; anchors.verticalCenter: parent.verticalCenter; text: rail.actionSymbol; size: Kit.tokens.icon.rail; color: Kit.tokens.inkMain }
        TacitText {
            x: 32; anchors.verticalCenter: parent.verticalCenter
            text: rail.action; weight: "medium"
            opacity: rail.folded ? 0 : 1
            Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.fadeFast.ms) } }
        }
        HoverHandler { id: actHover; cursorShape: Qt.PointingHandCursor }
        TapHandler { id: actTap; onTapped: { Kit.focusVisible = false; rail.actionActivated(); } }
        Keys.onPressed: event => {
            Kit.focusVisible = true;
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                rail.actionActivated();
                event.accepted = true;
            }
        }
    }
    Flickable {
        id: places
        y: rail.action !== "" ? 52 + 36 + Kit.tokens.space.l : 52
        width: Kit.tokens.width.rail
        height: rail.height - y - footRoom
        readonly property real footRoom: footColumn.height > 0 ? footColumn.height + Kit.tokens.space.l : 0
        contentHeight: column.implicitHeight + Kit.tokens.space.l
        boundsBehavior: Flickable.StopAtBounds
        Column { id: column; width: rail.width }
    }
    Column {
        id: footColumn
        anchors { bottom: parent.bottom; bottomMargin: Kit.tokens.space.l }
        width: rail.width
    }
    Glide { view: places }
}
