// Picture grid page's figures: the grid in a window (hero), anatomy (heading, rows at their own shapes, selection ring),
// states (rest, pointer, selected), sizes (row height 200, gap 6, ring 4), two judged examples.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 400], ["states", 760, 300], ["sizes", 760, 300], ["do-edge", 418, 220], ["dont-alone", 418, 220]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens
    function pic(p, r, g) { return { source: app.pics + p + ".jpg", ratio: r, group: g, name: p + ".jpg" }; }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PictureGrid {
            x: 24; y: 4; width: hw.shown - 48; height: parent.height - 8
            rowHeight: 110
            previewHover: 2
            pictures: [app.pic("p4", 1.778, "Today"), app.pic("p1", 0.75, "Today"), app.pic("p2", 1.333, "Today"), app.pic("p5", 1, "Today"),
                       app.pic("p7", 1.333, "Tuesday"), app.pic("p3", 0.75, "Tuesday"), app.pic("p8", 1.778, "Tuesday"), app.pic("p6", 0.75, "Tuesday")]
            Component.onCompleted: setSelection([1])
        }
    }

    F { n: "anatomy"
        // the heading's words, measured as the heading sets them
        TacitText { id: mHead; visible: false; text: "Heading"; size: "body"; weight: "strong" }
        Item {
            id: anat
            // the layout the grid made: row r starts at y = 50 + the rows above, each as high as its pictures plus the gap
            readonly property var rows: ag.layout.rows
            readonly property real y1: 50 + rows[1].h + ag.gap
            readonly property var r1: rows[1].cells
            readonly property var sel: r1[r1.length - 1]
            x: (parent.width - ag.width) / 2; y: parent.height / 2 - (height - 45) / 2
            width: ag.width; height: y1 + rows[2].h
            PictureGrid {
                id: ag
                width: 500; height: 300
                rowHeight: 100
                pictures: [app.pic("p4", 1.778, "Heading"), app.pic("p1", 0.75, "Heading"), app.pic("p2", 1.333, "Heading"),
                           app.pic("p5", 1, "Heading"), app.pic("p7", 1.333, "Heading"), app.pic("p3", 0.75, "Heading"),
                           app.pic("p6", 0.75, "Heading"), app.pic("p8", 1.778, "Heading")]
                Component.onCompleted: setSelection([anat.r1[anat.r1.length - 1].i])
            }
            readonly property real ringTop: -34
            DocCallout { n: 1; side: "left"; line: -44; rect: Qt.rect(0, 38 - mHead.implicitHeight, mHead.implicitWidth, mHead.implicitHeight) }
            DocCallout { n: 2; side: "top"; line: anat.ringTop; rect: Qt.rect(anat.r1[0].x, 50, anat.r1[0].w, anat.rows[1].h) }
            DocCallout { n: 3; side: "right"; line: anat.width + 44; surface: true
                         rect: Qt.rect(anat.sel.x - 4, 50 - 4, anat.sel.w + 8, anat.rows[1].h + 8) }
            DocCallout { n: 4; side: "top"; line: anat.ringTop; surface: true
                         rect: Qt.rect(anat.r1[0].w, 50, ag.gap, anat.rows[1].h) }
        }
    }

    // one picture in three states
    F { n: "states"
        Item {
            anchors.fill: parent
            Repeater {
                model: [{ s: [] }, { s: [], h: 1 }, { s: [1] }, { s: [1], h: 1 }]
                DocCol {
                    id: col
                    required property var modelData
                    required property int index
                    slot: index; count: 4
                    PictureGrid {
                        anchors.centerIn: parent; width: parent.width; height: 150
                        rowHeight: 80; gap: 6
                        previewHover: col.modelData.h ?? -1
                        pictures: [app.pic("p4", 1.778, ""), app.pic("p1", 0.75, ""), app.pic("p2", 1.333, ""), app.pic("p5", 1, "")]
                        Component.onCompleted: setSelection(col.modelData.s)
                    }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            id: m
            // 57 px of dimension line to the left of the row, 39 below it
            x: (parent.width - 603 - 57) / 2 + 57; y: (parent.height - 156 - 39) / 2 - 6
            PictureGrid { x: 0; y: 0; width: 603; height: 160; rowHeight: 150; gap: 6
                pictures: [app.pic("p4", 1.778, ""), app.pic("p1", 0.75, ""), app.pic("p2", 1.333, "")]
                Component.onCompleted: setSelection([1]) }
            DocDim { vertical: true; from: 6; to: 156; at: -24; n: "150" }
            DocDim { from: 272.7; to: 278.7; at: 156 + 16; n: "6" }
        }
    }

    F { n: "do-edge"
        DocCentre {
            PictureGrid { width: 370; height: 166; rowHeight: 80
                pictures: [app.pic("p4", 1.778, ""), app.pic("p1", 0.75, ""), app.pic("p2", 1.333, ""),
                           app.pic("p5", 1, ""), app.pic("p7", 1.333, ""), app.pic("p3", 0.75, ""),
                           app.pic("p6", 0.75, ""), app.pic("p8", 1.778, "")] }
        }
    }
    // a picture alone on its row, drawn by hand (the grid never does this)
    F { n: "dont-alone"
        DocCentre {
            Column { spacing: 6
                Row { spacing: 6
                    Repeater { model: [["p4", 142], ["p1", 60], ["p2", 107]]
                        Image { required property var modelData; width: modelData[1]; height: 80; fillMode: Image.PreserveAspectCrop; source: app.pics + modelData[0] + ".jpg" } }
                }
                Image { width: 107; height: 80; fillMode: Image.PreserveAspectCrop; source: app.pics + "p5.jpg" }
            }
        }
    }
}
