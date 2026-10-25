// The frame every docs page's figures share (the pattern of figures/list-row.qml): a window that shows one figure at a
// time on `stage`, saves it to FIGURE_OUT/<name>.png and moves to the next. A page lists its figures as
// [name, width, height] and puts one item per figure into the stage, visible while `fig` is its name.
import QtQuick
import QtQuick.Controls
import Quickshell
import Tacit.Kit

ApplicationWindow {
    id: app
    visible: true; width: 1000; height: 700; color: "black"
    property var figures: []
    default property alias content: stage.data
    property int i: 0
    readonly property string fig: figures.length ? figures[Math.min(i, figures.length - 1)][0] : ""
    readonly property string out: Quickshell.env("FIGURE_OUT") || "/tmp/fig"
    readonly property string wall: Quickshell.env("MOCK_WALL") || "dusk"
    readonly property string mus: "file://" + Quickshell.env("FIGURE_ASSETS") + "/"
    readonly property string pics: "file://" + Quickshell.env("FIGURE_ASSETS") + "/"
    property int settle: 900

    Item {
        id: stage
        width: app.figures.length ? app.figures[app.i][1] : 10
        height: app.figures.length ? app.figures[app.i][2] : 10
    }
    Timer {
        id: go; interval: app.settle; running: true
        onTriggered: stage.grabToImage(g => {
            g.saveToFile(app.out + "/" + app.fig + ".png");
            if (app.i + 1 >= app.figures.length) Qt.quit(); else { app.i++; go.restart(); }
        })
    }
}
