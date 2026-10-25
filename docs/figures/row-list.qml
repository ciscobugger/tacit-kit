// Row list page's figures: a list of rows in a window (hero), anatomy, the selection states as four lists side by
// side, sizes, and two judged examples. Spec figures sit on the calm stage with neutral content.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 200], ["sizes", 760, 300], ["do-run", 418, 220], ["dont-notched", 418, 220]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens

    // a RowList as an app binds it: n neutral rows, `sel` the selected indexes, `at` where the keyboard is
    component Demo: RowList {
        id: list
        property int n: 3
        property var sel: []
        property int at: -1
        property bool ringOn: false
        property var names: []
        property string head: ""
        implicitHeight: n * 44
        model: n
        delegate: ListRow {
            required property int index
            width: list.rowWidth
            focusable: false
            glyph: "description"
            name: list.names.length ? list.names[index] : "Name"
            facts: ["Fact"]; factWidths: [64]
            selected: list.sel.indexOf(index) >= 0
            joinAbove: list.sel.indexOf(index - 1) >= 0
            joinBelow: list.sel.indexOf(index + 1) >= 0
            previewState: list.ringOn && index === list.at ? "focus" : ""
            opacity: list.sel.length || list.ringOn ? 1 : 1
        }
    }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        Column {
            x: 12; y: 6; width: hw.shown - 36
            SectionHeading { text: "Today" }
            RowList {
                id: hl
                width: parent.width; height: 4 * 44
                model: [{ g: "music_note", n: "Undertow - Mara Velde.mp3", a: "bandcamp.com", f: ["11.6 MB", "18:02"] },
                        { g: "deployed_code", n: "tacit-1.1.7-x86_64.iso", a: "download.tacitos.co", f: ["2.9 GB", "16:15"] },
                        { g: "picture_as_pdf", n: "Lease agreement.pdf", a: "docs.google.com", f: ["2.2 MB", "14:40"] },
                        { g: "description", n: "notes-2026.md", a: "", f: ["44 kB", "11:20"] }]
                delegate: ListRow {
                    required property var modelData
                    required property int index
                    width: hl.rowWidth; focusable: false
                    glyph: modelData.g; name: modelData.n; aside: modelData.a; facts: modelData.f
                    selected: hl.isSelected(index)
                    joinAbove: hl.isSelected(index - 1); joinBelow: hl.isSelected(index + 1)
                    previewState: index === 2 ? "focus" : ""
                }
                Component.onCompleted: setSelection([1, 2])
            }
        }
    }

    // anatomy: a list with a heading, a run of two selected rows and the keyboard's place
    F { n: "anatomy"
        TacitText { id: mHead; visible: false; text: "Heading"; size: "body"; weight: "strong" }
        Item {
            id: an
            // the heading is 50 high, each row 44; the part is centred with its ring columns
            x: (parent.width - 520) / 2; y: (parent.height - 226) / 2 - 10; width: 520; height: 226
            SectionHeading { id: ah; text: "Heading" }
            Demo { id: al; y: 50; width: 520; n: 4; sel: [1, 2]; at: 3; ringOn: true; opacity: 1 }
            DocCallout { n: 1; side: "left"; line: -44; rect: Qt.rect(16, 38 - mHead.implicitHeight, mHead.implicitWidth, mHead.implicitHeight) }
            DocCallout { n: 2; side: "left"; line: -44; surface: true; rect: Qt.rect(0, 50 + 44, 520, 88) }
            DocCallout { n: 4; side: "right"; line: 520 + 44; surface: true; rect: Qt.rect(-4, 50 + 132 - 4, 528, 52) }
            DocCallout { n: 3; side: "right"; line: 520 + 44; rect: Qt.rect(0, 50, 520, 44) }
        }
    }

    // states: four lists, one column each
    F { n: "states"
        Item {
            anchors.fill: parent
            Repeater {
                model: [{ sel: [], at: -1 }, { sel: [0], at: -1 }, { sel: [0, 1], at: -1 }, { sel: [0], at: 1, ring: true }]
                DocCol {
                    id: col
                    required property var modelData
                    required property int index
                    slot: index; count: 4
                    RowList {
                        anchors.verticalCenter: parent.verticalCenter; anchors.verticalCenterOffset: 5; width: parent.width; height: 2 * 44
                        id: sl
                        model: 2
                        delegate: ListRow {
                            required property int index
                            width: sl.rowWidth; focusable: false
                            glyph: "description"; name: "Name"; facts: []
                            selected: col.modelData.sel.indexOf(index) >= 0
                            joinAbove: col.modelData.sel.indexOf(index - 1) >= 0
                            joinBelow: col.modelData.sel.indexOf(index + 1) >= 0
                            previewState: col.modelData.ring === true && index === col.modelData.at ? "focus" : ""
                        }
                    }
                }
            }
        }
    }

    // sizes: the list's own measures, at 1: row 44, ring room 4, width up to 720
    F { n: "sizes"
        Item {
            // the list with 49 px of dimension line to its left and 39 below it
            x: (parent.width - 500 - 49) / 2 + 49; y: (parent.height - 132 - 39) / 2 - 6
            Demo { id: sz; width: 500; n: 3; sel: [1] }
            DocDim { vertical: true; from: 44; to: 88; at: -24; n: "44" }
            DocDim { from: 0; to: 500; at: 132 + 16; n: "500" }
        }
    }

    F { n: "do-run"
        DocCentre { cw: 370; ch: 118
            Demo { width: 370; n: 3; sel: [0, 1]; names: ["Lease agreement.pdf", "Invoice 2026-09.pdf", "notes-2026.md"] }
        }
    }
    // don't: every selected row its own round wash, notched where they touch
    F { n: "dont-notched"
        DocCentre { cw: 370; ch: 118
            Column {
                width: 370
                ListRow { width: parent.width; focusable: false; glyph: "description"; name: "Lease agreement.pdf"; facts: ["Fact"]; factWidths: [64]; selected: true }
                ListRow { width: parent.width; focusable: false; glyph: "description"; name: "Invoice 2026-09.pdf"; facts: ["Fact"]; factWidths: [64]; selected: true }
                ListRow { width: parent.width; focusable: false; glyph: "description"; name: "notes-2026.md"; facts: ["Fact"]; factWidths: [64] }
            }
        }
    }
}
