// The opening and in-context figures: a crop of a window on the wallpaper. The window runs off the figure's right and
// bottom edges so only one corner shows (four round corners on the wallpaper read as a floating card). Put the window's
// content in it; `shown` is the visible width of the window, `shownHeight` its visible height.
import QtQuick
import QtQuick.Effects
import Quickshell
import Tacit.Kit

Item {
    id: root
    property real wx: 72
    property real wy: 44
    property real wallX: -400
    property real wallY: -620
    property real winW: width              // the window's own size; by default it runs off the right and bottom edges
    property real winH: height
    default property alias content: inner.data
    readonly property real shown: Math.min(width - wx, winW)
    readonly property real shownHeight: height - wy
    readonly property string wall: Quickshell.env("MOCK_WALL") || "dusk"
    clip: true
    Image { x: root.wallX; y: root.wallY; width: 1600; height: Math.max(1000, root.height - root.wallY); source: "file://" + Quickshell.env("FIGURE_ASSETS") + "/wall-" + root.wall + ".jpg" }
    Item {
        id: win
        x: root.wx; y: root.wy; width: root.winW; height: root.winH
        layer.enabled: true
        layer.effect: MultiEffect { maskEnabled: true; maskSource: winMask }
        DocGlass { anchors.fill: parent; dots: false }
        Item { id: inner; anchors.fill: parent }
    }
    Rectangle { id: winMask; visible: false; layer.enabled: true; width: win.width; height: win.height; radius: 18 }
    Rectangle { x: win.x - 1; y: win.y - 1; width: win.width + 2; height: win.height + 2; radius: 19; color: "transparent"; border.width: 1; border.color: Qt.rgba(1, 1, 1, 0.08) }
}
