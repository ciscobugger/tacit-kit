// A do/don't figure's content, centred in its stage both ways: whatever the children's own x and y, their bounding box
// sits in the middle. Put the figure's pieces inside; set cw/ch when a piece reaches past its parent's box (a tooltip
// hung from a button), so the box counts it.
import QtQuick

Item {
    id: root
    property real cw: -1
    property real ch: -1
    readonly property real boxW: cw >= 0 ? cw : childrenRect.width
    readonly property real boxH: ch >= 0 ? ch : childrenRect.height
    width: boxW; height: boxH
    x: Math.round((parent.width - boxW) / 2 - (cw >= 0 ? 0 : childrenRect.x))
    y: Math.round((parent.height - boxH) / 2 - (ch >= 0 ? 0 : childrenRect.y))
}
