// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// How you see a page's content, under its PageHeader (approved 2026-10-25). Right: Filter, the order (a MenuButton
// whose menu holds Sort by, Order, Group by and the page's own choices), the views as words (Tabs). Left: what is here
// ("9 items"), or, while filtering, the filter's FilterFields (put them inside). When the fields and the controls do
// not fit on one line, the fields take a line of their own. While a filter is on, how many are shown ("3 of 9") and
// Clear come after the fields, on the same line when all of it fits (the test counts their width), else on the
// fields' own line. Filter reports itself as checked to a screen reader while the fields are shown.
// Any app uses the same bar with its own fields: Files' Kind, Modified, Size; Music's Genre, Year.
Item {
    id: bar
    property string count: ""             // at rest: what is here
    property bool filtering: false         // the fields are shown (Filter is on, or a filter is)
    property bool active: false            // a filter is on
    property string shown: ""              // while active: "3 of 9"
    property string order: ""              // the order's word ("Newest first")
    property alias orderItems: orderButton.items
    property var views: []                 // the views as words ("List", "Grid", ...)
    property int view: 0
    property string label: "View"        // what a screen reader calls the bar
    default property alias fields: fieldsRow.data
    signal filterToggled()
    signal orderPicked(int index)
    signal viewPicked(int index)
    signal cleared()

    readonly property bool wrap: filtering && fieldsRow.implicitWidth + (active ? status.implicitWidth + Kit.tokens.space.xl : 0)
                                 + controls.implicitWidth + 64 > width
    implicitWidth: 900
    implicitHeight: wrap ? 2 * line : line
    readonly property int line: 44
    Accessible.role: Accessible.ToolBar
    Accessible.name: label

    TacitText {
        visible: !bar.filtering && bar.count !== ""
        x: 28; y: (bar.line - height) / 2
        text: bar.count; ink: "meta"; cut: "numbers"
    }
    Row {
        id: fieldsRow
        visible: bar.filtering
        x: Kit.tokens.space.l
        y: bar.wrap ? bar.line + (bar.line - height) / 2 : (bar.line - height) / 2
        spacing: 14
    }
    Row {
        id: status
        visible: bar.active
        x: fieldsRow.x + fieldsRow.implicitWidth + Kit.tokens.space.xl
        y: bar.wrap ? bar.line + (bar.line - height) / 2 : (bar.line - height) / 2
        spacing: 18
        TacitText { anchors.verticalCenter: parent.verticalCenter; text: bar.shown; ink: "meta"; cut: "numbers" }
        WordAction { anchors.verticalCenter: parent.verticalCenter; width: wordsWidth; text: "Clear"; onActivated: bar.cleared() }
    }
    Row {
        id: controls
        anchors.right: parent.right
        anchors.rightMargin: Kit.tokens.space.l
        y: (bar.line - height) / 2
        spacing: Kit.tokens.space.l
        MenuButton {
            anchors.verticalCenter: parent.verticalCenter
            text: "Filter"
            previewState: bar.filtering ? "hover" : ""
            Accessible.role: Accessible.Button
            Accessible.name: "Filter"
            Accessible.checkable: true
            Accessible.checked: bar.filtering
            // a toggle, not a menu (no items): the fields are its menus
            onActivated: bar.filterToggled()
        }
        MenuButton {
            id: orderButton
            anchors.verticalCenter: parent.verticalCenter
            text: bar.order
            onPicked: i => bar.orderPicked(i)
        }
        Tabs {
            anchors.verticalCenter: parent.verticalCenter
            labels: bar.views
            current: bar.view
            onPicked: i => bar.viewPicked(i)
        }
    }
}
