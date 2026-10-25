// Icon button page figures: a header's tools in a window, the pieces, the states, the measures and a guideline.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 200], ["sizes", 760, 300], ["do-known-symbols", 418, 160], ["dont-unknown-symbols", 418, 160]]
    readonly property var t: Kit.tokens
    component F: Item {
        property string n
        visible: app.fig === n
        anchors.fill: parent
        DocGlass { anchors.fill: parent }
    }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader {
            width: hw.shown; crumbs: ["Music"]; here: "Albums"; canGoForward: true
            IconButton { anchors.verticalCenter: parent.verticalCenter; symbol: "search"; label: "Search"; previewState: "hover" }
            IconButton { anchors.verticalCenter: parent.verticalCenter; symbol: "more_horiz"; label: "More" }
        }
        Column {
            x: 12; y: 84; width: hw.shown - 36
            ListRow { width: parent.width; glyph: "music_note"; name: "Undertow"; aside: "Mara Velde"; facts: ["18:02"]; factWidths: [64] }
            ListRow { width: parent.width; glyph: "music_note"; name: "Salt Road"; aside: "Mara Velde"; facts: ["4:21"]; factWidths: [64] }
            ListRow { width: parent.width; glyph: "music_note"; name: "Low tide"; aside: "Odile Fenn"; facts: ["3:48"]; factWidths: [64] }
        }
    }

    F { n: "anatomy"
        Item {
            id: hd
            readonly property real k: 1.6
            readonly property real w: 420
            x: (parent.width - w * k) / 2; y: (parent.height - 73 * k) / 2; width: w * k; height: 73 * k
            PageHeader {
                width: hd.w; crumbs: ["Music"]; here: "Albums"; canGoBack: true
                transformOrigin: Item.TopLeft; scale: hd.k
                IconButton { anchors.verticalCenter: parent.verticalCenter; symbol: "search"; label: "Search"; previewState: "hover" }
                IconButton { anchors.verticalCenter: parent.verticalCenter; symbol: "more_horiz"; label: "More" }
            }
            // the buttons' places in the header: back at 16, forward 4 after it, the tools 24 from the right edge, 24 apart
            readonly property real by: 18 * k
            readonly property real sx: (w - 120) * k
            DocCallout { n: 3; side: "top"; line: -34; rect: Qt.rect(56 * hd.k, hd.by, 36 * hd.k, 36 * hd.k) }
            DocCallout { n: 1; side: "top"; line: -34; rect: Qt.rect(hd.sx + 8 * hd.k, hd.by + 8 * hd.k, 20 * hd.k, 20 * hd.k) }
            DocCallout { n: 2; side: "bottom"; line: hd.height + 34; surface: true; inset: 4; rect: Qt.rect(hd.sx, hd.by, 36 * hd.k, 36 * hd.k) }   // the dot sits 4 px in, at the circle's rim, clear of the symbol's box
        }
    }

    F { n: "states"
        Repeater {
            model: [{ s: "", e: true }, { s: "hover", e: true }, { s: "pressed", e: true }, { s: "focus", e: true }, { s: "", e: false }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 5
                IconButton {
                    x: (parent.width - 36 * 2) / 2; y: (parent.height - 36 * 2) / 2; scale: 2; transformOrigin: Item.TopLeft
                    symbol: "more_horiz"; label: "More"; previewState: col.modelData.s; enabled: col.modelData.e
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            // two buttons at 3 times, side by side; dimension lines to the left of each (49 px) and below (39 px)
            x: (parent.width - 49 - 108 - 110 - 153) / 2 + 49; y: (parent.height - 153 - 39) / 2
            Item {
                y: (153 - 108) / 2
                IconButton { scale: 3; transformOrigin: Item.TopLeft; symbol: "more_horiz"; label: "More"; previewState: "hover" }
                DocDim { from: 0; to: 24; at: 108 + 16; n: "8" }
                DocDim { from: 24; to: 84; at: 108 + 16; n: "20" }
                DocDim { from: 84; to: 108; at: 108 + 16; n: "8" }
                DocDim { vertical: true; from: 0; to: 108; at: -24; n: "36" }
            }
            Item {
                x: 108 + 110
                IconButton { scale: 3; transformOrigin: Item.TopLeft; symbol: "play_arrow"; label: "Play"; size: 32; previewState: "hover" }
                DocDim { from: 0; to: 28.5; at: 153 + 16; n: "9.5" }
                DocDim { from: 28.5; to: 124.5; at: 153 + 16; n: "32" }
                DocDim { from: 124.5; to: 153; at: 153 + 16; n: "9.5" }
                DocDim { vertical: true; from: 0; to: 153; at: -24; n: "51" }
            }
        }
    }

    F { n: "do-known-symbols"
        DocCentre {
            DocKPanel { x: 24; y: 62; width: 370; height: 72 }
            Row { x: 24 + (370 - 5 * 40 + 4) / 2; y: 80; spacing: 4
                IconButton { symbol: "arrow_back"; label: "Back" }
                IconButton { symbol: "arrow_forward"; label: "Forward" }
                IconButton { symbol: "search"; label: "Search" }
                IconButton { symbol: "close"; label: "Close" }
                IconButton { symbol: "more_horiz"; label: "More" }
            }
        }
    }
    F { n: "dont-unknown-symbols"
        DocCentre {
            DocKPanel { x: 24; y: 62; width: 370; height: 72 }
            Row { x: 24 + (370 - 5 * 40 + 4) / 2; y: 80; spacing: 4
                IconButton { symbol: "hash"; label: "Hash" }
                IconButton { symbol: "motion_mode"; label: "Motion" }
                IconButton { symbol: "texture"; label: "Texture" }
                IconButton { symbol: "stacks"; label: "Stacks" }
                IconButton { symbol: "point_scan"; label: "Scan" }
            }
        }
    }
}
