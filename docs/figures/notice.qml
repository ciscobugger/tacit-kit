// Notice page's figures: Files' line after a move (hero), the pieces, four states, the measures, two guidelines.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 200], ["sizes", 760, 300], ["do-undo", 418, 220], ["dont-wordy", 418, 220]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    component Rows: Column {
        property var names: ["Lease agreement.pdf", "Budget 2027.xlsx", "photos-october.zip", "notes-2026.md", "Receipts 2026.pdf", "Garden plan.odt"]
        property bool neutral: false
        Repeater { model: parent.names
            ListRow { required property string modelData; width: parent.width; focusable: false; glyph: "description"; name: parent.neutral ? "Name" : modelData; facts: ["Fact"]; factWidths: [64] } }
    }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        wx: 48; wy: 20; winW: 800; winH: 290
        PageHeader { width: hw.shown; crumbs: ["Home"]; here: "Documents" }
        Column { x: 12; y: 78; width: 700
            ListRow { width: parent.width; focusable: false; glyph: "description"; name: "Budget 2027.xlsx"; facts: ["84 kB", "09:12"] }
            ListRow { width: parent.width; focusable: false; glyph: "description"; name: "Receipts 2026.pdf"; facts: ["1.1 MB", "08:40"] }
            ListRow { width: parent.width; focusable: false; glyph: "description"; name: "Garden plan.odt"; facts: ["312 kB", "07:55"] }
        }
        Notice { previewState: "shown"; text: "Moved 3 files to the trash"; actionWords: "Undo" }
    }

    F { n: "anatomy"
        TacitText { id: mL; visible: false; text: "Moved 3 files"; size: "body" }
        TacitText { id: mP; visible: false; text: "Undo"; weight: "medium" }
        Item {
            id: an
            readonly property real k: 2
            readonly property real bw: 16 + mL.implicitWidth + 12 + (mP.implicitWidth + 32) + 16
            width: (bw + 2 * 24) * k; height: 76 * k
            x: (parent.width - width) / 2; y: 73
            Item { width: parent.width / an.k; height: 76; scale: an.k; transformOrigin: Item.TopLeft
                Notice { previewState: "shown"; text: "Moved 3 files"; actionWords: "Undo" } }
            readonly property real bx: 24 * k
            readonly property real by: 16 * k
            DocCallout { n: 1; side: "top"; line: -30; rect: Qt.rect(an.bx + 16 * an.k, an.by + (44 - mL.implicitHeight) / 2 * an.k, mL.implicitWidth * an.k, mL.implicitHeight * an.k) }
            DocCallout { n: 2; side: "top"; line: -30
                         rect: Qt.rect(an.bx + (16 + mL.implicitWidth + 12) * an.k, an.by + 6 * an.k, (mP.implicitWidth + 32) * an.k, 32 * an.k) }
            DocCallout { n: 3; side: "bottom"; line: an.height + 30; surface: true; along: an.bx + 40 * an.k; inset: 8
                         rect: Qt.rect(an.bx, an.by, an.bw * an.k, 44 * an.k) }
        }
    }

    F { n: "states"
        Rectangle { x: 16; y: 100; width: 728; height: 1; color: Qt.alpha(Kit.tokens.inkMain, 0.10) }
        Rectangle { x: 380; y: 16; width: 1; height: 168; color: Qt.alpha(Kit.tokens.inkMain, 0.10) }
        Repeater {
            model: [{ s: "shown", a: "Undo" }, { s: "held", a: "Undo" }, { s: "focus", a: "Undo" }, { s: "shown", a: "" }]
            Item {
                id: row
                required property var modelData
                required property int index
                x: 32 + (index % 2) * 380; y: Math.floor(index / 2) * 100; width: 380; height: 100
                DocMarker { x: 0; anchors.verticalCenter: parent.verticalCenter; n: row.index + 1 }
                Item { x: 52; y: 12; width: 320; height: 76
                    Notice { anchors.horizontalCenter: undefined; x: 0; previewState: row.modelData.s; text: "Moved 3 files"; actionWords: row.modelData.a } }
            }
        }
    }

    F { n: "sizes"
        TacitText { id: zL; visible: false; text: "Moved 3 files"; size: "body" }
        TacitText { id: zP; visible: false; text: "Undo"; weight: "medium" }
        Item {
            id: sz
            readonly property real k: 2
            readonly property real bw: 16 + zL.implicitWidth + 12 + (zP.implicitWidth + 32) + 16
            width: (bw + 48) * k; height: 76 * k
            x: (parent.width - width) / 2 - 2; y: 77
            Item { width: parent.width / sz.k; height: 76; scale: sz.k; transformOrigin: Item.TopLeft
                Notice { previewState: "shown"; text: "Moved 3 files"; actionWords: "Undo" } }
            readonly property real bx: 24 * k
            readonly property real by: 16 * k
            DocDim { from: sz.bx; to: sz.bx + 16 * sz.k; at: sz.by - 14; flip: true; n: "16" }
            DocDim { from: sz.bx + (16 + zL.implicitWidth) * sz.k; to: sz.bx + (28 + zL.implicitWidth) * sz.k; at: sz.by - 14; flip: true; n: "12" }
            DocDim { from: sz.bx + (sz.bw - 16) * sz.k; to: sz.bx + sz.bw * sz.k; at: sz.by - 14; flip: true; n: "16" }
            DocDim { vertical: true; from: sz.by; to: sz.by + 44 * sz.k; at: sz.bx - 28; n: "44" }
            DocDim { vertical: true; from: sz.by + 6 * sz.k; to: sz.by + 38 * sz.k; at: sz.bx + sz.bw * sz.k + 36; flip: true; n: "32" }
            DocDim { vertical: true; from: sz.by + 44 * sz.k; to: 76 * sz.k; at: sz.bx + sz.bw * sz.k + 36; flip: true; n: "16" }
        }
    }

    F { n: "do-undo"
        Item { width: parent.width; height: 212
            Rows { x: 12; y: 24; width: parent.width - 24; neutral: true; names: ["Lease agreement.pdf", "Budget 2027.xlsx"] }
            Notice { previewState: "shown"; text: "Moved 3 files to the trash"; actionWords: "Undo" } }
    }
    F { n: "dont-wordy"
        Item { width: parent.width; height: 212
            Rows { x: 12; y: 24; width: parent.width - 24; neutral: true; names: ["Lease agreement.pdf", "Budget 2027.xlsx"] }
            Notice { previewState: "shown"; text: "The 3 files you chose have been moved to the trash"; actionWords: "Undo" } }
    }
}
