// Waveform: in use, anatomy, states, sizes, one do and one don't.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 300], ["sizes", 760, 300], ["do-sound", 418, 160], ["dont-job", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var peaks: [0.4, 0.42, 0.41, 0.43, 0.43, 0.42, 0.42, 0.43, 0.44, 0.46, 0.45, 0.45, 0.47, 0.49, 0.51, 0.53, 0.58, 0.7, 0.57, 0.61, 0.57, 0.62, 0.64, 0.57, 0.28, 0.68, 0.68, 0.66, 0.69, 0.68, 0.68, 0.67, 0.68, 0.69, 0.69, 0.68, 0.64, 0.68, 0.68, 0.68, 0.58, 0.64, 0.97, 0.96, 0.97, 0.97, 0.97, 0.97, 0.94, 0.94, 0.98, 0.97, 0.95, 0.98, 0.98, 0.98, 0.96, 0.61, 0.84, 0.98, 0.98, 0.96, 0.97, 0.99, 0.96, 0.96, 0.97, 0.98, 0.95, 0.98, 0.98, 0.97, 0.97, 0.93, 0.39, 0.99, 0.98, 0.96, 0.99, 0.98, 0.98, 0.97, 0.95, 0.97, 0.98, 0.98, 0.98, 0.96, 0.99, 0.96, 0.8, 0.46, 0.5, 0.53, 0.55, 0.52, 0.48, 0.52, 0.54, 0.55, 0.77, 0.61, 0.6, 0.62, 0.63, 0.66, 0.47, 0.31, 0.82, 0.97, 0.97, 0.97, 0.95, 0.98, 0.95, 0.96, 0.97, 0.98, 0.95, 0.98, 0.98, 0.98, 0.97, 0.92, 0.41, 0.98, 0.97, 0.96, 0.97, 0.98, 0.98, 0.96, 0.95, 0.96, 0.98, 0.97, 0.97, 0.96, 0.99, 0.96, 0.8, 0.67, 1.0, 0.96, 0.98, 1.0, 0.98, 0.97, 0.96, 0.96, 0.98, 0.98, 0.97, 0.98, 0.98, 0.97, 0.96, 0.59, 0.62, 0.68, 0.68, 0.69, 0.64, 0.68, 0.68, 0.69, 0.69, 0.69, 0.65, 0.67, 0.69, 0.68, 0.69, 0.64, 0.27, 0.23, 0.15, 0.15, 0.15, 0.15]

    DocWindow {
        visible: app.fig === "hero"
        anchors.fill: parent
        wx: 64; wy: 40; wallX: -400; wallY: -600
        Column {
            x: 40; y: 44; width: 600; spacing: 6
            TacitText { text: "Voice memo 14"; size: "alarm"; cut: "display"; weight: "strong" }
            TacitText { text: "Today, 08:31"; size: "section"; ink: "sec" }
            Item { width: 1; height: 22 }
            Waveform { width: parent.width; height: 56; peaks: app.peaks; position: 0.38; playhead: true }
            Item { width: parent.width; height: 20
                TacitText { text: "0:52"; ink: "sec"; cut: "numbers" }
                TacitText { anchors.right: parent.right; text: "2:17"; ink: "sec"; cut: "numbers" }
            }
        }
    }

    F { n: "anatomy"
        Item {
            id: anat
            readonly property real k: 1.5
            readonly property real tail: 8                      // the playhead's reach above and below the bars
            readonly property real topLine: -tail * k - 30
            readonly property real botLine: (32 + tail) * k + 30
            // the bars as the part draws them: bar i is `bar` wide at i * step + (step - bar) / 2, as tall as its level
            readonly property int played: { let n = 0; for (let i = 0; i < wv.count; i++) if ((i + 0.5) / wv.count < wv.position) n++; return n; }
            function tallest(a, b) { let m = 0; for (let i = a; i < b; i++) m = Math.max(m, Math.max(wv.bar, wv.height * wv.levels[i])); return m; }
            function span(a, b) { return Qt.rect((a * wv.step + (wv.step - wv.bar) / 2) * k, (32 - tallest(a, b)) / 2 * k,
                                                 ((b - a - 1) * wv.step + wv.bar) * k, tallest(a, b) * k); }
            readonly property rect playedBox: span(0, played)
            readonly property rect restBox: span(played, wv.count)
            width: 400 * k; height: 32 * k
            x: (760 - width) / 2; y: (300 - (botLine + 11 - (topLine - 11))) / 2 - (topLine - 11)
            Item { scale: anat.k; transformOrigin: Item.TopLeft
                Waveform { id: wv; width: 400; height: 32; peaks: app.peaks; position: 0.5; playhead: true } }
            // the boxes meet the playhead's gap, so each leaves out its side there
            DocCallout { n: 1; side: "top"; line: anat.topLine; open: "right"; rect: anat.playedBox }
            DocCallout { n: 2; side: "top"; line: anat.topLine; open: "left"; rect: anat.restBox }
            // the playhead is a line: the dot goes on its tail below the bars, clear of them
            DocCallout { n: 3; side: "bottom"; line: anat.botLine; surface: true; inset: 3
                         rect: Qt.rect(wv.width * wv.position * anat.k - 1.5, -anat.tail * anat.k, 3, (32 + 2 * anat.tail) * anat.k) }
        }
    }

    F { n: "states"
        Column {
            x: 82; y: 60; spacing: 16
            Repeater {
                model: [["Not played", { p: 0 }], ["Played to here", { p: 0.4 }], ["With the playhead", { p: 0.4, ph: true }], ["Keyboard focus", { p: 0.4, st: "focus" }]]
                Row {
                    id: r
                    required property var modelData
                    required property int index
                    spacing: 20
                    DocMarker { n: r.index + 1; anchors.verticalCenter: parent.verticalCenter }
                    TacitText { width: 150; anchors.verticalCenter: parent.verticalCenter; text: r.modelData[0]; ink: "sec" }
                    Waveform { width: 380; anchors.verticalCenter: parent.verticalCenter; peaks: app.peaks; position: r.modelData[1].p; playhead: r.modelData[1].ph ?? false; previewState: r.modelData[1].st ?? "" }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            // the waveform at 4 times, 49 px of dimension line to its left and 39 below, centred as a whole
            x: (parent.width - 240 + 49) / 2 + 4; y: (parent.height - 128 - 39) / 2
            Item { scale: 4; transformOrigin: Item.TopLeft
                Waveform { width: 60; height: 32; peaks: app.peaks; position: 0 }
            }
            DocDim { vertical: true; from: 0; to: 128; at: -24; n: "32" }
            DocDim { from: 0; to: 24; at: 128 + 16; n: "6" }
        }
    }

    F { n: "do-sound"
        DocCentre { cw: 370
            Waveform { y: 82; width: parent.width; peaks: app.peaks; position: 0.4 }
        }
    }
    F { n: "dont-job"
        DocCentre { cw: 370
            Column { y: 66; width: parent.width; spacing: 12
                TacitText { text: "Copying photos-october.zip"; ink: "sec" }
                Waveform { width: parent.width; peaks: app.peaks; position: 0.62; seekable: false }
            }
        }
    }
}
