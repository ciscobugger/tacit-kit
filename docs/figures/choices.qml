// Choices page figures: a power setting in a window, the pieces, the states, the measures and two guidelines.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 200], ["sizes", 760, 200], ["do-three", 418, 220], ["dont-two", 418, 220],
              ["do-short", 418, 220], ["dont-sentences", 418, 220]]
    readonly property var t: Kit.tokens
    component F: Item {
        property string n
        visible: app.fig === n
        anchors.fill: parent
        DocGlass { anchors.fill: parent }
    }
    readonly property var lid: [{ label: "Suspend", detail: "Keeps your work in memory" }, { label: "Hibernate", detail: "Saves it to disk and uses no power" }, "Do nothing"]

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Settings"]; here: "Power" }
        Column {
            x: 12; y: 80; width: hw.shown - 36
            SectionHeading { text: "When the lid is closed" }
            Choices { x: 4; model: app.lid; current: 0; label: "When the lid is closed"; previewState: "hover" }
        }
    }

    F { n: "anatomy"
        TacitText { id: mA; visible: false; text: "First option" }
        TacitText { id: mD; visible: false; text: "A line under the name"; size: "meta" }
        Item {
            id: an
            readonly property real k: 1.6
            readonly property real lh: Math.max(34, 16 + mA.implicitHeight + mD.implicitHeight)
            x: 233; y: 80; width: 240 * k; height: (lh + 68) * k
            Choices { id: ch; scale: an.k; transformOrigin: Item.TopLeft
                      model: [{ label: "First option", detail: "A line under the name" }, "Second option", "Third option"]; current: 0; label: "Options"; previewState: "hover" }
            DocCallout { n: 1; side: "top"; line: -30; rect: Qt.rect(10 * an.k, (8 + (mA.implicitHeight - 16) / 2) * an.k, 16 * an.k, 16 * an.k) }
            DocCallout { n: 2; side: "left"; line: -50; rect: Qt.rect(34 * an.k, 9 * an.k, mA.implicitWidth * an.k * 1.12, (mA.implicitHeight - 2) * an.k) }
            DocCallout { n: 3; side: "right"; line: 180 * an.k + 60
                         rect: Qt.rect(34 * an.k, (9 + mA.implicitHeight) * an.k, mD.implicitWidth * an.k, (mD.implicitHeight - 2) * an.k) }
            DocCallout { n: 4; side: "left"; line: -50
                         rect: Qt.rect(34 * an.k, (an.lh + 34 + 7) * an.k, mA.implicitWidth * an.k * 1.0, mA.implicitHeight * an.k) }
            DocCallout { n: 5; side: "right"; line: 180 * an.k + 60; surface: true
                         rect: Qt.rect(0, an.lh * an.k, 180 * an.k, 34 * an.k) }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ s: "" }, { s: "hover" }, { s: "focus" }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 3
                Choices { x: (parent.width - 180) / 2; y: (parent.height - 102) / 2; model: ["Name", "Name", "Name"]; current: 0; label: "Name"; previewState: col.modelData.s }
            }
        }
    }

    F { n: "sizes"
        Item {
            id: sz
            readonly property real k: 2.5
            x: 310; y: 52
            Choices { scale: sz.k; transformOrigin: Item.TopLeft; model: ["Name"]; current: 0; label: "Name" }
            DocDim { vertical: true; from: 0; to: 34 * sz.k; at: -30; n: "34" }
            DocDim { from: 0; to: 10 * sz.k; at: 34 * sz.k + 22; n: "10" }
            DocDim { from: 10 * sz.k; to: 26 * sz.k; at: 34 * sz.k + 22; n: "16" }
            DocDim { from: 26 * sz.k; to: 34 * sz.k; at: 34 * sz.k + 22; n: "8" }
        }
    }

    component Panel: Item {
        default property alias content: col.data
        width: 340; height: col.height + 32
        DocKPanel { anchors.fill: parent }
        Column { id: col; x: 16; y: 16; width: parent.width - 32 }
    }
    F { n: "do-three"; DocCentre { Panel { Choices { model: app.lid; current: 0; label: "When the lid is closed" } } } }
    F { n: "dont-two"; DocCentre { Panel { Choices { model: ["On", "Off"]; current: 0; label: "Night light" } } } }
    F { n: "do-short"; DocCentre { Panel { Choices { model: [{ label: "Suspend", detail: "Keeps your work in memory" }, "Hibernate", "Do nothing"]; current: 0; label: "Lid" } } } }
    F { n: "dont-sentences"; DocCentre { Panel { Choices { model: ["Suspend and keep my work", "Hibernate and save my work", "Do nothing at all"]; current: 0; label: "Lid" } } } }
}
