// SPDX-License-Identifier: LGPL-3.0-or-later
// The owner's DockedRect (tacit shell, modules/common/widgets), moved into the kit unchanged in shape.
import QtQuick
import QtQuick.Shapes

/**
 * A panel docked into a screen edge, drawn as ONE silhouette: the body with rounded corners
 * on its free side plus concave coves that flare it into the edge on both flanks, so the
 * outline runs continuously through the coves and nothing meets the edge with a seam.
 *
 * `edge` is the docked side: "top" (the notch), "bottom" (the palette), "left" / "right"
 * (the sidebars), or a CORNER: "top-right" (notification popups), "top-left", "bottom-right",
 * "bottom-left" - two docked edges, one cove on each, one free rounded corner. `anchors.fill`
 * the BODY box; the shape extends `fillet` px past the free flanks for the coves. There is
 * never a border along a docked edge - the panel is part of it.
 *
 * The border is NOT a stroke. Two fills: the silhouette in borderColor, and the same
 * silhouette inset by borderWidth on the free sides in color on top. A stroked ShapePath on
 * the CurveRenderer rendered one wall two pixels wide and brighter at some widths.
 *
 * caelestia gets the same silhouette from its SDF blob; boring.notch from NotchShape.swift.
 */
Item {
    id: root

    property string edge: "top"
    property real cornerRadius: 17     // corners on the free side
    property real fillet: 6            // cove radius at the docked edge
    property color color: Kit.tokens.container
    property color borderColor: "transparent"
    property real borderWidth: 0
    // A rounded hole through the body, in this item's frame (the sign-in's page window shows through it, under the
    // notch: IslandContent). Zero size: none.
    property rect hole: Qt.rect(0, 0, 0, 0)
    property real holeRadius: 16
    readonly property bool holed: root.hole.width > 0 && root.hole.height > 0

    readonly property bool corner: root.edge.indexOf("-") > 0
    readonly property bool cornerTop: root.edge.startsWith("top")
    readonly property bool cornerRight: root.edge.endsWith("right")
    readonly property bool horizontal: root.edge === "top" || root.edge === "bottom"
    // Along the docked edge (u) and away from it (v), in body terms.
    readonly property real edgeLength: root.horizontal ? root.width : root.height
    readonly property real depth: root.horizontal ? root.height : root.width

    // The silhouette in (u, v): coves at v = 0, u runs from 0 to W + 2s. Mapped into the
    // Shape's local frame per edge; reflections flip the arc sweep.
    function pathFor(W, H, s, r, du) {
        const flip = root.edge === "bottom" || root.edge === "left";
        const cw = flip ? 0 : 1;
        const ccw = flip ? 1 : 0;
        const D = root.depth;
        const map = (u, v) => {
            u += du;
            switch (root.edge) {
            case "bottom":
                return `${u} ${D - v}`;
            case "left":
                return `${v} ${u}`;
            case "right":
                return `${D - v} ${u}`;
            }
            return `${u} ${v}`;
        };
        const arc = (rad, sweep, u, v) => `A ${rad} ${rad} 0 0 ${sweep} ${map(u, v)}`;
        return `M ${map(0, 0)} `
            + `${arc(s, cw, s, s)} L ${map(s, H - r)} `
            + `${arc(r, ccw, s + r, H)} L ${map(s + W - r, H)} `
            + `${arc(r, ccw, s + W, H - r)} L ${map(s + W, s)} `
            + `${arc(s, cw, 2 * s + W, 0)} Z`;
    }

    // Corner silhouette, drawn for top-right (docked top + right) and reflected for the
    // others: cove out of the top edge on the left flank, rounded free corner at the bottom
    // left, cove into the right edge under the bottom. Insets keep the docked edges flush.
    function cornerPathFor(W, H, s, r, b) {
        const flipX = !root.cornerRight;
        const flipY = !root.cornerTop;
        const flip = flipX !== flipY;
        const cw = flip ? 0 : 1;
        const ccw = flip ? 1 : 0;
        const fw = root.width, fh = root.height;
        // The Shape item sits `s` before the docked side(s) (x: -s for right corners, y: -s
        // for bottom corners), so body coordinates shift by s there after the reflection.
        const sx = root.cornerRight ? s : 0;
        const sy = root.cornerTop ? 0 : s;
        const map = (x, y) => {
            x += b;                       // free (left) side inset; right edge stays at W
            if (flipX) x = fw - x;
            if (flipY) y = fh - y;
            return `${x + sx} ${y + sy}`;
        };
        const arc = (rad, sweep, x, y) => `A ${rad} ${rad} 0 0 ${sweep} ${map(x, y)}`;
        return `M ${map(-s, 0)} ${arc(s, cw, 0, s)} L ${map(0, H - r)} ${arc(r, ccw, r, H)} `
            + `L ${map(W - s, H)} ${arc(s, cw, W, H + s)} L ${map(W, 0)} Z`;
    }

    // the hole as a second subpath, in the Shape's frame (it sits `fillet` before the body on the docked flanks)
    function holePath(ox, oy) {
        const h = root.hole, r = Math.min(root.holeRadius, h.width / 2, h.height / 2);
        const x = h.x - ox, y = h.y - oy, w = h.width, ht = h.height;
        return ` M ${x + r} ${y} L ${x + w - r} ${y} A ${r} ${r} 0 0 1 ${x + w} ${y + r} L ${x + w} ${y + ht - r}`
            + ` A ${r} ${r} 0 0 1 ${x + w - r} ${y + ht} L ${x + r} ${y + ht} A ${r} ${r} 0 0 1 ${x} ${y + ht - r}`
            + ` L ${x} ${y + r} A ${r} ${r} 0 0 1 ${x + r} ${y} Z`;
    }

    component Silhouette: Shape {
        id: shape
        property string d: ""
        property color fill: root.color
        x: root.corner ? (root.cornerRight ? -root.fillet : 0) : (root.horizontal ? -root.fillet : 0)
        y: root.corner ? (root.cornerTop ? 0 : -root.fillet) : (root.horizontal ? 0 : -root.fillet)
        width: root.corner ? root.width + root.fillet : (root.horizontal ? root.width + root.fillet * 2 : root.width)
        height: root.corner ? root.height + root.fillet : (root.horizontal ? root.height : root.height + root.fillet * 2)
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: shape.fill
            strokeWidth: -1
            fillRule: root.holed ? ShapePath.OddEvenFill : ShapePath.WindingFill
            pathHints: root.holed ? ShapePath.PathNonIntersecting : ShapePath.PathSolid | ShapePath.PathNonIntersecting
            PathSvg {
                path: shape.d + (root.holed ? root.holePath(shape.x, shape.y) : "")
            }
        }
    }

    readonly property real br: Math.min(root.cornerRadius, root.depth / 2, root.edgeLength / 2)

    // Outer: the border colour.
    Silhouette {
        fill: root.borderWidth > 0 ? root.borderColor : "transparent"
        d: root.corner
            ? root.cornerPathFor(root.width, root.height, root.fillet, root.br, 0)
            : root.pathFor(root.edgeLength, root.depth, root.fillet, root.br, 0)
    }

    // Inner: the body, inset by the border on the free sides (never a docked edge).
    Silhouette {
        readonly property real b: root.borderWidth
        fill: root.color
        d: root.corner
            ? root.cornerPathFor(root.width - b, root.height - b, root.fillet, Math.max(0, root.br - b), b)
            : root.pathFor(root.edgeLength - 2 * b, root.depth - b, root.fillet, Math.max(0, root.br - b), b)
    }
}
