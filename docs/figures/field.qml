// Field page figures: a tag in a docked panel, the pieces, the states, the measures and a guideline.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 400], ["anatomy", 760, 400], ["states", 760, 200], ["sizes", 760, 200], ["do-label", 418, 220], ["dont-no-label", 418, 220]]
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
            x: hw.shown - 400; y: 73; height: 300; open: true
            Column {
                x: 24; y: 22; width: 352; spacing: 8
                TacitText { text: "Add a tag"; size: "body"; weight: "medium" }
                Field { width: parent.width; label: "Tag"; text: "Tax 2026"; previewState: "focus" }
                Item { width: 1; height: 8 }
                Row {
                    spacing: 12
                    Slab { tone: "default"; text: "Add tag" }
                    Slab { text: "Cancel" }
                }
            }
        }
    }

    F { n: "anatomy"
        // the pieces' sizes, measured as Field sets them
        TacitText { id: mHint; visible: false; text: "A name for the file" }
        Item {
            id: anat
            readonly property real k: 1.6
            readonly property real fx: 24
            readonly property real f1y: 30
            readonly property real f2y: 118
            readonly property real fh: 36 * k
            readonly property real fw: 320 * k
            readonly property real m: app.t.space.m
            readonly property real ring: 4 * k   // the ring sits 2 px out and is 2 px wide
            x: (parent.width - 560) / 2; y: (parent.height - 206) / 2; width: 560; height: 206
            DocKPanel { width: parent.width; height: parent.height }
            Field { id: f1; x: anat.fx; y: anat.f1y; scale: anat.k; transformOrigin: Item.TopLeft; width: 320; label: "Name"; text: "Lease agreement.pdf"; previewState: "focus"
                    Component.onCompleted: f1.focusIn() }
            Field { x: anat.fx; y: anat.f2y; scale: anat.k; transformOrigin: Item.TopLeft; width: 320; label: "Name"; hint: "A name for the file" }
            DocCallout { n: 2; side: "top"; line: -34
                         rect: Qt.rect(anat.fx + anat.m * anat.k, anat.f1y + f1.input.y * anat.k, f1.input.contentWidth * anat.k, f1.input.height * anat.k) }
            DocCallout { n: 4; side: "top"; line: -34
                         rect: Qt.rect(anat.fx + (anat.m + f1.input.cursorRectangle.x) * anat.k - 1, anat.f1y + (f1.input.y + f1.input.cursorRectangle.y) * anat.k,
                                       1.5 * anat.k + 2, f1.input.cursorRectangle.height * anat.k) }
            DocCallout { n: 3; side: "bottom"; line: anat.height + 34
                         rect: Qt.rect(anat.fx + anat.m * anat.k, anat.f2y + (anat.fh - mHint.implicitHeight * anat.k) / 2, mHint.implicitWidth * anat.k, mHint.implicitHeight * anat.k) }
            DocCallout { n: 5; side: "left"; line: -34
                         rect: Qt.rect(anat.fx - anat.ring, anat.f1y - anat.ring, anat.fw + 2 * anat.ring, anat.fh + 2 * anat.ring) }
            DocCallout { n: 1; side: "right"; line: anat.width + 34; surface: true
                         rect: Qt.rect(anat.fx, anat.f2y, anat.fw, anat.fh); along: anat.f2y + anat.fh / 2 }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ s: "", t: "", h: "Name" }, { s: "hover", t: "", h: "Name" }, { s: "focus", t: "Lease", h: "Name" }, { s: "", t: "Lease.pdf", h: "Name" }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 4
                Field { width: parent.width; anchors.verticalCenter: parent.verticalCenter; label: "Name"; text: col.modelData.t; hint: col.modelData.h; previewState: col.modelData.s }
            }
        }
    }

    F { n: "sizes"
        Item {
            x: (parent.width - 480 + 49) / 2; y: (parent.height - 54 - 39) / 2
            Field { scale: 1.5; transformOrigin: Item.TopLeft; width: 320; label: "Name"; text: "Lease agreement.pdf"; previewState: "hover" }
            DocDim { from: 0; to: 18; at: 54 + 16; n: "12" }
            DocDim { vertical: true; from: 0; to: 54; at: -24; n: "36" }
        }
    }

    F { n: "do-label"
        DocCentre { cw: 370
            DocKPanel { width: 370; height: cl1.height + 48 }
            Column { id: cl1; x: 24; y: 24; width: 322; spacing: 8
                TacitText { text: "Name"; ink: "sec" }
                Field { width: parent.width; label: "Name"; text: "Lease agreement.pdf" }
            }
        }
    }
    F { n: "dont-no-label"
        DocCentre { cw: 370
            DocKPanel { width: 370; height: cl2.height + 48 }
            Column { id: cl2; x: 24; y: 24; width: 322; spacing: 12
                Field { width: parent.width; label: "Name"; text: "Lease agreement.pdf" }
                Field { width: parent.width; label: "Folder"; text: "Downloads" }
            }
        }
    }
}
