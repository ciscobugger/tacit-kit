// Test figures for asking in place (not a docs page): the kit's own ListRow editing for a rename and for a new folder,
// and a Slab and a WordAction at rest and confirming, in a window with neighbours. Run: tools/figures.sh in-place <out>.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["rename", 900, 520], ["newfolder", 900, 520], ["confirm-rest", 900, 340], ["confirming", 900, 340], ["word-rest", 900, 340], ["word-confirming", 900, 340]]
    readonly property var t: Kit.tokens
    readonly property var files: [
        ["description", "Lease agreement.pdf", "2.2 MB", "14:40"], ["description", "Budget 2027.xlsx", "84 kB", "09:12"],
        ["archive", "photos-october.zip", "420 MB", "Yesterday"], ["description", "notes-2026.md", "6 kB", "Yesterday"],
        ["description", "Receipts 2026.pdf", "1.1 MB", "Mon"], ["image", "dune-light.jpg", "3.4 MB", "Mon"],
        ["image", "orbit-red.jpg", "2.9 MB", "Sun"], ["description", "Garden plan.odt", "41 kB", "Sat"]]

    component Window: DocWindow {
        id: w
        property string scene
        property var rows: app.files
        property int selectedRow: -1
        property int editRow: -1
        property bool editAll: false
        default property alias over: extra.data
        anchors.fill: parent
        wx: 40; wy: 32
        Rail {
            height: parent.height
            RailRow { glyph: "schedule"; label: "Recent" }
            RailSection { text: "Places" }
            RailRow { glyph: "home"; label: "Home" }
            RailRow { glyph: "description"; label: "Documents"; current: true }
            RailRow { glyph: "download"; label: "Downloads" }
            RailRow { glyph: "image"; label: "Pictures" }
        }
        PageHeader {
            id: head
            x: 300; width: w.shown - 300; crumbs: ["Home"]; here: "Documents"
            IconButton { id: newFolder; symbol: "create_new_folder"; label: "New folder" }
            IconButton { symbol: "grid_view"; label: "View" }
        }
        Column {
            x: 300 + 12; y: head.fullHeight + 8; width: w.shown - 300 - 24
            Repeater {
                model: w.rows
                ListRow {
                    required property var modelData
                    required property int index
                    width: parent.width; focusable: false
                    glyph: modelData[0]; name: modelData[1]; facts: [modelData[2], modelData[3]]; factWidths: [64, 92]
                    selected: index === w.selectedRow
                    previewState: index === w.editRow ? "editing" : ""; editAll: w.editAll
                }
            }
        }
        readonly property point folderAt: newFolder.mapToItem(w, 0, 0)
        readonly property real folderW: newFolder.width
        readonly property real folderH: newFolder.height
        Item { id: extra; anchors.fill: parent }
    }

    Window {
        visible: app.fig === "rename"
        selectedRow: 1; editRow: 1
    }
    Window {
        visible: app.fig === "newfolder"
        selectedRow: 0; editRow: 0; editAll: true
        rows: [["folder", "Untitled folder", "Empty", "Now"]].concat(app.files.slice(0, 7))
    }

    // the Trash: the action that cannot be undone sits under the list
    component Trash: Window {
        id: tw
        property string state: ""
        property bool word: false
        rows: [app.files[0], app.files[3], app.files[4]]
        Slab { visible: !tw.word; x: 300 + 12 + 16; y: 73 + 8 + 3 * 44 + 20
               text: "Empty trash"; confirm: "Delete 12 files for good"; tone: "risk"; previewState: tw.state }
        WordAction { visible: tw.word; x: 300 + 12 + 52; y: 73 + 8 + 3 * 44 + 20
               width: 260; text: "Empty trash"; confirm: "Delete 12 files for good"; previewState: tw.state }
    }
    Trash { visible: app.fig === "confirm-rest" }
    Trash { visible: app.fig === "confirming"; state: "confirming" }
    Trash { visible: app.fig === "word-rest"; word: true }
    Trash { visible: app.fig === "word-confirming"; word: true; state: "confirming" }
}
