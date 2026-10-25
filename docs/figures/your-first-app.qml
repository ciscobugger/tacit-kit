// Your first app: the tutorial app (docs/examples/downloads.qml), run offscreen by lib/first-run.qml, on the wallpaper
// as the compositor would show it. The picture is the app's own pixels.
import QtQuick
import Quickshell
import Tacit.Kit

DocFigures {
    id: app
    figures: [["result", 940, 470]]
    DocWindow {
        visible: app.fig === "result"
        anchors.fill: parent
        wx: 20; wy: 28; winW: 880; winH: 480; wallX: -300; wallY: -250
        Image { width: 880; height: 480; source: "file://" + Quickshell.env("FIGURE_RAW") + "/app.png"; smooth: true }
    }
}
