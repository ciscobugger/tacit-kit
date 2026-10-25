// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A thin scroll bar for a Flickable, as the shell's StyledScrollBar draws it (4 px, a round end, the ink at half) and
// behaves: it shows while the view moves (by a finger, a wheel, Glide or code: it follows contentY, not `moving`),
// while the pointer is within 16 px of the view's right edge, and while it is dragged; 900 ms after the view stops it
// fades (the `fade` motion). It floats over the content and never takes space from it; a view whose content fits has
// none. It is not a Tab stop (the list owns the keyboard) and takes no click except on the bar itself. Put it over
// the view, same size: `ScrollBar { view: list.view; anchors.fill: list }` for a RowList, `anchors.fill: flick` beside
// a Flickable (with a Glide). `previewState`: "moving", "near", "dragging" (the catalogue).
Item {
    id: bar
    required property Flickable view
    property string previewState: ""

    readonly property real margin: Kit.tokens.space.m          // keeps the bar off the window's rounded corner
    readonly property real minY: bar.view.originY - bar.view.topMargin
    readonly property real maxY: Math.max(bar.minY, bar.view.contentHeight + bar.view.bottomMargin - bar.view.height + bar.view.originY)
    readonly property real trackTop: bar.margin
    readonly property real trackLength: Math.max(0, bar.height - 2 * bar.margin)
    readonly property real total: bar.view.contentHeight + bar.view.topMargin + bar.view.bottomMargin
    readonly property real thumbLength: bar.total > 0 ? Math.min(bar.trackLength, Math.max(Kit.tokens.space.xl, bar.trackLength * bar.view.height / bar.total)) : 0
    readonly property real progress: bar.maxY > bar.minY ? Math.max(0, Math.min(1, (bar.view.contentY - bar.minY) / (bar.maxY - bar.minY))) : 0
    readonly property bool scrollable: bar.maxY > bar.minY
    readonly property bool dragging: grab.pressed || previewState === "dragging"
    readonly property bool near: edge.hovered || previewState === "near"
    property bool recent: previewState === "moving"
    readonly property bool shown: bar.scrollable && (bar.recent || bar.near || bar.dragging || bar.view.moving)

    Accessible.role: Accessible.ScrollBar
    Accessible.name: "Scroll"
    Accessible.ignored: !bar.scrollable

    Connections {
        target: bar.view
        function onContentYChanged() { if (bar.previewState === "") { bar.recent = true; stay.restart(); } }
    }
    Timer { id: stay; interval: Kit.tokens.motion.barStays.ms; onTriggered: bar.recent = false }

    // the pointer near the edge: a hover strip that takes no click
    Item {
        id: edge
        readonly property alias hovered: edgeHover.hovered
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
        width: 16
        HoverHandler { id: edgeHover }
    }

    Rectangle {
        id: thumb
        x: bar.width - width
        y: bar.trackTop + (bar.trackLength - bar.thumbLength) * bar.progress
        width: Kit.tokens.width.scrollBar
        height: bar.thumbLength
        radius: width / 2
        color: Qt.alpha(Kit.tokens.inkMain, 0.5)
        opacity: bar.shown ? 1 : 0
        visible: opacity > 0
        Behavior on opacity {
            NumberAnimation {
                duration: Kit.tokens.motion.fade.ms
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Kit.tokens.motion.fade.curve
            }
        }
    }
    // the bar's own hit area is wider than the bar, and only where the bar is
    MouseArea {
        id: grab
        property real grabbedAt: 0
        enabled: bar.shown
        x: thumb.x - 8; y: thumb.y; width: thumb.width + 8; height: thumb.height
        hoverEnabled: true
        cursorShape: Qt.ArrowCursor
        onPressed: mouse => { grab.grabbedAt = mouse.y; }
        onPositionChanged: mouse => {
            if (!grab.pressed) return;
            const room = bar.trackLength - bar.thumbLength;
            if (room <= 0) return;
            const top = grab.mapToItem(bar, 0, mouse.y).y - grab.grabbedAt - bar.trackTop;
            bar.view.contentY = bar.minY + Math.max(0, Math.min(1, top / room)) * (bar.maxY - bar.minY);
            bar.recent = true;
            stay.restart();
        }
    }
}
