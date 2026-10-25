// Symbol: in use, anatomy, style and ink, sizes, one do and one don't.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["styles", 760, 200], ["sizes", 760, 200], ["do-token-size", 418, 160], ["dont-accent", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    DocWindow {
        visible: app.fig === "hero"
        anchors.fill: parent
        wx: 56; wy: 40; wallX: -400; wallY: -600
        Column { x: 0; y: 12; width: 190
            RailRow { width: 190; glyph: "home"; label: "Home" }
            RailRow { width: 190; glyph: "download"; label: "Downloads"; current: true }
            RailRow { width: 190; glyph: "image"; label: "Pictures" }
            RailRow { width: 190; glyph: "drive"; label: "Backup drive" }
        }
        Column { x: 200; y: 6; width: 460
            ListRow { width: parent.width; glyph: "music_note"; name: "Undertow - Mara Velde.mp3"; facts: ["11.6 MB"]; factWidths: [80]; selected: true }
            ListRow { width: parent.width; glyph: "deployed_code"; name: "tacit-1.1.7-x86_64.iso"; facts: ["2.9 GB"]; factWidths: [80] }
            ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; facts: ["2.2 MB"]; factWidths: [80] }
            ListRow { width: parent.width; glyph: "folder"; name: "Taxes 2026"; facts: ["12 items"]; factWidths: [80] }
        }
    }

    F { n: "anatomy"
        // the symbol at 140, which is a row's 20 at seven times: the 16 px of room on each side becomes 112
        Item {
            x: 310; y: 80; width: 140; height: 140
            Rectangle { width: 140; height: 140; color: "transparent"; border.width: 1; border.color: Kit.tokens.inkFaint }
            Symbol { text: "folder"; size: 140 }
            // the folder's ink inside its square, measured from a render at 140: x 11.5 to 128.5, y 22.5 to 121
            DocCallout { n: 1; side: "top"; line: -30; rect: Qt.rect(11.5, 22.5, 117, 98.5) }
            DocCallout { n: 2; side: "bottom"; line: 170; surface: true; inset: 0.5; rect: Qt.rect(0, 0, 140, 140) }
            // the room, boxed edge to edge
            DocCallout { n: 3; side: "left"; line: -150; pad: 0; rect: Qt.rect(-112, 0, 112, 140) }
            DocCallout { n: 3; side: "right"; line: 290; pad: 0; rect: Qt.rect(140, 0, 112, 140) }
        }
    }

    F { n: "styles"
        Row {
            x: 41; y: 0
            Repeater {
                model: [["Line, secondary ink", false, "inkSec"], ["Filled, secondary ink", true, "inkSec"], ["Line, main ink", false, "inkMain"], ["Filled, main ink", true, "inkMain"]]
                Item {
                    id: col
                    required property var modelData
                    required property int index
                    width: 178; height: 200
                    DocMarker { n: col.index + 1; anchors.horizontalCenter: parent.horizontalCenter; y: 33 }
                    Symbol { anchors.horizontalCenter: parent.horizontalCenter; y: 79; text: "folder"; size: 56; width: 56; filled: col.modelData[1]; color: Kit.tokens[col.modelData[2]] }
                    TacitText { x: 0; width: parent.width - 20; y: 151; horizontalAlignment: Text.AlignHCenter; text: col.modelData[0]; ink: "sec"; size: "meta" }
                }
            }
        }
    }

    F { n: "sizes"
        Row {
            anchors.centerIn: parent; anchors.verticalCenterOffset: -4; spacing: 80
            Repeater {
                model: [["rail", 17], ["row", 20], ["nav", 22]]
                Item {
                    id: s
                    required property var modelData
                    width: s.modelData[1] * 3; height: s.modelData[1] * 3 + 16 + 4 + 7 + 14 + 12 + 14
                    Rectangle { x: 0; y: 0; width: s.modelData[1] * 3; height: s.modelData[1] * 3; color: Qt.alpha(Kit.tokens.inkMain, 0.06) }
                    Symbol { text: "folder"; size: s.modelData[1] * 3; width: size; height: size; color: Kit.tokens.inkMain }
                    DocDim { from: 0; to: s.modelData[1] * 3; at: s.modelData[1] * 3 + 16; n: String(s.modelData[1]) }
                    TacitText { x: (s.width - width) / 2; y: s.modelData[1] * 3 + 16 + 4 + 7 + 14 + 12; text: "icon." + s.modelData[0]; ink: "meta" }
                }
            }
        }
    }

    F { n: "do-token-size"
        DocCentre { cw: 370
            Column { y: 40; width: parent.width
                ListRow { width: parent.width; glyph: "music_note"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
                ListRow { width: parent.width; glyph: "folder"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
            }
        }
    }
    F { n: "dont-accent"
        DocCentre { cw: 370
            Column { y: 40; width: parent.width
                Repeater { model: ["music_note", "folder"]
                    Item { id: ar; required property string modelData; width: parent.width; height: 44
                        Symbol { x: 16; anchors.verticalCenter: parent.verticalCenter; text: ar.modelData; color: Kit.tokens.accent }
                        TacitText { x: 52; anchors.verticalCenter: parent.verticalCenter; text: "Name" }
                        TacitText { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; width: 64; horizontalAlignment: Text.AlignRight; text: "Fact"; ink: "sec" } } }
            }
        }
    }
}
