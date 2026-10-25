// An anatomy callout, as Material's spec pages draw them: a numbered ring outside the part, a dotted leader to the
// piece, and a dotted box around the piece so it is plain what the number names. A surface (a wash, a container, a
// line) is named by a solid leader that ends in a small open dot on it, with no box.
// `rect` is the piece in the callout's parent's coordinates. `pad` is the room between the piece and its box (3); `inset`
// is how far inside the piece's edge a surface's dot sits (7); `open` names one side ("left", "right", "top", "bottom")
// whose edge of the box is left out, where the piece touches its neighbour. `side` is where the ring sits; `line` is the ring's
// centre on the axis away from the part (its y for top and bottom, its x for left and right), so the rings on one
// side share a line. `along` moves the ring along that line (default: the piece's centre).
import QtQuick
import QtQuick.Shapes
import Tacit.Kit

Item {
    id: c
    anchors.fill: parent
    property int n
    property rect rect
    property string side: "top"
    property real line
    readonly property bool across: side === "top" || side === "bottom"
    property real along: across ? rect.x + rect.width / 2 : rect.y + rect.height / 2
    property bool surface: false
    property real inset: 7
    property real pad: 3
    property string open: ""

    readonly property real r: 11
    readonly property color ink: Kit.tokens.inkMeta
    // the ring's centre, and the two ends of the leader
    readonly property point m: across ? Qt.point(along, line) : Qt.point(line, along)
    readonly property point from: side === "top" ? Qt.point(m.x, m.y + r) : side === "bottom" ? Qt.point(m.x, m.y - r)
                                  : side === "left" ? Qt.point(m.x + r, m.y) : Qt.point(m.x - r, m.y)
    readonly property real ex: Math.max(rect.x, Math.min(rect.x + rect.width, m.x))
    readonly property real ey: Math.max(rect.y, Math.min(rect.y + rect.height, m.y))
    readonly property real reach: surface ? inset : -pad
    readonly property point to: side === "top" ? Qt.point(ex, rect.y + reach) : side === "bottom" ? Qt.point(ex, rect.y + rect.height - reach)
                                : side === "left" ? Qt.point(rect.x + reach, ey) : Qt.point(rect.x + rect.width - reach, ey)

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            strokeColor: c.ink; strokeWidth: 1; fillColor: "transparent"
            strokeStyle: c.surface ? ShapePath.SolidLine : ShapePath.DashLine
            dashPattern: [2, 2]
            startX: c.from.x; startY: c.from.y
            PathLine { x: c.to.x; y: c.to.y }
        }
        // the box: one path per side, so one can be left out
        ShapePath {
            strokeColor: c.surface || c.open === "top" ? "transparent" : c.ink; strokeWidth: 1; fillColor: "transparent"
            strokeStyle: ShapePath.DashLine; dashPattern: [2, 2]
            startX: c.rect.x - c.pad; startY: c.rect.y - c.pad
            PathLine { x: c.rect.x + c.rect.width + c.pad; y: c.rect.y - c.pad }
        }
        ShapePath {
            strokeColor: c.surface || c.open === "right" ? "transparent" : c.ink; strokeWidth: 1; fillColor: "transparent"
            strokeStyle: ShapePath.DashLine; dashPattern: [2, 2]
            startX: c.rect.x + c.rect.width + c.pad; startY: c.rect.y - c.pad
            PathLine { x: c.rect.x + c.rect.width + c.pad; y: c.rect.y + c.rect.height + c.pad }
        }
        ShapePath {
            strokeColor: c.surface || c.open === "bottom" ? "transparent" : c.ink; strokeWidth: 1; fillColor: "transparent"
            strokeStyle: ShapePath.DashLine; dashPattern: [2, 2]
            startX: c.rect.x + c.rect.width + c.pad; startY: c.rect.y + c.rect.height + c.pad
            PathLine { x: c.rect.x - c.pad; y: c.rect.y + c.rect.height + c.pad }
        }
        ShapePath {
            strokeColor: c.surface || c.open === "left" ? "transparent" : c.ink; strokeWidth: 1; fillColor: "transparent"
            strokeStyle: ShapePath.DashLine; dashPattern: [2, 2]
            startX: c.rect.x - c.pad; startY: c.rect.y + c.rect.height + c.pad
            PathLine { x: c.rect.x - c.pad; y: c.rect.y - c.pad }
        }
    }
    // the open dot that marks a surface
    Rectangle {
        visible: c.surface
        x: c.to.x - 3.5; y: c.to.y - 3.5; width: 7; height: 7; radius: 3.5
        color: "transparent"; border.width: 1; border.color: c.ink
    }
    Rectangle {
        x: c.m.x - c.r; y: c.m.y - c.r; width: 2 * c.r; height: 2 * c.r; radius: c.r
        color: "transparent"; border.width: 1; border.color: Kit.tokens.inkSec
        // centred by the figure's ink, not its text box: the box holds room below the baseline that a figure never uses
        TacitText {
            id: num
            anchors.horizontalCenter: parent.horizontalCenter
            y: c.r + 0.354 * font.pixelSize - baselineOffset
            text: String(c.n); size: "meta"; weight: "medium"; cut: "numbers"
        }
    }
}
