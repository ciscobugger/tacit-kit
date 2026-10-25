// Page state page's figures: an empty folder in a window (hero), anatomy of a failure, the three kinds (nothing here,
// failed, still being read), sizes, two judged examples.
import QtQuick
import Quickshell
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 590], ["sizes", 760, 300],
              ["do-sentence", 418, 160], ["dont-centred", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Home", "Downloads"]; here: "old"
            SearchField { anchors.verticalCenter: parent.verticalCenter; scope: "old"; fieldWidth: 240 } }
        PageState { x: 40; y: 104; text: "Nothing in this folder. Drop files here to move them in." }
    }

    F { n: "anatomy"
        // the pieces' sizes, measured as PageState sets them: the symbol 20, the sentence at body size, the action below with 16 between
        TacitText { id: mSay; visible: false; text: "TRANSFER was removed. Plug it in again to see its files."; size: "body" }
        Slab { id: mAct; visible: false; text: "Go to Home"; tone: "default" }
        Item {
            id: an
            readonly property real rowH: Math.max(20, mSay.implicitHeight)
            readonly property real sx: 20 + 10
            x: (parent.width - ps.implicitWidth) / 2; y: (parent.height - ps.implicitHeight) / 2; width: ps.implicitWidth; height: ps.implicitHeight
            PageState { id: ps; text: mSay.text; failure: true; action: "Go to Home" }
            DocCallout { n: 1; side: "top"; line: -34; rect: Qt.rect(0, (an.rowH - 20) / 2, 20, 20) }
            DocCallout { n: 2; side: "top"; line: -34; rect: Qt.rect(an.sx, (an.rowH - mSay.implicitHeight) / 2, mSay.implicitWidth, mSay.implicitHeight) }
            DocCallout { n: 3; side: "bottom"; line: an.height + 34; rect: Qt.rect(0, an.rowH + 16, mAct.implicitWidth, mAct.implicitHeight) }
        }
    }

    // the three kinds, each under its own header
    F { n: "states"
        Column {
            x: 0; y: 0; width: 760
            Repeater {
                model: [{ n: 1, here: "old", cr: ["Home", "Downloads"], text: "Nothing in this folder. Drop files here to move them in." },
                        { n: 2, here: "TRANSFER", cr: [], text: "TRANSFER was removed. Plug it in again to see its files.", fail: true, action: "Go to Home" },
                        { n: 3, here: "TRANSFER", cr: [], reading: true }]
                Item {
                    id: blk
                    required property var modelData
                    width: 760; height: 196
                    DocMarker { n: blk.modelData.n; x: 8; y: 26 }
                    PageHeader { x: 36; width: 700; crumbs: blk.modelData.cr; here: blk.modelData.here; loading: (blk.modelData.reading ?? false) && app.fig === "states" }
                    PageState { visible: blk.modelData.text !== undefined; x: 36 + 40; y: 104; text: blk.modelData.text ?? ""; failure: blk.modelData.fail ?? false; action: blk.modelData.action ?? "" }
                    Column { visible: blk.modelData.reading === true; x: 36 + 12; y: 80; width: 676
                        ListRow { width: parent.width; focusable: false; glyph: "folder"; name: "backups"; facts: ["12 items", "4 Oct"] }
                        ListRow { width: parent.width; focusable: false; glyph: "folder"; name: "Book4 archives"; facts: ["38 items", "22 Sep"] }
                    }
                    Rectangle { visible: blk.modelData.n < 3; y: parent.height - 1; x: 36; width: 700; height: 1; color: Qt.alpha(app.t.inkMain, 0.10) }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            // the page, 49 px of dimension line to its left; 191 high with the action
            x: (parent.width - 650 - 49) / 2 + 49; y: (parent.height - 191) / 2
            PageHeader { width: 650; crumbs: []; here: "TRANSFER" }
            PageState { x: 40; y: 104; text: "TRANSFER was removed. Plug it in again to see its files."; failure: true; action: "Go to Home" }
            DocDim { vertical: true; from: 0; to: 104; at: -24; n: "104" }
            DocDim { from: 0; to: 40; at: 116; n: "40" }
        }
    }

    F { n: "do-sentence"
        DocCentre {
            PageState { x: 40; y: 40; maxWidth: 340; text: "Nothing in this folder. Drop files here to move them in." }
        }
    }
    // drawn by hand: centred, with a picture and a second action (the part is never centred and has no picture)
    F { n: "dont-centred"
        Column { anchors.centerIn: parent; spacing: 10
            Symbol { anchors.horizontalCenter: parent.horizontalCenter; text: "folder"; size: 48; color: app.t.inkMeta }
            TacitText { anchors.horizontalCenter: parent.horizontalCenter; text: "Oops, nothing here yet!"; size: "body"; weight: "strong" }
            TacitText { anchors.horizontalCenter: parent.horizontalCenter; text: "Add some files to get started."; ink: "sec" }
        }
    }
}
