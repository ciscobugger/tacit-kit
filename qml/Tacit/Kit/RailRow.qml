// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A place in the rail: 32 high (its target is the whole row), its symbol at 20 (17 px), its name at 44, what it holds at the end in the meta ink (a
// count, how full). The wash is inset 8: 5 % under the pointer, 10 % where you are, with the accent tick at its edge and
// the name in medium weight. `fresh` puts an accent dot at the end instead: something arrived since you last looked.
// Folded, only the symbol shows. `dropTarget` rings the wash in the accent (1.5 px) while something that can be
// dropped hovers the row; `attention` draws the symbol in the accent: something there needs you. `accessory` takes
// items for the row's end (an eject button); while one is shown it replaces the context and the dot.
// `enabled: false` is a place that is not available now (a drive that is not there): the symbol, name and count in the
// faint ink, no wash under the pointer, no press, not a stop for Tab or the arrows (the rail skips it), and a screen
// reader hears it as disabled. A screen reader also hears `attention`, `fresh` and `dropTarget` (in the description).
// Folded, the row's name shows in a tooltip beside it while the pointer rests on it or the keyboard is on it.
Item {
    id: row
    property string glyph
    property string label
    property string context: ""
    property bool current: false
    property bool fresh: false
    property bool dropTarget: false
    property bool attention: false
    property alias accessory: accessoryRow.data
    property string previewState: ""
    signal picked(int modifiers)
    signal contextRequested(point at)

    property Item rail: null
    readonly property bool folded: rail?.folded ?? false
    readonly property bool hovered: enabled && (hover.hovered || previewState === "hover")
    readonly property bool down: enabled && (tap.pressed || previewState === "pressed")
    readonly property bool lit: current || hovered
    readonly property bool hasAccessory: accessoryRow.visibleChildren.length > 0 && !folded

    width: rail?.width ?? Kit.tokens.width.rail
    height: Kit.tokens.height.railRow
    activeFocusOnTab: enabled && (rail ? rail.tabStop(row) : true)
    Accessible.role: Accessible.ListItem
    Accessible.name: context !== "" ? label + ", " + context : label
    Accessible.description: [attention ? "Needs attention" : "", fresh ? "New" : "", dropTarget ? "Drop here" : ""].filter(d => d !== "").join(", ")
    Accessible.selected: current
    Accessible.onPressAction: row.picked(0)

    onActiveFocusChanged: if (activeFocus && rail) rail.reveal(row)
    readonly property bool tipShown: folded && (hovered || (activeFocus && Kit.focusVisible) || previewState === "focus")

    Component.onCompleted: {
        for (let p = parent; p; p = p.parent)
            if (p.isTacitRail) { row.rail = p; p.rows = p.rows.concat([row]); break; }
    }
    Component.onDestruction: if (rail) rail.rows = rail.rows.filter(r => r !== row)

    Rectangle {
        id: wash
        anchors { fill: parent; leftMargin: 8; rightMargin: 8; topMargin: 1; bottomMargin: 1 }
        radius: Kit.tokens.radius.row
        color: Kit.tokens.inkMain
        opacity: row.down ? Kit.tokens.wash.pressed : row.current ? (row.hovered ? Kit.tokens.wash.currentHover : Kit.tokens.wash.current)
               : row.hovered ? Kit.tokens.wash.hover : 0
        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
    }
    Rectangle {
        anchors.fill: wash
        visible: row.dropTarget
        radius: wash.radius
        color: "transparent"
        border.width: 1.5
        border.color: Kit.tokens.accent
    }
    FocusRing {
        anchors { fill: wash; margins: -(Kit.tokens.state.focusGap + Kit.tokens.state.focusRing) }
        shown: (row.activeFocus && Kit.focusVisible) || row.previewState === "focus"
    }
    // where you are: the accent tick at the wash's edge
    Rectangle {
        visible: row.current && !row.folded
        x: 8; y: 8; width: 3; height: 16; radius: 1.5
        color: Kit.tokens.accent
    }
    Symbol {
        x: 20; anchors.verticalCenter: parent.verticalCenter
        text: row.glyph
        size: Kit.tokens.icon.rail
        color: !row.enabled ? Kit.tokens.inkFaint : row.attention ? Kit.tokens.accent : row.lit ? Kit.tokens.inkMain : Kit.tokens.inkMeta
    }
    TacitText {
        anchors { left: parent.left; leftMargin: 44; right: row.hasAccessory ? accessoryRow.left : end.left; rightMargin: Kit.tokens.space.s; verticalCenter: parent.verticalCenter }
        text: row.label
        elide: Text.ElideRight
        ink: !row.enabled ? "faint" : row.lit ? "main" : "sec"
        weight: row.current ? "medium" : "regular"
        opacity: row.folded ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.fadeFast.ms) } }
    }
    Item {
        id: end
        anchors { right: parent.right; rightMargin: 20; verticalCenter: parent.verticalCenter }
        width: row.fresh ? 6 : held.implicitWidth
        height: 16
        opacity: row.folded || row.hasAccessory ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.fadeFast.ms) } }
        TacitText {
            id: held
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            visible: !row.fresh && row.context !== ""
            text: row.context
            size: "meta"; ink: row.enabled ? "meta" : "faint"; cut: "numbers"
        }
        Rectangle {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            visible: row.fresh
            width: 6; height: 6; radius: width / 2
            color: Kit.tokens.accent
        }
    }
    Row {
        id: accessoryRow
        anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
        visible: !row.folded
    }
    // folded, the name is not on the row: it shows beside the symbol, 4 px from the rail's edge
    Tooltip { text: row.label; shown: row.tipShown; x: row.width + Kit.tokens.space.xs; y: (row.height - height) / 2 }
    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
    TapHandler {
        id: tap
        onTapped: (point) => { Kit.focusVisible = false; row.picked(point.modifiers); }
    }
    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: (point) => row.contextRequested(point.position)
    }
    Keys.onPressed: event => {
        Kit.focusVisible = true;
        const k = event.key;
        if (k === Qt.Key_Return || k === Qt.Key_Enter || k === Qt.Key_Space) row.picked(event.modifiers);
        else if (k === Qt.Key_Menu) row.contextRequested(Qt.point(row.width / 2, row.height / 2));
        else if (row.rail && k === Qt.Key_Up) row.rail.step(row, -1);
        else if (row.rail && k === Qt.Key_Down) row.rail.step(row, 1);
        else if (row.rail && k === Qt.Key_Home) row.rail.step(row, -Infinity);
        else if (row.rail && k === Qt.Key_End) row.rail.step(row, Infinity);
        else return;
        event.accepted = true;
    }
}
