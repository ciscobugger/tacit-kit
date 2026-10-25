// Shape: the five corners at three times their size with where each is used, and a docked panel's coves.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["corners", 760, 300], ["coves", 760, 300]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens

    F { n: "corners"
        Row { x: 32; y: 40; spacing: 4
            Repeater {
                model: [["art", 6, "Small art up to 32, key caps"], ["row", 8, "Rows, washes, art up to 72"], ["slab", 12, "Slab, fields, large art"],
                        ["panel", 14, "Docked panels, groups"], ["window", 18, "The window"]]
                Item {
                    id: c
                    required property var modelData
                    width: 138; height: 226
                    // the corner at three times: an outline of a shape whose top-left corner is this one
                    Item { x: 8; y: 0; width: 120; height: 110; clip: true
                        Rectangle { x: 0; y: 0; width: 240; height: 240; radius: c.modelData[1] * 3
                            color: Qt.alpha(app.t.inkMain, 0.07); border.width: 1; border.color: Qt.alpha(app.t.inkMain, 0.45) }
                    }
                    TacitText { y: 124; text: String(c.modelData[1]); size: "headline"; weight: "strong"; cut: "numbers" }
                    TacitText { y: 164; text: c.modelData[0]; weight: "medium" }
                    TacitText { y: 186; width: 132; text: c.modelData[2]; ink: "meta"; size: "meta"; wrapMode: Text.WordWrap }
                }
            }
        }
    }
    F { n: "coves"
        Item {
            x: 0; y: 0; width: 760 / 1.5; height: 300 / 1.5; scale: 1.5; transformOrigin: Item.TopLeft
            PageHeader { width: parent.width; canGoBack: true; crumbs: ["Files"]; here: "Downloads" }
            DockedPanel { x: parent.width - 260; y: 72; height: 128; open: true; openWidth: 260
                Column { x: 20; y: 20; width: 220
                    TacitText { text: "Undertow.mp3"; size: "body"; weight: "medium" }
                    WordAction { y: 8; text: "Open with…"; width: 220 }
                }
            }
        }
        DocMarker { n: 1; x: 760 - 260 * 1.5 - 30; y: 72 * 1.5 + 6 }
        DocMarker { n: 2; x: 760 - 260 * 1.5 + 10; y: 200 * 1.5 - 70 }
    }
}
