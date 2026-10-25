// Text: in use, the properties on one block, sizes, inks, weights and cuts, one do and one don't.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["roles", 760, 200], ["sizes", 760, 400], ["inks", 760, 300], ["weights", 760, 200], ["do-numbers", 418, 160], ["dont-proportional", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    DocWindow {
        visible: app.fig === "hero"
        anchors.fill: parent
        wx: 64; wy: 40; wallX: -400; wallY: -600
        Column {
            x: 40; y: 36; width: 600; spacing: 4
            TacitText { text: "Low Tide"; size: "headline"; cut: "display"; weight: "strong" }
            TacitText { text: "Mara Velde, 2026"; size: "body"; ink: "sec" }
            Item { width: 1; height: 12 }
            TacitText { text: "Undertow"; weight: "medium" }
            TacitText { text: "Salt and Lamp"; }
            TacitText { text: "Harbour Glass" }
            Item { width: 1; height: 8 }
            TacitText { text: "3 songs, 11 minutes"; size: "meta"; ink: "meta" }
        }
    }

    F { n: "roles"
        Column {
            x: 194; y: 31; spacing: 14
            Row { spacing: 20
                DocMarker { n: 1; anchors.verticalCenter: parent.verticalCenter }
                TacitText { text: "Undertow"; size: "section"; weight: "strong"; ink: "main" }
                TacitText { anchors.verticalCenter: parent.verticalCenter; text: "section, strong, main"; ink: "meta" }
            }
            Row { spacing: 20
                DocMarker { n: 2; anchors.verticalCenter: parent.verticalCenter }
                TacitText { text: "Mara Velde"; size: "body"; ink: "sec" }
                TacitText { anchors.verticalCenter: parent.verticalCenter; text: "body, regular, secondary"; ink: "meta" }
            }
            Row { spacing: 20
                DocMarker { n: 3; anchors.verticalCenter: parent.verticalCenter }
                TacitText { text: "18:02"; size: "row"; ink: "sec"; cut: "numbers" }
                TacitText { anchors.verticalCenter: parent.verticalCenter; text: "row, regular, secondary, numbers cut"; ink: "meta" }
            }
            Row { spacing: 20
                DocMarker { n: 4; anchors.verticalCenter: parent.verticalCenter }
                TacitText { text: "bandcamp.com"; size: "meta"; ink: "meta" }
                TacitText { anchors.verticalCenter: parent.verticalCenter; text: "meta, regular, meta"; ink: "meta" }
            }
        }
    }

    F { n: "sizes"
        Column {
            x: 128; y: 48; spacing: 4
            Repeater {
                model: [["display", 56], ["alarm", 40], ["headline", 30], ["section", 22], ["body", 17], ["row", 15], ["fileText", 14], ["meta", 13]]
                Row {
                    id: r
                    required property var modelData
                    spacing: 16
                    Item { width: 100; height: sample.height
                        TacitText { anchors.verticalCenter: parent.verticalCenter; text: r.modelData[0]; ink: "meta"; size: "meta" }
                    }
                    TacitText { id: sample; text: "Undertow"; size: r.modelData[0]; cut: r.modelData[1] >= 30 ? "display" : (r.modelData[0] === "fileText" ? "code" : "main"); width: 330 }
                    TacitText { anchors.verticalCenter: parent.verticalCenter; text: r.modelData[1] + " px"; ink: "sec"; cut: "numbers" }
                }
            }
        }
    }

    F { n: "inks"
        Grid {
            x: 40; y: 37; columns: 3; columnSpacing: 16; rowSpacing: 14
            Repeater {
                model: [["main", "Names, titles"], ["sec", "Facts"], ["meta", "Beside a name"], ["faint", "Unavailable"], ["quiet", "Lines to come"], ["past", "Lines gone by"], ["accent", "A ring, not text"], ["risk", "Move to the trash"], ["onAccent", "On an accent fill"]]
                Item {
                    id: c
                    required property var modelData
                    width: 216; height: 66
                    Rectangle { anchors.fill: parent; radius: 8; color: c.modelData[0] === "onAccent" ? Kit.tokens.accent : Qt.alpha(Kit.tokens.inkMain, 0.04) }
                    TacitText { x: 14; y: 12; text: c.modelData[1]; ink: c.modelData[0]; size: "body" }
                    TacitText { x: 14; y: 40; text: c.modelData[0]; ink: c.modelData[0] === "onAccent" ? "onAccent" : "meta"; size: "meta" }
                }
            }
        }
    }

    F { n: "weights"
        Row {
            x: 37; y: 24; spacing: 40
            Repeater {
                model: [["regular", 450], ["medium", 500], ["strong", 600]]
                Column { id: w; required property var modelData; spacing: 6; width: 200
                    TacitText { text: "Undertow"; size: "section"; weight: w.modelData[0] }
                    TacitText { text: w.modelData[0] + ", " + w.modelData[1]; ink: "meta"; cut: "numbers" }
                }
            }
        }
        Row {
            x: 37; y: 112; spacing: 40
            Repeater {
                model: [["main", "Tacit Sans", "Running text"], ["display", "Tacit Sans Display", "A page title"], ["numbers", "tabular figures", "11.6 MB  18:02"], ["code", "Tacit Code", "notes-2026.md"]]
                Column { id: cc; required property var modelData; spacing: 6; width: 150
                    TacitText { text: cc.modelData[2]; size: cc.modelData[0] === "display" ? "headline" : "row"; cut: cc.modelData[0] }
                    TacitText { text: cc.modelData[0]; ink: "meta"; size: "meta" }
                }
            }
        }
    }

    F { n: "do-numbers"
        DocCentre { cw: 80; ch: 4 * 20 + 18
            Column { x: -10; y: 2; spacing: 6; width: 80
                Repeater { model: ["11.6 MB", "111 kB", "1.1 GB", "81 kB"]
                    TacitText { required property string modelData; text: modelData; cut: "numbers"; ink: "sec"; width: 80; horizontalAlignment: Text.AlignRight } }
            }
        }
    }
    F { n: "dont-proportional"
        DocCentre { cw: 80; ch: 4 * 20 + 18
            Column { x: -13; y: 2; spacing: 6; width: 80
                Repeater { model: ["11.6 MB", "111 kB", "1.1 GB", "81 kB"]
                    TacitText { required property string modelData; text: modelData; ink: "sec"; width: 80; horizontalAlignment: Text.AlignRight } }
            }
        }
    }
}
