// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// What a run of rows is about (a day, a folder, an artist): body size, strong, the main ink, sat on the rows below.
Item {
    property alias text: label.text

    implicitWidth: label.implicitWidth + 2 * Kit.tokens.space.l
    implicitHeight: 50
    Accessible.role: Accessible.Heading
    Accessible.name: label.text

    TacitText {
        id: label
        x: Kit.tokens.space.l
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Kit.tokens.space.m
        size: "body"
        weight: "strong"
    }
}
