// Scroll bar page's figures: a long list in a window (hero), the pieces, the four states, the measures and one guideline.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 400], ["states", 760, 300], ["sizes", 760, 400], ["do-float", 418, 220], ["dont-gutter", 418, 220]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var names: ["Undertow - Mara Velde.mp3", "tacit-1.1.7-x86_64.iso", "Lease agreement.pdf", "Budget 2027.xlsx", "photos-october.zip",
                                  "notes-2026.md", "ov02c10-capture.png", "Receipts 2026.pdf", "Invoice 0412.pdf", "dune-light.jpg", "orbit-red.jpg", "Garden plan.odt"]

    readonly property var sizes: ["84 kB", "420 MB", "6 kB", "640 kB", "1.1 MB", "212 kB", "3.4 MB", "2.9 MB", "41 kB", "2.2 MB"]
    function kindOf(n) { return /\.(jpg|png)$/.test(n) ? "image" : /\.mp3$/.test(n) ? "music_note" : /\.zip$/.test(n) ? "archive" : "description"; }

    // a list of rows with the bar over it, as an app writes it; `at` scrolls it, `bar` is the bar's previewState
    component Long: Item {
        id: lg
        property var rows: app.names
        property bool neutral: false
        property real at: 0
        property string bar: ""
        property alias list: list
        property real rowW: width
        RowList {
            id: list
            width: lg.rowW; height: parent.height
            model: lg.rows
            delegate: ListRow {
                required property var modelData
                required property int index
                width: list.rowWidth; focusable: false
                glyph: lg.neutral ? "description" : app.kindOf(modelData); name: lg.neutral ? "Name" : modelData
                facts: lg.width > 200 ? [lg.neutral ? "Fact" : app.sizes[index % app.sizes.length]] : []; factWidths: [64]
            }
            Component.onCompleted: view.contentY = lg.at
        }
        ScrollBar { view: list.view; anchors.fill: list; previewState: lg.bar }
    }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Home"]; here: "Downloads" }
        Long {
            x: 12; y: 78; width: hw.shown - 24; height: 4 * 44 + 22
            at: 150; bar: "moving"
            rows: [].concat(app.names).map(n => n)
        }
    }

    F { n: "anatomy"
        // a list at 1.6 times: 360 by 150, thumb at the top right; rings on the right and one below
        Item {
            id: an
            readonly property real k: 1.6
            x: 64; y: 57; width: 360 * k; height: 150 * k
            Item { width: 360; height: 150; scale: an.k; transformOrigin: Item.TopLeft
                Long { anchors.fill: parent; neutral: true; at: 0; bar: "moving" } }
            // the bar sits at the view's right edge: 4 wide, 12 from the top; its length is the track times view over content
            readonly property real thumbLen: (150 - 24) * 150 / (12 * 44)
            DocCallout { n: 1; side: "right"; line: 360 * an.k + 40; rect: Qt.rect(356 * an.k, 12 * an.k, 4 * an.k, an.thumbLen * an.k) }
            DocCallout { n: 2; side: "right"; line: 360 * an.k + 40; along: 6 * an.k; open: "bottom"
                         rect: Qt.rect(356 * an.k, 0, 4 * an.k, 12 * an.k) }
            DocCallout { n: 3; side: "bottom"; line: 150 * an.k + 30; surface: true; along: (360 - 8) * an.k
                         rect: Qt.rect(344 * an.k, 0, 16 * an.k, 150 * an.k) }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ s: "" }, { s: "moving" }, { s: "near" }, { s: "dragging" }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 4
                Long { x: 0; y: 0; width: parent.width; height: 196; neutral: true; at: 70; bar: col.modelData.s }
            }
        }
    }

    F { n: "sizes"
        // the top right of a view at 4 times: the bar 4 wide, 12 from the top, the strip that wakes it 16 wide
        Item {
            id: sz
            readonly property real k: 4
            x: 220; y: 96; width: 60 * k; height: 52 * k
            Rectangle { width: 60 * sz.k; height: 52 * sz.k; color: Qt.alpha(Kit.tokens.inkMain, Kit.tokens.wash.hover); radius: 4 }
            Rectangle { x: 44 * sz.k; width: 16 * sz.k; height: 52 * sz.k; color: Qt.alpha(Kit.tokens.inkMain, 0.06) }
            Rectangle { x: 56 * sz.k; y: 12 * sz.k; width: 4 * sz.k; height: 36 * sz.k; radius: 2 * sz.k; color: Qt.alpha(Kit.tokens.inkMain, 0.5) }
            DocDim { from: 56 * sz.k; to: 60 * sz.k; at: 52 * sz.k + 24; n: "4" }
            DocDim { from: 44 * sz.k; to: 60 * sz.k; at: -24; flip: true; n: "16" }
            DocDim { vertical: true; from: 0; to: 12 * sz.k; at: 60 * sz.k + 40; flip: true; n: "12" }
        }
    }

    F { n: "do-float"
        Long { x: 24; y: 24; width: 370; height: 172; neutral: true; at: 40; bar: "moving" }
    }
    F { n: "dont-gutter"
        Long { x: 24; y: 24; width: 370; height: 172; neutral: true; at: 40; rowW: 340 }
        Rectangle { x: 24 + 340; y: 24; width: 30; height: 172; color: Qt.alpha(Kit.tokens.inkMain, 0.06) }
        Rectangle { x: 24 + 340 + 13; y: 24 + 12; width: 4; height: 70; radius: 2; color: Qt.alpha(Kit.tokens.inkMain, 0.5) }
    }
}
