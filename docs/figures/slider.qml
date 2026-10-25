// Slider page figures: sound settings in a window, the pieces, the states, the measures and a guideline.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 200], ["states", 760, 200], ["sizes", 760, 200], ["do-label-and-word", 418, 160], ["dont-no-label", 418, 160]]
    readonly property var t: Kit.tokens
    component F: Item {
        property string n
        visible: app.fig === n
        anchors.fill: parent
        DocGlass { anchors.fill: parent }
    }
    // a settings row: the name, then the slider with its value as a word
    component SliderRow: Item {
        id: sr
        property string name
        property alias value: sl.value
        property alias word: sl.word
        property alias previewState: sl.previewState
        property bool named: true
        property real fade: 1
        height: 44
        opacity: fade
        TacitText { visible: sr.named; x: 16; anchors.verticalCenter: parent.verticalCenter; text: sr.name }
        Slider { id: sl; x: sr.named ? 190 : 16; width: parent.width - x - 16; anchors.verticalCenter: parent.verticalCenter; label: sr.name }
    }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Settings"]; here: "Sound" }
        Column {
            x: 12; y: 80; width: hw.shown - 36
            SectionHeading { text: "Volume" }
            SliderRow { width: parent.width; name: "Output volume"; value: 0.65; word: "65 %"; previewState: "hover" }
            SliderRow { width: parent.width; name: "Alert volume"; value: 0.8; word: "80 %" }
            SliderRow { width: parent.width; name: "Microphone"; value: 0.4; word: "40 %" }
        }
    }

    F { n: "anatomy"
        TacitText { id: mWord; visible: false; text: "65 %"; cut: "numbers" }
        Item {
            id: an
            readonly property real k: 2
            readonly property real trackW: (260 - 72) * k
            readonly property real reachedW: trackW * 0.65
            readonly property real knobX: 0.65 * (188 - 14) * k
            readonly property real mid: 14 * k       // the track's centre line
            // from the top rings to the bottom rings, centred on the stage
            x: (parent.width - 260 * k) / 2; y: (parent.height - 132) / 2 + 41; width: 260 * k; height: 28 * k
            Slider { scale: an.k; transformOrigin: Item.TopLeft; width: 260; value: 0.65; word: "65 %"; label: "Output volume"; previewState: "hover" }
            // the reached part is boxed up to the knob's box (it runs on under the knob); the track is a surface, its leader
            // ending on the bar's centre line
            DocCallout { n: 1; side: "bottom"; line: 80; rect: Qt.rect(0, an.mid - 6, an.knobX - 9, 12) }
            DocCallout { n: 2; side: "bottom"; line: 80; surface: true; rect: Qt.rect(an.reachedW + 30, an.mid, an.trackW - an.reachedW - 30, 7) }
            DocCallout { n: 3; side: "top"; line: -30; rect: Qt.rect(an.knobX, an.mid - 14, 28, 28) }
            DocCallout { n: 4; side: "top"; line: -30; rect: Qt.rect(260 * an.k - mWord.implicitWidth * an.k, an.mid - mWord.implicitHeight * an.k / 2, mWord.implicitWidth * an.k, mWord.implicitHeight * an.k) }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ s: "", e: true }, { s: "hover", e: true }, { s: "focus", e: true }, { s: "", e: false }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 4; marker: false
                Column { anchors.centerIn: parent; width: parent.width; spacing: 24
                    DocMarker { anchors.horizontalCenter: parent.horizontalCenter; n: col.index + 1 }
                    Slider { width: parent.width; value: 0.65; word: "65 %"; label: "Output volume"; previewState: col.modelData.s; enabled: col.modelData.e }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            id: sz
            readonly property real k: 2
            // 81 px of dimension lines on the left, 24 above, 40 below: the block is centred as a whole
            x: (parent.width - 520 + 81) / 2; y: (parent.height - 56 - 24 - 40) / 2 + 24
            Slider { scale: sz.k; transformOrigin: Item.TopLeft; width: 260; value: 0.65; word: "65 %"; label: "Output volume"; previewState: "hover" }
            DocDim { vertical: true; from: 0; to: 28 * sz.k; at: -56; n: "28" }
            DocDim { vertical: true; from: 14 * sz.k - 3 * sz.k; to: 14 * sz.k + 3 * sz.k; at: -14; n: "6" }
            DocDim { from: 113 * sz.k; to: 127 * sz.k; at: 2; flip: true; n: "14" }
            DocDim { from: 0; to: 188 * sz.k; at: 56 + 16; n: "188" }
            DocDim { from: 188 * sz.k; to: 260 * sz.k; at: 56 + 16; n: "72" }
        }
    }

    F { n: "do-label-and-word"
        DocCentre {
            Column {
                anchors.centerIn: parent; width: 360
                SliderRow { width: parent.width; name: "Volume"; value: 0.65; word: "65 %" }
            }
        }
    }
    F { n: "dont-no-label"
        DocCentre { cw: 360; ch: 44
            Column {
                x: 0; width: 360
                SliderRow { width: parent.width; name: "Volume"; value: 0.65; named: false }
            }
        }
    }
}
