// The calm stage for spec figures: the window's glass (the blurred wallpaper under the window's ground) with a faint dot grid.
// The wallpaper starts 580 px down and is stretched to the stage, so a stage of any height is covered.
import QtQuick
import Quickshell
import Tacit.Kit

Item {
    property bool dots: true
    readonly property string wall: Quickshell.env("MOCK_WALL") || "dusk"
    clip: true
    Image { x: -400; y: -580; width: 1600; height: Math.max(1000, parent.height + 580); source: "file://" + Quickshell.env("FIGURE_ASSETS") + "/wall-" + parent.wall + "-blur.jpg" }
    Rectangle { anchors.fill: parent; color: Kit.tokens.windowGround; opacity: 1 - Kit.tokens.windowSeeThrough }
    Grid {
        visible: parent.dots
        anchors.fill: parent; anchors.margins: 8
        columns: Math.floor(width / 16) + 1; rows: Math.floor(height / 16) + 1
        columnSpacing: 15; rowSpacing: 15
        Repeater { model: parent.columns * parent.rows
            Rectangle { width: 1; height: 1; color: Qt.alpha(Kit.tokens.inkMain, 0.10) } }
    }
}
