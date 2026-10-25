// Tooltip: in use, anatomy, states (timeline), sizes, one do and one don't.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 200], ["sizes", 760, 200], ["do-symbol", 418, 160], ["dont-words", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    DocWindow {
        visible: app.fig === "hero"
        anchors.fill: parent
        wx: 64; wy: 40; wallX: -400; wallY: -600
        PageHeader { width: 704; canGoBack: true; crumbs: ["Home"]; here: "Pictures"
            IconButton { id: ib; symbol: "grid_view"; label: "Grid"; previewState: "hover"
                TooltipSurface { x: (parent.width - width) / 2; y: parent.height + 8; text: "Grid" } }
            IconButton { symbol: "list"; label: "List" }
        }
        Column {
            x: 12; y: 88; width: 660
            ListRow { width: parent.width; glyph: "image"; name: "dune-light.jpg"; facts: ["1.4 MB", "11:20"] }
            ListRow { width: parent.width; glyph: "image"; name: "orbit-red.jpg"; facts: ["980 kB", "11:18"] }
        }
    }

    F { n: "anatomy"
        TacitText { id: mWords; visible: false; text: "Fold the places"; size: "meta" }
        Item {
            id: anat
            readonly property real k: 2
            readonly property real sw: mWords.implicitWidth + 20     // the surface: 10 px of room each side of the words
            readonly property real sh: mWords.implicitHeight + 12    // and 6 above and below
            readonly property real topLine: -28
            readonly property real botLine: (44 + sh) * k + 26
            readonly property real leftLine: -40
            readonly property real rightLine: sw * k + 40
            width: sw * k; height: (44 + sh) * k
            x: (760 - (rightLine + 11 - (leftLine - 11))) / 2 - (leftLine - 11)
            y: (300 - (botLine + 11 - (topLine - 11))) / 2 - (topLine - 11)
            Item {
                scale: anat.k; transformOrigin: Item.TopLeft
                IconButton { x: (anat.sw - 36) / 2; symbol: "star"; label: "Star"; previewState: "hover" }
                TooltipSurface { y: 36 + 8; text: "Fold the places" }
            }
            DocCallout { n: 1; side: "top"; line: anat.topLine
                         rect: Qt.rect((anat.sw - 36) / 2 * anat.k, 0, 36 * anat.k, 36 * anat.k) }
            DocCallout { n: 2; side: "right"; line: anat.rightLine; surface: true
                         rect: Qt.rect(0, 44 * anat.k, anat.sw * anat.k, anat.sh * anat.k) }
            DocCallout { n: 3; side: "bottom"; line: anat.botLine
                         rect: Qt.rect(10 * anat.k, (44 + 6) * anat.k, mWords.implicitWidth * anat.k, mWords.implicitHeight * anat.k) }
            DocCallout { n: 4; side: "left"; line: anat.leftLine
                         // inset by the box's 3 px of room, so the dotted outline lies on the gap's own edges
                         rect: Qt.rect(3, 36 * anat.k + 3, anat.sw * anat.k - 6, 8 * anat.k - 6) }
        }
    }
    F { n: "states"
        Item {
            anchors.fill: parent
            Repeater {
                model: [["Pointer arrives", false, 0], ["After 600 ms", true, 1], ["Pointer leaves", false, 0.4]]
                DocCol {
                    id: col
                    required property var modelData
                    required property int index
                    slot: index; count: 3; marker: false
                    Item { anchors.centerIn: parent; width: parent.width; height: 142
                        DocMarker { x: (parent.width - 22) / 2; n: col.index + 1 }
                        IconButton { x: (parent.width - width) / 2; y: 42; symbol: "star"; label: "Star"; previewState: "hover" }
                        TooltipSurface { visible: col.modelData[1] || col.index === 2; opacity: col.modelData[2]; x: (parent.width - width) / 2; y: 42 + 36 + 8; text: "Star" }
                        TacitText { x: 0; width: parent.width; y: 128; horizontalAlignment: Text.AlignHCenter; text: col.index === 0 ? "nothing shows yet" : col.index === 1 ? "fades in, 150 ms" : "fades out, 80 ms"; ink: "meta" }
                    }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            id: sz
            readonly property real k: 2.5
            // the tip, 49 px of dimension line to its left and 39 below, centred as a whole
            x: (parent.width - m.implicitWidth * sz.k + 49) / 2; y: (parent.height - m.implicitHeight * sz.k - 39) / 2
            TooltipSurface { id: m; text: "Name"; scale: sz.k; transformOrigin: Item.TopLeft }
            DocDim { vertical: true; from: 0; to: m.implicitHeight * sz.k; at: -24; n: String(m.implicitHeight) }
            DocDim { from: 0; to: 10 * sz.k; at: m.implicitHeight * sz.k + 16; n: "10" }
            DocDim { from: m.implicitWidth * sz.k - 10 * sz.k; to: m.implicitWidth * sz.k; at: m.implicitHeight * sz.k + 16; n: "10" }
        }
    }

    F { n: "do-symbol"
        DocCentre { ch: 84
            Row { spacing: 4
                IconButton { symbol: "arrow_back"; label: "Back" }
                IconButton { symbol: "arrow_forward"; label: "Forward"; previewState: "hover"
                    TooltipSurface { x: (parent.width - width) / 2; y: parent.height + 8; text: "Forward" } }
            }
        }
    }
    F { n: "dont-words"
        DocCentre { ch: 84
            Row { spacing: 4
                WordAction { text: "Open"; width: 80; previewState: "hover"
                    TooltipSurface { x: (parent.width - width) / 2; y: parent.height + 8; text: "Open the file in its app" } }
            }
        }
    }
}
