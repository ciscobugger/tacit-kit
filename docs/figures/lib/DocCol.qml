// One column of a states strip: equal columns across the stage, inset 16 px at both stage edges, a divider before every
// column but the first, a marker on top and a body 8 px inside the column on each side (room for a ring or wash that
// reaches 4 px past its part). Put the column's content into the body; `parent.width` there is the body's width.
import QtQuick
import Tacit.Kit

Item {
    id: col
    property int slot
    property int count: 4
    property bool marker: true
    readonly property real edge: 16
    readonly property real colW: (parent.width - 2 * edge) / count
    x: edge + slot * colW; width: colW; height: parent.height
    default property alias content: body.data
    readonly property alias body: body
    Rectangle { visible: col.slot > 0; width: 1; height: parent.height; color: Qt.alpha(Kit.tokens.inkMain, 0.10) }
    DocMarker { visible: col.marker; n: col.slot + 1; anchors.horizontalCenter: parent.horizontalCenter; y: 24 }
    // the content region: below the marker (24 px from the top, 24 from the bottom), centred in what is left
    Item { id: body; x: 8; y: col.marker ? 68 : 24; width: col.colW - 16; height: col.height - y - 24 }
}
