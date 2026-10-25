// The one dimension line of the docs' measurement figures: a hairline from `from` to `to`, a tick across each end that
// stops 4 px either side of it, and the number `gap` px clear of the line (and so clear of the ticks).
// Horizontal: the line is at y `at`, the number below it (above with `flip`). Vertical: the line is at x `at`, from
// y `from` to `to`, the number to its left (to its right with `flip`). Positions are in the parent's coordinates.
import QtQuick
import Tacit.Kit

Item {
    id: d
    property real from
    property real to
    property real at
    property string n
    property bool vertical: false
    property bool flip: false
    readonly property real gap: 7
    readonly property color c: Kit.tokens.inkFaint
    x: vertical ? at : from
    y: vertical ? from : at
    width: vertical ? 0 : to - from
    height: vertical ? to - from : 0
    Rectangle { x: d.vertical ? -0.5 : 0; y: d.vertical ? 0 : -0.5; width: d.vertical ? 1 : d.width; height: d.vertical ? d.height : 1; color: d.c }
    Rectangle { x: d.vertical ? -4 : -0.5; y: d.vertical ? -0.5 : -4; width: d.vertical ? 8 : 1; height: d.vertical ? 1 : 8; color: d.c }
    Rectangle { x: d.vertical ? -4 : d.width - 0.5; y: d.vertical ? d.height - 0.5 : -4; width: d.vertical ? 8 : 1; height: d.vertical ? 1 : 8; color: d.c }
    TacitText {
        x: d.vertical ? (d.flip ? 4 + d.gap : -4 - d.gap - width) : (d.width - width) / 2
        y: d.vertical ? (d.height - height) / 2 : (d.flip ? -4 - d.gap - height : 4 + d.gap - 2)
        text: d.n; size: "meta"; cut: "numbers"; ink: "meta"
    }
}
