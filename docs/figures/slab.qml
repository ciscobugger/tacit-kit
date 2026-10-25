// Slab page figures: the owner's ring button in a window, its three tones, its states, its sizes and two guidelines.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 300], ["sizes", 760, 200], ["confirm", 760, 200],
              ["do-one-forward", 418, 160], ["dont-two-forward", 418, 160], ["do-risk-last", 418, 160], ["dont-risk-fill", 418, 160]]
    readonly property var t: Kit.tokens
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    component Sized: Item {            // a slab at a scale, laid out at its scaled size
        id: sz
        property real k: 1
        property string text: "Name"
        property string tone: ""
        property string previewState: ""
        property bool large: false
        width: s.implicitWidth * k; height: s.implicitHeight * k
        Slab { id: s; text: sz.text; tone: sz.tone; large: sz.large; previewState: sz.previewState
               transformOrigin: Item.TopLeft; scale: sz.k * (s.down ? app.t.state.pressScale : 1) }
    }

    DocWindow {
        visible: app.fig === "hero"; anchors.fill: parent
        Column {
            x: 44; y: 34; width: parent.parent.shown - 88; spacing: 12
            TacitText { text: "Restart to finish updating"; size: "headline"; cut: "display"; weight: "strong" }
            TacitText { width: parent.width - 60; wrapMode: Text.WordWrap; text: "Tacit 1.1.8 is installed. Your windows come back after the restart."; ink: "sec"; size: "body" }
            Item { width: 1; height: 8 }
            Row {
                spacing: 12
                Slab { tone: "default"; text: "Restart now"; large: true }
                Slab { text: "Later"; large: true }
            }
        }
    }

    F { n: "anatomy"
        Row {
            id: anat
            readonly property real k: 1.8
            // the figure's own height: 47 above the ring, the slab, 51 below it; centred on the stage
            y: (parent.height - (47 + 40 * k + 51)) / 2 + 47
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 64
            Repeater {
                model: [{ tone: "default", text: "Restart now", name: "Forward" }, { tone: "", text: "Later", name: "Quiet" }, { tone: "risk", text: "Delete", name: "Risk" }]
                Item {
                    id: col
                    required property var modelData
                    readonly property bool risky: modelData.tone === "risk"
                    readonly property real k: anat.k
                    // the pieces as the slab sets them: the word and the warning symbol in a row, centred
                    TacitText { id: mw; visible: false; text: col.modelData.text; weight: col.modelData.tone === "default" ? "medium" : "regular" }
                    readonly property real rowW: (risky ? 15 + 7 : 0) + mw.implicitWidth
                    readonly property real x0: (sl.width / k - rowW) / 2
                    readonly property real pillH: modelData.tone === "default" ? 40 : 36
                    width: sl.width; height: sl.height
                    Sized { id: sl; k: anat.k; tone: col.modelData.tone; text: col.modelData.text }
                    TacitText { y: sl.height + 12; text: col.modelData.name; weight: "medium" }
                    // the pieces are numbered once, on the risk slab; the other two carry their name
                    // the ring: a line, so its leader ends on the stroke at the top of the pill
                    DocCallout { visible: col.risky; n: 1; side: "top"; line: -36; surface: true; inset: 0.5; along: sl.width * 0.8
                                 rect: Qt.rect(0, (40 - col.pillH) / 2 * col.k, sl.width, col.pillH * col.k) }
                    DocCallout { visible: col.risky; n: 2; side: "bottom"; line: sl.height + 40
                                 rect: Qt.rect((col.x0 + (col.risky ? 22 : 0)) * col.k, (20 - mw.implicitHeight / 2) * col.k, mw.implicitWidth * col.k, mw.implicitHeight * col.k) }
                    DocCallout { visible: col.risky; n: 3; side: "top"; line: -36
                                 rect: Qt.rect(col.x0 * col.k, (20 - 7.5) * col.k, 15 * col.k, 15 * col.k) }
                }
            }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ s: "" }, { s: "hover" }, { s: "pressed" }, { s: "focus" }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 4
                Column {
                    anchors.centerIn: parent; anchors.verticalCenterOffset: 12; spacing: 24
                    Slab { anchors.horizontalCenter: parent.horizontalCenter; tone: "default"; text: "Restart"; previewState: col.modelData.s }
                    Slab { anchors.horizontalCenter: parent.horizontalCenter; text: "Later"; previewState: col.modelData.s }
                    Slab { anchors.horizontalCenter: parent.horizontalCenter; tone: "risk"; text: "Delete"; previewState: col.modelData.s }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            // two slabs at 1.5 times; 49 px of dimension line left of each, 39 below
            x: (parent.width - 49 - fw.width - 90 - qt.width) / 2 + 49; y: (parent.height - fw.height - 39) / 2
            Sized { id: fw; k: 1.5; tone: "default"; text: "Restart now" }
            Sized { id: qt; x: fw.width + 90; y: (fw.height - height) / 2; k: 1.5; text: "Later" }
            DocDim { vertical: true; from: 0; to: fw.height; at: -24; n: "40" }
            DocDim { from: 0; to: 26 * 1.5; at: fw.height + 16; n: "26" }
            DocDim { vertical: true; from: qt.y; to: qt.y + qt.height; at: qt.x - 24; n: "36" }
            DocDim { from: qt.x; to: qt.x + 18 * 1.5; at: fw.height + 16; n: "18" }
        }
    }

    F { n: "confirm"
        Repeater {
            model: [{ s: "" }, { s: "confirming" }]
            Item {
                id: row
                required property var modelData
                required property int index
                y: index * 100; width: 760; height: 100
                Rectangle { visible: row.index > 0; x: 16; width: 728; height: 1; color: Qt.alpha(app.t.inkMain, 0.10) }
                DocMarker { x: 242; anchors.verticalCenter: parent.verticalCenter; n: row.index + 1 }
                Slab { x: 294; anchors.verticalCenter: parent.verticalCenter; text: "Empty trash"; confirm: "Delete 12 files for good"; tone: "risk"; previewState: row.modelData.s }
            }
        }
    }

    F { n: "do-one-forward"
        Column { anchors.centerIn: parent; spacing: 14
            TacitText { text: "Trash: 12 files"; size: "body"; weight: "medium" }
            Row { spacing: 12
                Slab { text: "Restore all" }
                Slab { tone: "risk"; text: "Empty trash" }
            }
        }
    }
    F { n: "dont-two-forward"
        Column { anchors.centerIn: parent; spacing: 14
            TacitText { text: "Update ready"; size: "body"; weight: "medium" }
            Row { spacing: 12
                Slab { tone: "default"; text: "Later" }
                Slab { tone: "default"; text: "Restart now" }
            }
        }
    }
    F { n: "do-risk-last"
        Column { anchors.centerIn: parent; spacing: 14
            TacitText { text: "Trash: 12 files"; size: "body"; weight: "medium" }
            Row { spacing: 12
                Slab { text: "Restore all" }
                Slab { tone: "risk"; text: "Empty trash" }
            }
        }
    }
    F { n: "dont-risk-fill"
        Column { anchors.centerIn: parent; spacing: 14
            TacitText { text: "Trash: 12 files"; size: "body"; weight: "medium" }
            Row { spacing: 12
                Slab { text: "Restore all" }
                // drawn by hand: a filled button in the risk colour is not a kit part
                Rectangle {
                    width: 116; height: 40; radius: 20; color: app.t.risk
                    TacitText { anchors.centerIn: parent; text: "Empty trash"; color: app.t.windowGround; weight: "medium" }
                }
            }
        }
    }
}
