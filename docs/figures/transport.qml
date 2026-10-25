// Transport: in use (a stage), anatomy, states, sizes, one do and one don't.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 200], ["sizes", 760, 200], ["do-one-ring", 418, 160], ["dont-rings", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var peaks: [0.4, 0.42, 0.41, 0.43, 0.43, 0.42, 0.42, 0.43, 0.44, 0.46, 0.45, 0.45, 0.47, 0.49, 0.51, 0.53, 0.58, 0.7, 0.57, 0.61, 0.57, 0.62, 0.64, 0.57, 0.28, 0.68, 0.68, 0.66, 0.69, 0.68, 0.68, 0.67, 0.68, 0.69, 0.69, 0.68, 0.64, 0.68, 0.68, 0.68, 0.58, 0.64, 0.97, 0.96, 0.97, 0.97, 0.97, 0.97, 0.94, 0.94, 0.98, 0.97, 0.95, 0.98, 0.98, 0.98, 0.96, 0.61, 0.84, 0.98, 0.98, 0.96, 0.97, 0.99, 0.96, 0.96, 0.97, 0.98, 0.95, 0.98, 0.98, 0.97, 0.97, 0.93, 0.39, 0.99, 0.98, 0.96, 0.99, 0.98, 0.98, 0.97, 0.95, 0.97, 0.98, 0.98, 0.98, 0.96, 0.99, 0.96, 0.8, 0.46, 0.5, 0.53, 0.55, 0.52, 0.48, 0.52, 0.54, 0.55, 0.77, 0.61, 0.6, 0.62, 0.63, 0.66, 0.47, 0.31, 0.82, 0.97, 0.97, 0.97, 0.95, 0.98, 0.95, 0.96, 0.97, 0.98, 0.95, 0.98, 0.98, 0.98, 0.97, 0.92, 0.41, 0.98, 0.97, 0.96, 0.97, 0.98, 0.98, 0.96, 0.95, 0.96, 0.98, 0.97, 0.97, 0.96, 0.99, 0.96, 0.8, 0.67, 1.0, 0.96, 0.98, 1.0, 0.98, 0.97, 0.96, 0.96, 0.98, 0.98, 0.97, 0.98, 0.98, 0.97, 0.96, 0.59, 0.62, 0.68, 0.68, 0.69, 0.64, 0.68, 0.68, 0.69, 0.69, 0.69, 0.65, 0.67, 0.69, 0.68, 0.69, 0.64, 0.27, 0.23, 0.15, 0.15, 0.15, 0.15]

    DocWindow {
        visible: app.fig === "hero"
        anchors.fill: parent
        wx: 64; wy: 40; wallX: -400; wallY: -600
        Column {
            x: 40; y: 30; width: 600; spacing: 6
            TacitText { text: "Undertow"; size: "alarm"; cut: "display"; weight: "strong" }
            TacitText { text: "Mara Velde"; size: "section"; ink: "sec" }
            Item { width: 1; height: 10 }
            Waveform { width: parent.width; height: 40; peaks: app.peaks; position: 0.38 }
            Item { width: parent.width; height: 20
                TacitText { text: "1:54"; ink: "sec"; cut: "numbers" }
                TacitText { anchors.right: parent.right; text: "5:01"; ink: "sec"; cut: "numbers" }
            }
            Item { width: 1; height: 6 }
            Transport { x: (600 - width) / 2; size: 64; playing: true }
        }
    }

    F { n: "anatomy"
        IconButton { id: mBtn; visible: false; size: 32 }    // measure: the side buttons' room
        Item {
            id: anat
            readonly property real k: 1.5
            readonly property real bw: mBtn.implicitWidth                 // a side button, square
            readonly property real gap: Math.round(64 * 0.35)             // the Row's spacing
            readonly property real rx: bw + gap                           // the ring's left edge
            readonly property real nx: rx + 64 + gap                      // the next button's left edge
            readonly property real topLine: -28
            readonly property real botLine: 64 * k + 28
            width: (nx + bw) * k; height: 64 * k
            x: (760 - width) / 2; y: 150 - height / 2
            Item { scale: anat.k; transformOrigin: Item.TopLeft
                Transport { size: 64; playing: false } }
            DocCallout { n: 1; side: "top"; line: anat.topLine
                         rect: Qt.rect(0, (64 - anat.bw) / 2 * anat.k, anat.bw * anat.k, anat.bw * anat.k) }
            // the symbol is half the ring, centred in it
            DocCallout { n: 2; side: "bottom"; line: anat.botLine
                         rect: Qt.rect((anat.rx + 16) * anat.k, 16 * anat.k, 32 * anat.k, 32 * anat.k) }
            // the ring is a 2 px line: the dot sits on its middle
            DocCallout { n: 3; side: "top"; line: anat.topLine; surface: true; inset: anat.k
                         rect: Qt.rect(anat.rx * anat.k, 0, 64 * anat.k, 64 * anat.k) }
            DocCallout { n: 4; side: "top"; line: anat.topLine
                         rect: Qt.rect(anat.nx * anat.k, (64 - anat.bw) / 2 * anat.k, anat.bw * anat.k, anat.bw * anat.k) }
        }
    }

    F { n: "states"
        Repeater {
            model: [["Rest", {}], ["Pointer over it", { st: "hover" }], ["Pressed", { st: "pressed" }], ["Keyboard focus", { st: "focus" }], ["Playing", { playing: true }]]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 5; marker: false
                Column {
                    anchors.centerIn: parent; spacing: 20
                    DocMarker { anchors.horizontalCenter: parent.horizontalCenter; n: col.index + 1 }
                    Transport { anchors.horizontalCenter: parent.horizontalCenter; size: 40; previewState: col.modelData[1].st ?? ""; playing: col.modelData[1].playing ?? false; canPrevious: true }
                    TacitText { anchors.horizontalCenter: parent.horizontalCenter; text: col.modelData[0]; ink: "meta"; size: "meta" }
                }
            }
        }
    }

    F { n: "sizes"
        // two transports side by side, each ring's width measured above it (41 px of dimension line)
        Item {
            x: (parent.width - tpA.width - 100 - tpB.width) / 2; y: (parent.height - 64 - 41) / 2 + 41
            Transport { id: tpA; size: 64 }
            DocDim { from: tpA.children[1].x; to: tpA.children[1].x + 64; at: -16; flip: true; n: "64" }
            Transport { id: tpB; x: tpA.width + 100; y: 12; size: 40 }
            DocDim { from: tpB.x + tpB.children[1].x; to: tpB.x + tpB.children[1].x + 40; at: -4; flip: true; n: "40" }
        }
    }

    F { n: "do-one-ring"
        DocCentre {
            Column { spacing: 12
                TacitText { text: "Undertow"; size: "section"; weight: "strong" }
                Transport { size: 64; playing: false }
            }
        }
    }
    F { n: "dont-rings"
        DocCentre {
            Row { spacing: 22
                Repeater { model: ["skip_previous", "play_arrow", "skip_next"]
                    Rectangle { id: ring; required property string modelData; width: 64; height: 64; radius: 32; color: "transparent"; border.width: 2; border.color: Qt.alpha(Kit.tokens.accent, 0.8)
                        Symbol { anchors.centerIn: parent; text: ring.modelData; size: 32; color: Kit.tokens.inkMain } } }
            }
        }
    }
}
