// Progress: in use (a copy in a file manager), anatomy, states, sizes, one do and one don't.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 200], ["states", 760, 300], ["sizes", 760, 200], ["do-words", 418, 160], ["dont-alone", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    DocWindow {
        visible: app.fig === "hero"
        anchors.fill: parent
        wx: 64; wy: 40; wallX: -400; wallY: -600
        PageHeader { width: 704; canGoBack: true; crumbs: ["Home"]; here: "Backup drive" }
        Column {
            x: 12; y: 88; width: 660
            ListRow { width: parent.width; glyph: "deployed_code"; name: "photos-october.zip"; facts: ["420 MB", "08:31"]; selected: true }
            ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; facts: ["2.2 MB", "14:40"] }
            ListRow { width: parent.width; glyph: "description"; name: "Budget 2027.xlsx"; facts: ["84 kB", "09:12"] }
        }
        Item { x: 28; y: 238; width: 640; height: 40
            TacitText { text: "Copying photos-october.zip to Backup drive"; ink: "sec" }
            TacitText { anchors.right: parent.right; text: "62 %"; ink: "sec"; cut: "numbers" }
            Progress { y: 28; width: parent.width; value: 0.62; label: "Copying photos-october.zip" }
        }
    }

    F { n: "anatomy"
        // the words and the bar at twice their size; the words' box measured from the text as the page sets it
        TacitText { id: mWords; visible: false; text: "Copying Name"; ink: "sec" }
        Item {
            id: anat
            readonly property real k: 2
            readonly property real w: 280 * k
            readonly property real wordsH: mWords.implicitHeight * k
            readonly property real barY: wordsH + 20
            // from the ring above the words to the foot of the bar and the ring below it, centred on the stage
            readonly property real blockTop: -41
            readonly property real blockBottom: barY + 8 + 34 + 11
            x: (parent.width - (w + 55)) / 2; y: parent.height / 2 - (blockTop + blockBottom) / 2
            width: w; height: barY + 8
            TacitText { text: "Copying Name"; ink: "sec"; transformOrigin: Item.TopLeft; scale: anat.k }
            Progress { y: anat.barY; width: 280; value: 0.6; label: "Name"; transformOrigin: Item.TopLeft; scale: anat.k }
            DocCallout { n: 1; side: "bottom"; line: anat.barY + 8 + 34; rect: Qt.rect(0, anat.barY, anat.w * 0.6, 8) }
            DocCallout { n: 2; side: "right"; line: anat.w + 44; surface: true; rect: Qt.rect(anat.w * 0.6, anat.barY, anat.w * 0.4, 8) }
            DocCallout { n: 3; side: "top"; line: -30; rect: Qt.rect(0, 0, mWords.implicitWidth * anat.k, anat.wordsH) }
        }
    }

    F { n: "states"
        DocCentre {
        Column {
            spacing: 22
            Repeater {
                model: [[0, "Not started", false], [0.25, "A quarter", false], [0.6, "More than half", false], [1, "Done", false], [0, "End not known", true]]
                Row {
                    id: r
                    required property var modelData
                    required property int index
                    spacing: 20
                    DocMarker { n: r.index + 1; anchors.verticalCenter: parent.verticalCenter }
                    TacitText { width: 140; anchors.verticalCenter: parent.verticalCenter; text: r.modelData[1]; ink: "sec" }
                    Progress { visible: !r.modelData[2]; width: 480; anchors.verticalCenter: parent.verticalCenter; value: r.modelData[0]; label: "Name" }
                    // the end-not-known bar is a loop; one moment of it, the stretch min(220, width / 3) wide
                    Item { visible: r.modelData[2]; width: 480; height: 4; anchors.verticalCenter: parent.verticalCenter; clip: true
                        Rectangle { anchors.fill: parent; radius: 2; color: Kit.tokens.past }
                        Rectangle { x: 190; width: Math.min(220, parent.width / 3); height: 4; radius: 2; color: Kit.tokens.accent } }
                }
            }
        }
        }
    }

    F { n: "sizes"
        Item {
            // the bar at 2 times, 49 px of dimension line to its left and 39 below, centred as a whole
            x: (parent.width - 480 + 49) / 2; y: (parent.height - 8 - 39) / 2
            Progress { width: 240; value: 0.5; label: "Name"; transformOrigin: Item.TopLeft; scale: 2 }
            DocDim { vertical: true; from: 0; to: 8; at: -24; n: "4" }
            DocDim { from: 0; to: 480; at: 8 + 16; n: "240" }
        }
    }

    F { n: "do-words"
        DocCentre { cw: 370
            Column { y: 62; width: parent.width; spacing: 10
                TacitText { text: "Updating Tacit, 38 %"; ink: "sec" }
                Progress { width: parent.width; value: 0.38; label: "Updating Tacit" }
                TacitText { text: "About 4 minutes left"; ink: "meta" }
            }
        }
    }
    F { n: "dont-alone"
        DocCentre { cw: 370
            Progress { y: 96; width: parent.width; value: 0.38; label: "Updating Tacit" }
        }
    }
}
