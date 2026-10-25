// Colour: the opening (a window on the wallpaper), the roles as swatches with their values on this palette, the five
// inks with their APCA Lc, and where the accent and the risk ink appear.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["roles", 760, 400], ["inks", 760, 300], ["accent-risk", 760, 300]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent }
    readonly property var t: Kit.tokens

    F { n: "hero"
        DocWindow {
            anchors.fill: parent
            wx: 40; wy: 32; winW: 680; winH: 420; wallX: -400; wallY: -560
            Column { x: 0; y: 12; width: 220
                RailRow { width: 220; glyph: "download"; label: "Downloads"; current: true }
                RailRow { width: 220; glyph: "home"; label: "Home" }
                RailRow { width: 220; glyph: "image"; label: "Pictures" }
                RailRow { width: 220; glyph: "drive"; label: "Backup drive" }
            }
            Rectangle { x: 220; y: 0; width: 1; height: 420; color: app.t.hairline }
            Column { x: 232; y: 14; width: 436
                ListRow { width: parent.width; glyph: "music_note"; name: "Undertow.mp3"; aside: "bandcamp.com"; facts: ["11.6 MB"]; factWidths: [80]; selected: true }
                ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease.pdf"; aside: "docs.google.com"; facts: ["2.2 MB"]; factWidths: [80] }
                ListRow { width: parent.width; glyph: "description"; name: "Budget.xlsx"; facts: ["84 kB"]; factWidths: [80] }
                Item { width: 1; height: 28 }
                Row { x: 16; spacing: 20
                    Slab { text: "Open"; tone: "default" }
                    Slab { text: "Move to the trash"; tone: "risk" }
                }
            }
        }
    }

    // the roles, each a swatch with its name and its value on this palette
    F { n: "roles"
        DocGlass { anchors.fill: parent }
        DocCentre { cw: 700; ch: 283
        Grid {
            columns: 4; columnSpacing: 12; rowSpacing: 18
            Repeater {
                model: [["inkMain", "Main ink"], ["inkSec", "Secondary ink"], ["inkMeta", "Meta ink"], ["inkFaint", "Faint ink"],
                        ["accent", "Accent"], ["inkOnAccent", "Ink on accent"], ["risk", "Risk"], ["hairline", "Hairline"],
                        ["windowGround", "Window ground"], ["container", "Container"], ["overlay", "Overlay"], ["quiet", "Quiet"]]
                Item {
                    id: chip
                    required property var modelData
                    width: 166; height: 84
                    Rectangle { width: parent.width; height: 40; radius: 8; color: app.t[chip.modelData[0]]
                        border.width: 1; border.color: app.t.hairline }
                    TacitText { y: 46; text: chip.modelData[1]; weight: "medium" }
                    TacitText { y: 65; text: String(app.t[chip.modelData[0]]).toLowerCase(); ink: "meta"; size: "meta"; cut: "numbers" }
                }
            }
        }
        }
    }

    F { n: "inks"
        DocGlass { anchors.fill: parent }
        DocCentre { cw: 696; ch: 250
        Column { width: 696; spacing: 0
            Repeater {
                model: [["main", "Names, titles, the line in focus", "92", "Main"], ["sec", "Facts: size, time, length", "85", "Secondary"],
                        ["meta", "A name beside a name, counts", "75", "Meta"], ["faint", "Unavailable: a letter with nothing behind it", "60", "Faint"]]
                Item {
                    id: ink
                    required property var modelData
                    width: parent.width; height: 50
                    TacitText { x: 0; anchors.verticalCenter: parent.verticalCenter; text: ink.modelData[3]; ink: "meta"; size: "meta" }
                    TacitText { x: 110; anchors.verticalCenter: parent.verticalCenter; text: ink.modelData[1]; ink: ink.modelData[0]; size: "body" }
                    TacitText { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: "Lc " + ink.modelData[2]; cut: "numbers"; size: "body"; weight: "medium" }
                    Rectangle { y: parent.height - 1; width: parent.width; height: 1; color: Qt.alpha(app.t.inkMain, 0.08) }
                }
            }
            Item {
                width: parent.width; height: 50
                TacitText { anchors.verticalCenter: parent.verticalCenter; text: "Hairline"; ink: "meta"; size: "meta" }
                Rectangle { x: 110; anchors.verticalCenter: parent.verticalCenter; width: parent.width - 240; height: 1; color: app.t.hairline }
                TacitText { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: "Lc 16"; cut: "numbers"; size: "body"; weight: "medium" }
            }
        }
        }
    }

    F { n: "accent-risk"
        DocGlass { anchors.fill: parent }
        component Cell: Item {
            property string caption
            default property alias demo: slot.data
            width: 220; height: 96
            Item { id: slot; width: parent.width; height: 52 }
            TacitText { y: 62; text: parent.caption; ink: "meta" }
        }
        DocCentre { cw: 712; ch: 188
        Cell { x: 0; y: 0; caption: "The current place"
            RailRow { y: 10; width: 210; glyph: "download"; label: "Downloads"; current: true } }
        Cell { x: 246; y: 0; caption: "The way forward"
            Slab { y: 6; text: "Open"; tone: "default" } }
        Cell { x: 492; y: 0; caption: "Where the keyboard is"
            ListRow { x: 0; y: 4; width: 210; glyph: "music_note"; name: "Undertow"; facts: []; selected: true; previewState: "focus" } }
        Cell { x: 0; y: 110; caption: "A destructive action"
            WordAction { y: 6; text: "Move to the trash"; risk: true; width: 210 } }
        Cell { x: 246; y: 110; caption: "Its ring, quiet"
            Slab { y: 6; text: "Delete"; tone: "risk" } }
        }
    }
}
