// Jump index page's figures: the index at the right edge of a list in a window (hero), anatomy, states of a mark,
// sizes, two judged examples. The part's `marks` is shortened to fit a figure.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 400], ["states", 760, 200], ["sizes", 760, 300],
              ["do-all", 418, 300], ["dont-removed", 418, 300]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens
    component R: ListRow { focusable: false; glyph: "music_note"; facts: ["3:41"]; factWidths: [56] }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        Column {
            x: 12; y: 0; width: hw.shown - 36 - 44
            SectionHeading { text: "Songs" }
            Repeater { model: [["Aurora", "Mara Velde", "3:41"], ["Bandcamp Sunday", "Low Tide", "4:12"], ["Dust", "Low Tide", "5:01"],
                               ["Glasshouse", "Mara Velde", "2:58"], ["Harbour", "Low Tide", "3:36"], ["Kettle", "Hana Oru", "4:40"]]
                ListRow { required property var modelData; width: parent.width; focusable: false; glyph: "music_note"; name: modelData[0]; aside: modelData[1]; facts: [modelData[2]]; factWidths: [64] }
            }
        }
        JumpIndex { x: hw.shown - 44 - 8; y: 6; marks: "ABCDEFGHIJ".split(""); present: ["A", "B", "D", "G", "H", "J"]; previewHover: "G" }
    }

    F { n: "anatomy"
        // a mark's size, measured as JumpIndex sets it: a 13 px letter centred in a place 44 wide, 28 high
        TacitText { id: mark; visible: false; text: "G"; size: "meta" }
        Item {
            id: anat
            readonly property real k: 1.5
            x: (parent.width - 44 * k) / 2; y: (parent.height - 7 * 28 * k) / 2; width: 44 * k; height: 7 * 28 * k
            JumpIndex { id: ji; scale: anat.k; transformOrigin: Item.TopLeft
                marks: "EFGHIJK".split(""); present: ["G", "H", "K"]; previewHover: "G" }
            // the letter of place `row` (0 is E), centred in its place
            function letter(row) {
                return Qt.rect((width - mark.implicitWidth * k) / 2, (row * 28 + 14) * k - mark.implicitHeight * k / 2, mark.implicitWidth * k, mark.implicitHeight * k);
            }
            DocCallout { n: 3; side: "left"; line: -50; rect: anat.letter(1) }
            DocCallout { n: 1; side: "right"; line: anat.width + 50; rect: anat.letter(2) }
            DocCallout { n: 2; side: "right"; line: anat.width + 50; rect: anat.letter(3) }
        }
    }

    F { n: "states"
        Row {
            anchors.fill: parent
            Repeater {
                model: [{ hover: "", present: ["G", "H", "K"] }, { hover: "H", present: ["G", "H", "K"] }, { hover: "", present: ["G", "K"] }]
                Item {
                    id: col
                    required property var modelData
                    required property int index
                    width: 253; height: 200
                    Rectangle { visible: col.index > 0; width: 1; height: parent.height; color: Qt.alpha(app.t.inkMain, 0.10) }
                    DocMarker { n: col.index + 1; x: 126 - 33 - 11 - 20; y: 37 + 28 * 1.5 + 10 }
                    JumpIndex { x: 126 - 33; y: 37; scale: 1.5; transformOrigin: Item.TopLeft
                        marks: ["G", "H", "K"]; present: col.modelData.present; previewHover: col.modelData.hover }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            id: m
            readonly property real k: 1.5
            // the index (44 wide, five marks), its width above it (41 px) and one step to its right (49 px)
            x: (parent.width - 44 * m.k - 49) / 2; y: (parent.height - 210 - 41) / 2 + 41
            JumpIndex { scale: m.k; transformOrigin: Item.TopLeft; marks: "GHIJK".split(""); present: ["G", "H", "K"] }
            DocDim { from: 0; to: 44 * m.k; at: -16; flip: true; n: "44" }
            DocDim { vertical: true; from: 28 * m.k * 2; to: 28 * m.k * 3; at: 44 * m.k + 24; flip: true; n: "28" }
        }
    }

    // a list with its index, A to H: the marks the list has are lit, the others faint
    component Page: Item {
        property var marks: "ABCDEFGH".split("")
        Column { x: 24; y: 0; width: 300
            R { width: parent.width; name: "Aurora" }
            R { width: parent.width; name: "Bandcamp" }
            R { width: parent.width; name: "Dust" }
            R { width: parent.width; name: "Glasshouse" }
            R { width: parent.width; name: "Harbour" }
        }
        JumpIndex { x: 350; marks: parent.marks; present: ["A", "B", "D", "G", "H"] }
    }
    F { n: "do-all"; Page { anchors.verticalCenter: parent.verticalCenter; height: 224 } }
    F { n: "dont-removed"; Page { marks: ["A", "B", "D", "G", "H"]; anchors.verticalCenter: parent.verticalCenter; height: 224 } }
}
