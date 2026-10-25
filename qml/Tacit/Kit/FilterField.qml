// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// One field of a filter, in a ViewBar: its name in the meta ink, its value as a menu (Kind: Any, Modified: Last 7
// days), and while it is on, an ✕ that takes it off. The app gives the menu's lines (Menu items: tick several with
// keepOpen; counts as details) and sets `value` and `on` from its own filter. The ✕ is 28 square.
Row {
    id: field
    property string label
    property string value
    property bool on: false
    property alias items: button.items
    signal picked(int index)
    signal cleared()

    spacing: 0
    Accessible.role: Accessible.Grouping
    Accessible.name: label

    TacitText { anchors.verticalCenter: parent.verticalCenter; text: field.label; ink: "meta"; rightPadding: 2 }
    MenuButton {
        id: button
        anchors.verticalCenter: parent.verticalCenter
        text: field.value
        previewState: field.on ? "hover" : ""
        onPicked: i => field.picked(i)
    }
    IconButton {
        visible: field.on
        anchors.verticalCenter: parent.verticalCenter
        width: 28; height: 28
        symbol: "close"; size: 16
        label: "Remove the " + field.label + " filter"
        onActivated: field.cleared()
    }
}
