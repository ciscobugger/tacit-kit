// Symbols: a part of the set with names, the three sizes in place, and kinds against actions.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["set", 760, 400], ["sizes", 760, 200], ["do-kinds", 418, 220], ["dont-actions", 418, 220]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    F { n: "set"
        Grid { x: 38; y: 36; columns: 6; columnSpacing: 0; rowSpacing: 18
            Repeater {
                model: ["music_note", "movie", "image", "picture_as_pdf", "description", "folder", "deployed_code", "drive", "download", "home",
                        "search", "settings", "wifi", "bluetooth", "volume_up", "battery_full", "lock", "clock", "calendar_month", "mail",
                        "person", "star", "bookmark", "globe", "terminal", "code", "camera", "mic", "headphones", "trash"]
                Item {
                    id: s
                    required property string modelData
                    width: 118; height: 52
                    Symbol { x: 41; y: 0; text: s.modelData; size: 22; color: Kit.tokens.inkMain }
                    TacitText { y: 32; width: parent.width; horizontalAlignment: Text.AlignHCenter; text: s.modelData; size: "meta"; ink: "meta" }
                }
            }
        }
    }
    F { n: "sizes"
        Row { x: 76; y: 38; spacing: 28
            Column { spacing: 14; width: 200
                RailRow { width: 200; glyph: "download"; label: "Downloads" }
                TacitText { text: "17: the rail"; ink: "meta" }
            }
            Column { spacing: 14; width: 200
                ListRow { x: -12; width: 212; glyph: "music_note"; name: "Undertow"; facts: [] }
                TacitText { text: "20: rows and tools"; ink: "meta" }
            }
            Column { spacing: 14; width: 200
                Row { spacing: 4
                    IconButton { symbol: "arrow_back"; size: 22; label: "Back" }
                    IconButton { symbol: "arrow_forward"; size: 22; label: "Forward" }
                }
                TacitText { text: "22: back and forward"; ink: "meta" }
            }
        }
        Row { x: 76; y: 134; spacing: 32
            Repeater { model: [17, 20, 22]
                Row { id: sz; required property int modelData; spacing: 10
                    Symbol { text: "folder"; size: sz.modelData; color: Kit.tokens.inkMain }
                    Symbol { text: "folder"; size: sz.modelData; filled: true; color: Kit.tokens.inkMain }
                    TacitText { text: sz.modelData + " px"; ink: "meta"; cut: "numbers" }
                }
            }
        }
    }
    F { n: "do-kinds"
        DocCentre { cw: 370
            Column { y: 22; width: parent.width
                ListRow { width: parent.width; glyph: "music_note"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
                ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
                ListRow { width: parent.width; glyph: "folder"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
            }
        }
    }
    F { n: "dont-actions"
        DocCentre { cw: 370
            Column { y: 22; width: parent.width
                Repeater { model: [["music_note", "Name"], ["picture_as_pdf", "Name"], ["folder", "Name"]]
                    Item { id: r; required property var modelData; width: parent.width; height: 44
                        ListRow { width: parent.width; glyph: r.modelData[0]; name: r.modelData[1]; facts: []; }
                        Row { anchors.right: parent.right; anchors.rightMargin: 8; anchors.verticalCenter: parent.verticalCenter
                            Symbol { text: "edit"; anchors.verticalCenter: parent.verticalCenter }
                            Item { width: 14; height: 1 }
                            Symbol { text: "trash"; anchors.verticalCenter: parent.verticalCenter }
                            Item { width: 8; height: 1 }
                        }
                    }
                }
            }
        }
    }
}
