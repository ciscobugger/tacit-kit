// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A tooltip's look: the name of what is under the pointer, on the menus' overlay colour (Praxis's), 13 px in the main
// ink, corner 8. Only for things that show no words of their own (a symbol button, a folded rail's row).
Rectangle {
    property alias text: words.text
    implicitWidth: words.implicitWidth + 2 * 10
    implicitHeight: words.implicitHeight + 2 * 6
    radius: Kit.tokens.radius.row
    color: Kit.tokens.overlay
    border.width: 1
    border.color: Qt.alpha(Kit.tokens.inkMain, 0.08)
    TacitText { id: words; anchors.centerIn: parent; size: "meta" }
}
