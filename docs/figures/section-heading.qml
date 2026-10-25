// Section heading page's figures: the heading over a run of rows in a window (hero), anatomy, sizes, two judged examples.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["sizes", 760, 300], ["do-day", 418, 300], ["dont-all", 418, 300]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens
    component R: ListRow { focusable: false; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64] }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        Column {
            x: 12; y: 0; width: hw.shown - 36
            SectionHeading { text: "Today" }
            ListRow { width: parent.width; focusable: false; glyph: "music_note"; name: "Undertow - Mara Velde.mp3"; aside: "bandcamp.com"; facts: ["11.6 MB", "18:02"] }
            ListRow { width: parent.width; focusable: false; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; aside: "docs.google.com"; facts: ["2.2 MB", "14:40"] }
            SectionHeading { text: "This week" }
            ListRow { width: parent.width; focusable: false; picture: app.pics + "p11.jpg"; name: "ov02c10-capture.png"; facts: ["640 kB", "Tuesday"]; factWidths: [108, 80] }
            ListRow { width: parent.width; focusable: false; glyph: "deployed_code"; name: "tacit-1.1.7-x86_64.iso"; aside: "download.tacitos.co"; facts: ["2.9 GB", "Monday"]; factWidths: [108, 80] }
        }
    }

    F { n: "anatomy"
        TacitText { id: mHead; visible: false; text: "Heading"; size: "body"; weight: "strong" }
        Item {
            id: anat
            readonly property real k: 1.4
            x: (parent.width - 370 * k) / 2; y: (parent.height - 138 * k) / 2 - 11; width: 370 * k; height: 138 * k
            Item { scale: anat.k; transformOrigin: Item.TopLeft; width: 370; height: 140
                SectionHeading { text: "Heading" }
                R { y: 50; width: 370; opacity: 0.4 }
                R { y: 94; width: 370; opacity: 0.4 }
            }
            DocCallout { n: 1; side: "left"; line: -44
                         rect: Qt.rect(16 * anat.k, (38 - mHead.implicitHeight) * anat.k, mHead.implicitWidth * anat.k, mHead.implicitHeight * anat.k) }
            DocCallout { n: 2; side: "right"; line: anat.width + 44; rect: Qt.rect(0, 50 * anat.k, 370 * anat.k, 88 * anat.k) }
        }
    }

    // sizes: 50 high, 16 from the left, 8 under the words to the first row; shown at 1.5
    F { n: "sizes"
        Item {
            id: m
            readonly property real k: 1.5
            // 49 px of dimension line to the left, 41 above the heading; the row below is 66 high
            x: (parent.width - 510 - 49) / 2 + 49 + 13; y: (parent.height - 75 - 66 - 41) / 2 + 41 + 10
            Item { scale: m.k; transformOrigin: Item.TopLeft; width: 340; height: 140
                SectionHeading { text: "Heading" }
                R { y: 50; width: 340; opacity: 0.4 }
            }
            DocDim { vertical: true; from: 0; to: 50 * m.k; at: -24; n: "50" }
            DocDim { from: 0; to: 16 * m.k; at: -16; flip: true; n: "16" }
            DocDim { vertical: true; from: (50 - 12) * m.k; to: 50 * m.k; at: 230; flip: true; n: "12" }
        }
    }

    F { n: "do-day"
        DocCentre { cw: 370
            Column { width: 370
                SectionHeading { text: "Today" }
                R { width: parent.width; name: "Lease agreement.pdf"; facts: ["14:40"]; factWidths: [56] }
                R { width: parent.width; name: "notes-2026.md"; facts: ["11:20"]; factWidths: [56] }
                SectionHeading { text: "Tuesday" }
                R { width: parent.width; name: "IMG_2041.jpg"; facts: ["3.1 MB"]; factWidths: [56] }
            }
        }
    }
    F { n: "dont-all"
        DocCentre { cw: 370
            Column { width: 370
                SectionHeading { text: "Lease agreement.pdf" }
                R { width: parent.width; name: "Lease agreement.pdf"; facts: ["14:40"]; factWidths: [56] }
                SectionHeading { text: "notes-2026.md" }
                R { width: parent.width; name: "notes-2026.md"; facts: ["11:20"]; factWidths: [56] }
            }
        }
    }
}
