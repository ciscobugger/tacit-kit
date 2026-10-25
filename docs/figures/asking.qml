// Asking page's figures: a rename in its row, a new folder, an Undo notice, the Trash asking in place, and two pairs.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["rename", 760, 300], ["newfolder", 760, 300], ["undo", 760, 300], ["confirm-rest", 760, 300], ["confirming", 760, 300],
              ["do-undo", 418, 220], ["dont-sure", 418, 220], ["do-confirm", 418, 220], ["dont-at-once", 418, 220]]
    readonly property var t: Kit.tokens
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    readonly property var files: [
        ["description", "Lease agreement.pdf", "2.2 MB", "14:40"], ["description", "Budget 2027.xlsx", "84 kB", "09:12"],
        ["archive", "photos-october.zip", "420 MB", "Yesterday"], ["description", "notes-2026.md", "6 kB", "Yesterday"],
        ["image", "dune-light.jpg", "3.4 MB", "Mon"]]

    // a Files window's corner: header and rows, the rail left out so the list has the room
    component Files: DocWindow {
        id: w
        property var rows: app.files
        property int editRow: -1
        property bool editAll: false
        property bool fresh: false
        property int selectedRow: -1
        property string crumb: "Documents"
        property alias header: head.data
        default property alias over: extra.data
        anchors.fill: parent
        wx: 48; wy: 32
        PageHeader { id: head; width: w.shown; crumbs: ["Home"]; here: w.crumb }
        Column {
            x: 12; y: head.fullHeight + 8; width: w.shown - 24
            Repeater {
                model: w.rows
                ListRow {
                    required property var modelData
                    required property int index
                    width: parent.width; focusable: false
                    glyph: modelData[0]; name: modelData[1]; facts: [modelData[2], modelData[3]]; factWidths: [64, 92]
                    selected: index === w.selectedRow
                    previewState: index === w.editRow ? "editing" : ""; editAll: w.editAll; fresh: w.fresh && index === w.editRow
                }
            }
        }
        Item { id: extra; anchors.fill: parent }
    }

    Files { visible: app.fig === "hero"; selectedRow: 2; editRow: 2; crumb: "Archive" }
    Files { visible: app.fig === "rename"; selectedRow: 2; editRow: 2; crumb: "Pictures"
        rows: [["image", "orbit-red.jpg", "2.9 MB", "Sun"], ["image", "Garden plan.png", "410 kB", "Sat"], ["image", "dune-light.jpg", "3.4 MB", "Mon"], ["image", "shore.jpg", "3.1 MB", "Fri"]] }
    Files {
        visible: app.fig === "newfolder"
        selectedRow: 0; editRow: 0; editAll: true; fresh: true
        rows: [["folder", "Untitled folder", "Empty", "Now"]].concat(app.files.slice(0, 4))
    }
    Files {
        visible: app.fig === "undo"
        rows: app.files.slice(0, 2)
        Item { anchors.fill: parent; anchors.bottomMargin: 32; Notice { previewState: "shown"; text: "Moved 3 files to the trash"; actionWords: "Undo" } }
    }

    // the Trash: what cannot be undone is confirmed by the action itself
    component Trash: Files {
        id: tw
        property string state: ""
        crumb: "Trash"
        rows: [app.files[0], app.files[3]]
        Slab { x: 12 + 16; y: 73 + 8 + 2 * 44 + 16
               text: "Empty trash"; confirm: "Delete 12 files for good"; tone: "risk"; previewState: tw.state }
    }
    Trash { visible: app.fig === "confirm-rest" }
    Trash { visible: app.fig === "confirming"; state: "confirming" }

    // guidelines: a short list on the calm stage
    component Rows: Column {
        property int n: 3
        Repeater { model: parent.n
            ListRow { width: parent.width; focusable: false; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64] } }
    }
    // drawn by hand: a question in a box over a dimmed page (the kit has no such part)
    component Box: Item {
        property string q
        property string go
        property string cancel: "Cancel"
        width: 360; height: 140
        Rectangle { anchors.fill: parent; radius: 16; color: app.t.overlay; border.width: 1; border.color: Qt.alpha(app.t.inkMain, 0.10) }
        TacitText { x: 24; y: 22; width: parent.width - 48; text: q; size: "body"; weight: "medium"; wrapMode: Text.WordWrap }
        Row { x: 24; y: 82; spacing: 12
            Slab { text: cancel }
            Slab { text: go; tone: "risk" } }
    }

    F { n: "do-undo"
        Item { width: parent.width; height: 212
            Rows { x: 12; y: 24; width: parent.width - 24; n: 2 }
            Notice { previewState: "shown"; text: "Moved 3 files to the trash"; actionWords: "Undo" } }
    }
    F { n: "dont-sure"
        Item { anchors.fill: parent
            Rows { x: 12; y: 24; width: parent.width - 24; n: 2; opacity: 0.35 }
            Box { anchors.centerIn: parent; q: "Are you sure you want to move 3 files to the trash?"; go: "Move" } }
    }
    F { n: "do-confirm"
        Item { y: 62; width: parent.width; height: 96
            Rows { x: 12; width: parent.width - 24; n: 1 }
            Slab { x: 28; y: 60; text: "Empty trash"; confirm: "Delete 12 files for good"; tone: "risk"; previewState: "confirming" } }
    }
    F { n: "dont-at-once"
        Item { y: 28; width: parent.width; height: 180
            Rows { x: 12; width: parent.width - 24; n: 1 }
            Slab { x: 28; y: 60; text: "Empty trash"; tone: "risk" }
            Notice { previewState: "shown"; text: "Deleted 12 files" } }
    }
}
