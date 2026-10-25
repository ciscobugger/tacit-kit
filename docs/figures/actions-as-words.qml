// Actions as words page figures: a track's panel in a window, the three pieces, the states, the measures and two guidelines.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 200], ["sizes", 760, 300], ["confirm", 760, 300], ["do-risk-last", 418, 220], ["dont-risk-first", 418, 220], ["do-words", 418, 220], ["dont-rings", 418, 220]]
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
        PageHeader { width: hw.shown; crumbs: ["Music"]; here: "Albums" }
        Column {
            x: 12; y: 80; width: hw.shown - 300 - 36
            SectionHeading { text: "Recently added" }
            ListRow { width: parent.width; glyph: "music_note"; name: "Undertow"; facts: ["18:02"]; factWidths: [56]; selected: true }
            ListRow { width: parent.width; glyph: "music_note"; name: "Salt Road"; facts: ["4:21"]; factWidths: [56] }
            ListRow { width: parent.width; glyph: "music_note"; name: "Low tide"; facts: ["3:48"]; factWidths: [56] }
        }
        DockedPanel {
            x: hw.shown - 300; y: 73; height: 230; open: true; openWidth: 300
            Column {
                x: 20; y: 18; width: 260; spacing: 2
                TacitText { text: "Undertow"; size: "body"; weight: "medium" }
                TacitText { text: "Mara Velde"; ink: "sec" }
                Item { width: 1; height: 8 }
                WordAction { width: 260; text: "Add to queue" }
                WordAction { width: 260; text: "Show in Files" }
                WordAction { width: 260; text: "Remove from library"; risk: true }
            }
        }
    }

    F { n: "anatomy"
        // the pieces' sizes, measured as WordAction sets them
        TacitText { id: mRename; visible: false; text: "Rename" }
        Item {
            id: anat
            readonly property real k: 1.6
            readonly property real m: app.t.space.m
            readonly property real wx: 24 + m * k     // the words' left edge in the panel; the wash reaches m*k further left
            readonly property real ty: (40 - mRename.implicitHeight) / 2 * k
            x: (parent.width - 534) / 2; y: (parent.height - 212) / 2; width: 534; height: 212
            DocKPanel { width: parent.width; height: parent.height }
            Column {
                x: anat.wx; y: 10
                Item { width: 280 * anat.k; height: 64; WordAction { text: "Rename"; scale: anat.k; transformOrigin: Item.TopLeft } }
                Item { width: 280 * anat.k; height: 64; WordAction { text: "Share"; previewState: "hover"; scale: anat.k; transformOrigin: Item.TopLeft } }
                Item { width: 280 * anat.k; height: 64; WordAction { text: "Delete"; risk: true; scale: anat.k; transformOrigin: Item.TopLeft } }
            }
            DocCallout { n: 1; side: "left"; line: -34; rect: Qt.rect(anat.wx, 10 + anat.ty, mRename.implicitWidth * anat.k, mRename.implicitHeight * anat.k) }
            DocCallout { n: 2; side: "right"; line: anat.width + 34; surface: true; rect: Qt.rect(24, 74, 486, 64) }
            DocCallout { n: 3; side: "left"; line: -34; rect: Qt.rect(anat.wx, 138 + (64 - 15 * anat.k) / 2, 15 * anat.k, 15 * anat.k) }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ s: "" }, { s: "hover" }, { s: "pressed" }, { s: "focus" }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 4
                Column {
                    anchors.centerIn: parent; width: parent.width - 40; spacing: 20
                    WordAction { width: parent.width; text: "Rename"; previewState: col.modelData.s }
                    WordAction { width: parent.width; text: "Delete"; risk: true; previewState: col.modelData.s }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            // the wash runs 12 px beyond the width on each side; 85 px of dimension line to its left, 39 below
            x: (parent.width - 571) / 2 + 85; y: (parent.height - 120 - 39) / 2
            WordAction { width: 150; text: "Delete"; risk: true; scale: 3; transformOrigin: Item.TopLeft; previewState: "hover" }
            DocDim { from: -36; to: 0; at: 120 + 16; n: "12" }
            DocDim { from: 0; to: 45; at: 120 + 16; n: "15" }
            DocDim { from: 45; to: 69; at: 120 + 16; n: "8" }
            DocDim { vertical: true; from: 0; to: 120; at: -60; n: "40" }
        }
    }

    F { n: "confirm"
        Repeater {
            model: [{ s: "" }, { s: "confirming" }]
            Item {
                id: row
                required property var modelData
                required property int index
                y: 40 + index * 110; width: 760; height: 110
                Rectangle { visible: row.index > 0; x: 16; width: 728; height: 1; color: Qt.alpha(app.t.inkMain, 0.10) }
                DocMarker { x: 174; anchors.verticalCenter: parent.verticalCenter; n: row.index + 1 }
                Item { x: 226; width: 360; height: parent.height
                    DocKPanel { anchors.fill: parent; anchors.topMargin: 12; anchors.bottomMargin: 12 }
                    WordAction { x: 20; width: 320; anchors.verticalCenter: parent.verticalCenter; text: "Delete forever"; confirm: "Delete Budget 2027.xlsx for good"; previewState: row.modelData.s } }
            }
        }
    }

    F { n: "do-risk-last"
        DocCentre { cw: 370
            DocKPanel { width: 370; height: cl1.height + 48 }
            Column { id: cl1; x: 25; y: 24; width: 320
                WordAction { width: 320; text: "Rename" }
                WordAction { width: 320; text: "Share" }
                WordAction { width: 320; text: "Delete"; risk: true }
            }
        }
    }
    F { n: "dont-risk-first"
        DocCentre { cw: 370
            DocKPanel { width: 370; height: cl2.height + 48 }
            Column { id: cl2; x: 25; y: 24; width: 320
                WordAction { width: 320; text: "Delete"; risk: true }
                WordAction { width: 320; text: "Rename" }
                WordAction { width: 320; text: "Share" }
            }
        }
    }
    F { n: "do-words"
        DocCentre { cw: 370
            DocKPanel { width: 370; height: cl3.height + 48 }
            Column { id: cl3; x: 25; y: 24; width: 320
                WordAction { width: 320; text: "Rename" }
                WordAction { width: 320; text: "Share" }
                WordAction { width: 320; text: "Move to the trash" }
            }
        }
    }
    F { n: "dont-rings"
        DocCentre { cw: 370
            DocKPanel { width: 370; height: cl4.height + 48 }
            Column { id: cl4; x: 100; y: 24; spacing: 6
                Slab { text: "Rename"; width: 170 }
                Slab { text: "Share"; width: 170 }
                Slab { text: "Move to the trash"; width: 170 }
            }
        }
    }
}
