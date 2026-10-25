// Materials: the layers in a window, the ground made from the wallpaper step by step, and the grey slab to avoid.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["layers", 760, 400], ["ground", 760, 300], ["do-lift", 418, 220], ["dont-grey", 418, 220]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent }
    readonly property var t: Kit.tokens

    F { n: "layers"
        DocWindow {
            id: lw
            anchors.fill: parent
            wx: 56; wy: 28; winW: 680; winH: 440; wallX: -500; wallY: -580
            PageHeader { width: 680; canGoBack: false; crumbs: ["Files"]; here: "Downloads" }
            Column { x: 12; y: 86; width: 280
                ListRow { width: parent.width; glyph: "music_note"; name: "Undertow.mp3"; facts: ["11.6 MB"]; factWidths: [80]; selected: true }
                ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease.pdf"; facts: ["2.2 MB"]; factWidths: [80] }
                ListRow { width: parent.width; glyph: "description"; name: "Budget.xlsx"; facts: ["84 kB"]; factWidths: [80] }
            }
            DockedPanel {
                x: 680 - 400; y: 72; height: 300; open: true
                Column { x: 24; y: 24; width: 352
                    TacitText { text: "Undertow.mp3"; size: "body"; weight: "medium" }
                    Item { width: 1; height: 18 }
                    Slab { text: "Open"; tone: "default" }
                    Item { width: 1; height: 14 }
                    WordAction { text: "Open with…" }
                }
            }
            MenuSurface {
                id: mn
                x: 40; y: 196; items: [{ label: "Open" }, { label: "Open with…" }, { rule: true }, { label: "Move to the trash", risk: true }]
            }
        }
        // the ground (the empty glass at the window's left), the lifted panel and the menu over the list; stage coordinates
        DocCallout { n: 1; side: "left"; line: 28; surface: true; along: 28 + 340; rect: Qt.rect(56, 28, 10, 440) }
        DocCallout { n: 2; side: "top"; line: 58; surface: true; along: 56 + 480; rect: Qt.rect(56 + 280, 28 + 72, 400, 300) }
        DocCallout { n: 3; side: "left"; line: 28; surface: true; along: 28 + mn.y + mn.height / 2; rect: Qt.rect(56 + mn.x, 28 + mn.y, mn.width, mn.height) }
    }

    // the window's ground, step by step: the wallpaper, the ground over it, a row on it
    F { n: "ground"
        DocGlass { anchors.fill: parent }
        DocCentre { cw: 676; ch: 160
        Row {
            spacing: 20
            Repeater {
                model: [["The wallpaper", false, false], ["The ground over it, at 85 %", true, false], ["The window with a row on it", true, true]]
                Item {
                    id: tile
                    required property var modelData
                    width: 212; height: 190
                    Item {
                        width: parent.width; height: 130; clip: true
                        Image { x: -230; y: -470; width: 1600; height: 1000
                            source: app.mus + "wall-" + app.wall + (tile.modelData[1] ? "-blur" : "") + ".jpg" }
                        Rectangle { anchors.fill: parent; visible: tile.modelData[1]; color: app.t.windowGround; opacity: 1 - app.t.windowSeeThrough }
                        ListRow { visible: tile.modelData[2]; x: 8; y: 43; width: 196; glyph: "music_note"; name: "Name"; facts: []; selected: true }
                        Rectangle { anchors.fill: parent; radius: 14; color: "transparent"; border.width: 1; border.color: Qt.alpha(app.t.inkMain, 0.15) }
                    }
                    TacitText { y: 142; width: parent.width; text: tile.modelData[0]; weight: "medium"; wrapMode: Text.WordWrap }
                }
            }
        }
        }
    }

    F { n: "do-lift"
        DocGlass { anchors.fill: parent }
        Rectangle { x: 0; y: 19; width: 418; height: 1; color: app.t.hairline }
        Column { x: 12; y: 36; width: 210
            ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: []; selected: true }
            ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: [] }
            ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: [] }
        }
        DockedPanel { x: 418 - 190; y: 20; height: 176; open: true; openWidth: 190
            Column { x: 20; y: 18; width: 150
                TacitText { text: "Name"; size: "body"; weight: "medium" }
                Item { width: 1; height: 12 }
                WordAction { text: "Action"; width: 150 }
                WordAction { text: "Action"; width: 150 }
            }
        }
    
    }
    F { n: "dont-grey"
        DocGlass { anchors.fill: parent }
        Rectangle { x: 0; y: 19; width: 418; height: 1; color: app.t.hairline }
        Column { x: 12; y: 36; width: 210
            ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: []; selected: true }
            ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: [] }
            ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: [] }
        }
        Rectangle { x: 418 - 190; y: 20; width: 190; height: 176; radius: 14; color: app.t.container
            Column { x: 20; y: 18; width: 150
                TacitText { text: "Name"; size: "body"; weight: "medium" }
                Item { width: 1; height: 12 }
                WordAction { text: "Action"; width: 150 }
                WordAction { text: "Action"; width: 150 }
            }
        }
    
    }
}
