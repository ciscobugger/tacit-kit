// Type: the scale on the calm stage, then inks against opacity.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["scale", 760, 400], ["do-inks", 418, 160], ["dont-opacity", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    F { n: "scale"
        Column { x: 28; y: 22; width: parent.width - 56; spacing: 0
            Repeater {
                model: [["display", "56", "Display, strong", "Undertow", "display", "strong", "main", 70],
                        ["alarm", "40", "main, strong", "A line of the song", "main", "strong", "main", 54],
                        ["headline", "30", "Display, strong", "Files › Downloads", "display", "strong", "main", 46],
                        ["section", "22", "main, regular", "Low Tide, 2024", "main", "regular", "sec", 38],
                        ["body", "17", "main, strong", "Today", "main", "strong", "main", 34],
                        ["row", "15", "main, regular", "Lease agreement.pdf", "main", "regular", "main", 34],
                        ["fileText", "14", "code, regular", "tacit-kit --version", "code", "regular", "main", 34],
                        ["meta", "13", "main, regular", "12 files", "main", "regular", "meta", 30]]
                Item {
                    id: line
                    required property var modelData
                    width: parent.width; height: modelData[7]
                    TacitText { y: parent.height - implicitHeight - 4; text: line.modelData[0] + " " + line.modelData[1]; ink: "meta"; size: "meta"; cut: "numbers" }
                    TacitText { x: 150; anchors.baseline: parent.bottom; anchors.baselineOffset: -8; text: line.modelData[3]; size: line.modelData[0]; cut: line.modelData[4]; weight: line.modelData[5]; ink: line.modelData[6] }
                    TacitText { anchors.right: parent.right; y: parent.height - implicitHeight - 4; text: line.modelData[2]; ink: "meta"; size: "meta" }
                }
            }
        }
    }
    F { n: "do-inks"
        DocCentre {
            Column { x: 24; y: 38
                TacitText { text: "Lease agreement.pdf"; size: "body"; weight: "medium" }
                Item { width: 1; height: 8 }
                TacitText { text: "2.2 MB, 14:40"; ink: "sec" }
                Item { width: 1; height: 8 }
                TacitText { text: "From docs.google.com"; ink: "meta" }
            }
        }
    }
    F { n: "dont-opacity"
        DocCentre {
            Column { x: 24; y: 38
                TacitText { text: "Lease agreement.pdf"; size: "body"; weight: "medium" }
                Item { width: 1; height: 8 }
                TacitText { text: "2.2 MB, 14:40"; opacity: 0.7 }
                Item { width: 1; height: 8 }
                TacitText { text: "From docs.google.com"; opacity: 0.5 }
            }
        }
    }
}
