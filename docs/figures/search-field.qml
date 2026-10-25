// Search field page's figures: the field in a header in a window (hero), anatomy, states, sizes, two judged examples.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 200], ["states", 760, 300], ["sizes", 760, 200], ["do-scope", 418, 160], ["dont-bare", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader {
            width: hw.shown; crumbs: ["Home"]; here: "Downloads"
            SearchField { anchors.verticalCenter: parent.verticalCenter; scope: "Downloads"; previewState: "typed"; fieldWidth: 300 }
        }
        Column {
            x: 12; y: 73; width: hw.shown - 36
            SectionHeading { text: "Today" }
            ListRow { width: parent.width; focusable: false; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; aside: "docs.google.com"; facts: ["2.2 MB", "14:40"]; selected: true }
            ListRow { width: parent.width; focusable: false; glyph: "description"; name: "Lease - draft.md"; facts: ["44 kB", "11:20"] }
        }
    }

    F { n: "anatomy"
        // the pieces' sizes, as the field sets them (the field is drawn at 1.5 times)
        TacitText { id: mWord; visible: false; text: "lease" }
        Symbol { id: mSym; visible: false; text: "search" }
        Item {
            id: anat
            readonly property real k: 1.5
            readonly property real w: 360 * k
            readonly property real h: 36 * k
            x: (parent.width - w) / 2; y: (parent.height - h) / 2; width: w; height: h
            Item { scale: anat.k; transformOrigin: Item.TopLeft
                SearchField { scope: "Downloads"; previewState: "typed"; fieldWidth: 360 } }
            DocCallout { n: 1; side: "top"; line: -34
                         rect: Qt.rect(10 * anat.k, (36 - mSym.height) / 2 * anat.k, mSym.width * anat.k, mSym.height * anat.k) }
            DocCallout { n: 2; side: "top"; line: -34
                         rect: Qt.rect(36 * anat.k, (36 - mWord.implicitHeight) / 2 * anat.k, mWord.implicitWidth * anat.k, mWord.implicitHeight * anat.k) }
            DocCallout { n: 3; side: "top"; line: -34; rect: Qt.rect((360 - 18 - 9) * anat.k, 9 * anat.k, 18 * anat.k, 18 * anat.k) }
            DocCallout { n: 4; side: "bottom"; line: anat.h + 34; surface: true; rect: Qt.rect(0, 0, anat.w, anat.h) }
        }
    }

    // states: six fields in a grid of two columns by three
    F { n: "states"
        Grid {
            x: 36; y: 26; columns: 2; columnSpacing: 40; rowSpacing: 30
            Repeater {
                model: [{ n: 1, s: "" }, { n: 2, s: "hover" }, { n: 3, s: "open" }, { n: 4, s: "typed" }, { n: 5, s: "focus" }]
                Item { id: cell; required property var modelData; width: 330; height: 70
                    DocMarker { n: cell.modelData.n; y: 7 }
                    SearchField { x: 34; y: 0; scope: "Downloads"; previewState: cell.modelData.s; fieldWidth: 296 } }
            }
        }
    }

    F { n: "sizes"
        Item { id: m
            readonly property real k: 1.5
            // the field, 49 px of dimension line to its left, 16 above it (number and tick 41) and 39 below
            x: (parent.width - 450 - 49) / 2 + 49; y: (parent.height - 54 - 41 - 39) / 2 + 41
            Item { scale: m.k; transformOrigin: Item.TopLeft; width: 300; height: 36
                SearchField { scope: "Downloads"; previewState: "typed"; fieldWidth: 300 } }
            DocDim { vertical: true; from: 0; to: 36 * m.k; at: -24; n: "36" }
            DocDim { from: 0; to: 450; at: -16; flip: true; n: "300" }
            DocDim { from: 0; to: 10 * m.k; at: 36 * m.k + 16; n: "10" }
            DocDim { from: 10 * m.k; to: 36 * m.k; at: 36 * m.k + 16; n: "26" }
        }
    }

    F { n: "do-scope"
        DocCentre { cw: 250; ch: 36
            Item { x: 33; width: 250; height: 36
                SearchField { scope: "Downloads"; fieldWidth: 250 } }
        }
    }
    F { n: "dont-bare"
        DocCentre { cw: 250; ch: 36
            Item { x: 76; width: 250; height: 36
                // drawn by hand: the part always names its scope
                Symbol { x: 10; anchors.verticalCenter: parent.verticalCenter; text: "search"; color: app.t.inkSec }
                TacitText { x: 36; anchors.verticalCenter: parent.verticalCenter; text: "Search"; ink: "sec" } }
        }
    }
}
