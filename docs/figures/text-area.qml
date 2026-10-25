// TextArea page figures: a note in a docked panel, the pieces, the states, the growth, the measures and two guidelines.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 400], ["anatomy", 760, 400], ["states", 760, 200], ["growth", 760, 300], ["sizes", 760, 300], ["do-label", 418, 220], ["dont-no-label", 418, 220],
              ["do-hint", 418, 160], ["dont-hint", 418, 160]]
    readonly property var t: Kit.tokens
    component F: Item {
        property string n
        visible: app.fig === n
        anchors.fill: parent
        DocGlass { anchors.fill: parent }
    }
    readonly property string note: "Signed copy sent to the landlord on 14 October. Deposit due before the first of November."

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        wx: 24; wy: 24
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Files"]; here: "Downloads" }
        Column {
            x: 12; y: 76; width: hw.shown - 400 - 24
            SectionHeading { text: "Today" }
            ListRow { width: parent.width; glyph: "music_note"; name: "Undertow - Mara Velde.mp3"; facts: ["18:02"]; factWidths: [56] }
            ListRow { width: parent.width; glyph: "deployed_code"; name: "tacit-1.1.7-x86_64.iso"; facts: ["16:15"]; factWidths: [56] }
            ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; facts: ["14:40"]; factWidths: [56]; selected: true }
        }
        DockedPanel {
            x: hw.shown - 400; y: 73; height: 327; open: true
            Column {
                x: 24; y: 22; width: 352; spacing: 8
                TacitText { text: "Note"; size: "body"; weight: "medium" }
                TextArea { id: heroArea; width: parent.width; label: "Note"; text: app.note; previewState: "focus"; Component.onCompleted: heroArea.focusIn() }
                Item { width: 1; height: 8 }
                Row {
                    spacing: 12
                    Slab { tone: "default"; text: "Save" }
                    Slab { text: "Cancel" }
                }
            }
        }
    }

    F { n: "anatomy"
        TacitText { id: mHint; visible: false; text: "Anything to remember about this file" }
        Item {
            id: anat
            readonly property real k: 1.6
            readonly property real fx: 24
            readonly property real f1y: 28
            readonly property real f2y: f1y + a1.height * k + 34
            readonly property real m: app.t.space.m
            readonly property real ring: 4 * k
            x: (parent.width - 560) / 2; y: 54; width: 560; height: f2y + a2.height * k + 24
            DocKPanel { width: parent.width; height: parent.height }
            TextArea { id: a1; x: anat.fx; y: anat.f1y; scale: anat.k; transformOrigin: Item.TopLeft; width: 320; label: "Note"; text: "Signed copy sent to the landlord."; previewState: "focus"
                       Component.onCompleted: a1.focusIn() }
            TextArea { id: a2; x: anat.fx; y: anat.f2y; scale: anat.k; transformOrigin: Item.TopLeft; width: 320; label: "Note"; hint: "Anything to remember about this file" }
            DocCallout { n: 2; side: "top"; line: -10
                         rect: Qt.rect(anat.fx + anat.m * anat.k, anat.f1y + a1.pad * anat.k, a1.input.contentWidth * anat.k, a1.input.contentHeight * anat.k) }
            DocCallout { n: 4; side: "left"; line: -34
                         rect: Qt.rect(anat.fx + (anat.m + a1.input.cursorRectangle.x) * anat.k - 1, anat.f1y + (a1.pad + a1.input.cursorRectangle.y) * anat.k,
                                       1.5 * anat.k + 2, a1.input.cursorRectangle.height * anat.k) }
            DocCallout { n: 3; side: "right"; line: anat.width + 34
                         rect: Qt.rect(anat.fx + anat.m * anat.k, anat.f2y + a2.pad * anat.k, mHint.implicitWidth * anat.k, mHint.implicitHeight * anat.k) }
            DocCallout { n: 5; side: "left"; line: -34
                         rect: Qt.rect(anat.fx - anat.ring, anat.f1y - anat.ring, 320 * anat.k + 2 * anat.ring, a1.height * anat.k + 2 * anat.ring) }
            DocCallout { n: 1; side: "left"; line: -34; surface: true
                         rect: Qt.rect(anat.fx, anat.f2y, 320 * anat.k, a2.height * anat.k); along: anat.f2y + a2.height * anat.k / 2 }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ s: "", t: "", e: false }, { s: "hover", t: "", e: false }, { s: "focus", t: "Signed copy sent to the landlord.", e: false }, { s: "", t: "Signed copy sent to the landlord.", e: true }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 4
                TextArea { width: parent.width; anchors.verticalCenter: parent.verticalCenter; label: "Note"; hint: "A note"; text: col.modelData.t; previewState: col.modelData.s; error: col.modelData.e }
            }
        }
    }

    F { n: "growth"
        Row {
            id: gr
            x: (parent.width - 3 * 200 - 2 * 40) / 2; y: 40; spacing: 40
            TextArea { id: g1; width: 200; label: "Note"; text: "One line." }
            TextArea { id: g2; width: 200; label: "Note"; text: "Signed copy sent to the landlord on 14 October. Deposit due before the first of November. Keys back by the end of the month." }
            TextArea { id: g3; width: 200; label: "Note"; text: app.note + " " + app.note + " " + app.note + " " + app.note + " " + app.note + " " + app.note }
            Component.onCompleted: console.error("DUMP growth", g1.height, g2.height, g3.height, g1.line, g1.pad)
        }
        Row {
            x: gr.x; y: 40 + 166 + 20; spacing: 40
            Repeater { model: [{ t: "3 lines at least" }, { t: "Grows with the text" }, { t: "8 lines, then it scrolls" }]
                TacitText { required property var modelData; width: 200; text: modelData.t; ink: "sec"; horizontalAlignment: Text.AlignHCenter } }
        }
    }

    F { n: "sizes"
        Item {
            id: sz
            readonly property real k: 1.5
            x: (parent.width - 320 * k) / 2 + 31; y: 100
            TextArea { id: sa; scale: sz.k; transformOrigin: Item.TopLeft; width: 320; label: "Note"; text: "Signed copy sent to the landlord on 14 October." }
            DocDim { vertical: true; from: 0; to: sa.height * sz.k; at: -30; n: String(Math.round(sa.height)) }
            DocDim { from: 0; to: 12 * sz.k; at: sa.height * sz.k + 24; n: "12" }
            DocDim { from: 0; to: 320 * sz.k; at: -24; flip: true; n: "320" }
        }
    }

    component Panel: Item {
        default property alias content: col.data
        property alias spacing: col.spacing
        width: 340; height: col.height + 32
        DocKPanel { anchors.fill: parent }
        Column { id: col; x: 16; y: 16; width: parent.width - 32 }
    }
    F { n: "do-label"; DocCentre { Panel { spacing: 8; TacitText { text: "Note"; ink: "sec" } TextArea { width: parent.width; label: "Note"; text: "Signed copy sent to the landlord." } } } }
    F { n: "dont-no-label"; DocCentre { Panel { TextArea { width: parent.width; label: "Note"; text: "Signed copy sent to the landlord." } } } }
    F { n: "do-hint"; DocCentre { Panel { spacing: 8; TacitText { text: "Note"; ink: "sec" } TextArea { width: parent.width; label: "Note"; hint: "Anything to remember about this file"; minLines: 2 } } } }
    F { n: "dont-hint"; DocCentre { Panel { TextArea { width: parent.width; label: "Note"; hint: "Note"; minLines: 2 } } } }
}
