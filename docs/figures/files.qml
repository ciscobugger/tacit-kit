// Files: the real render of Files on Tacit.Kit (tools/files-run.sh at SCALE=2, W=1000 H=640, laid on the blurred wallpaper
// 40 px in; files-src/parts-<palette>.png) with a callout on each kit part it is made of. The other figures on the page are
// renders converted as they are.
import QtQuick
import Quickshell
import Tacit.Kit

DocFigures {
    id: app
    figures: [["parts", 1080, 720]]
    Image {
        anchors.fill: parent
        source: "file://" + Quickshell.env("FIGURE_SRC") + "/files-src/parts-" + (app.wall === "dusk" ? "dusk" : "moss") + ".png"
        smooth: true
    }
    // rings in the wallpaper's margin round the window: the rail's on the left, the header's above, the page's on the right
    DocCallout { n: 1; side: "left"; line: 20; along: 120; rect: Qt.rect(46, 50, 288, 614) }
    DocCallout { n: 2; side: "top"; line: 20; rect: Qt.rect(364, 70, 319, 34) }
    DocCallout { n: 3; side: "top"; line: 20; rect: Qt.rect(840, 74, 164, 26) }
    DocCallout { n: 4; side: "right"; line: 1060; rect: Qt.rect(366, 134, 636, 28) }
    DocCallout { n: 5; side: "right"; line: 1060; rect: Qt.rect(360, 178, 662, 32) }
    DocCallout { n: 6; side: "left"; line: 20; rect: Qt.rect(50, 190, 280, 30) }
}
