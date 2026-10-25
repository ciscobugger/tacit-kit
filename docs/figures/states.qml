// States: four parts across their states, a run of selected rows against separate ones, and the empty and failed pages.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["strip", 760, 300], ["do-run", 418, 300], ["dont-pills", 418, 300], ["pages", 760, 300]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    F { n: "strip"
        // columns: rest, hover, pressed, focus; rows: list row, rail row, icon button, word action
        Repeater { model: ["Rest", "Pointer over it", "Pressed", "Keyboard focus"]
            TacitText { required property string modelData; required property int index
                x: 137 + index * 150; y: 26; text: modelData; ink: "meta"; size: "meta" } }
        Repeater { model: ["List row", "Rail row", "Icon button", "Action"]
            TacitText { required property string modelData; required property int index
                x: 31; y: [78, 128, 179, 238][index]; text: modelData; ink: "meta" } }
        Repeater { model: ["", "hover", "pressed", "focus"]
            Item { id: col; required property string modelData; required property int index
                x: 131 + index * 150; y: 60; width: 140
                ListRow { y: 6; x: 0; width: 138; glyph: "description"; name: "Name"; facts: []; previewState: col.modelData }
                RailRow { y: 62; x: 0; width: 138; glyph: "download"; label: "Name"; previewState: col.modelData }
                IconButton { y: 112; x: 50; symbol: "star"; label: "Star"; previewState: col.modelData }
                WordAction { y: 168; x: 12; width: 120; text: "Name"; previewState: col.modelData }
            } }
    }
    F { n: "do-run"
        DocCentre { cw: 370
            Column { y: 16; width: parent.width
                ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64]; selected: true; joinBelow: true }
                ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64]; selected: true; joinAbove: true; joinBelow: true }
                ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64]; selected: true; joinAbove: true }
                ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
            }
        }
    }
    F { n: "dont-pills"
        DocCentre { cw: 370
            Column { y: 16; width: parent.width
                ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64]; selected: true }
                ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64]; selected: true }
                ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64]; selected: true }
                ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
            }
        }
    }
    F { n: "pages"
        PageState { x: 91; y: 57; text: "Nothing here yet. Files you download land in this folder." }
        PageState { x: 91; y: 141; failure: true; text: "The drive was pulled out while it was being read. Plug it in and open it again."; action: "Try again" }
    }
}
