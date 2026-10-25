// Select page figures: a region form in a window, the pieces, the states, the open menu, the measures and two guidelines.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 400], ["anatomy", 760, 400], ["states", 760, 200], ["open", 760, 300], ["sizes", 760, 300], ["do-label", 418, 160], ["dont-nolabel", 418, 160],
              ["do-many", 418, 300], ["dont-many", 418, 300]]
    readonly property var t: Kit.tokens
    component F: Item {
        property string n
        visible: app.fig === n
        anchors.fill: parent
        DocGlass { anchors.fill: parent }
    }
    readonly property var layouts: [{ label: "English (UK)" }, { label: "Somali" }, { label: "Swedish", checked: true }, { label: "Swedish (Dvorak)" }]

    // a settings row: the name at the left, the select at the end
    component FormRow: Item {
        id: fr
        property string name
        property alias sel: s
        height: 52
        TacitText { x: 16; anchors.verticalCenter: parent.verticalCenter; text: fr.name }
        Select { id: s; anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; label: fr.name }
    }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Settings"]; here: "Keyboard" }
        Column {
            x: 12; y: 80; width: hw.shown - 36
            SectionHeading { text: "Typing" }
            FormRow { id: r1; width: parent.width; name: "Layout"; sel.options: app.layouts; sel.current: 2; sel.previewState: "open" }
            FormRow { width: parent.width; name: "Compose key"; sel.options: ["Off", "Right Alt", "Caps Lock"]; sel.current: 0 }
            FormRow { width: parent.width; name: "Repeat delay"; sel.options: ["Short", "Medium", "Long"]; sel.current: 1 }
        }
        MenuSurface { items: app.layouts; cursor: 2; x: hw.shown - 40 - width; y: 80 + 38 + 52 / 2 + 18 + 6 }
    }

    F { n: "anatomy"
        TacitText { id: mV; visible: false; text: "Swedish" }
        TacitText { id: mH; visible: false; text: "Choose" }
        Item {
            id: an
            readonly property real k: 1.6
            readonly property real fx: 0
            x: (parent.width - 220 * k) / 2 + 28; y: 115; width: 220 * k; height: 36 * k + 56 + 36 * k
            Select { id: s1; scale: an.k; transformOrigin: Item.TopLeft; options: app.layouts; current: 2; label: "Layout" }
            Select { y: 36 * an.k + 56; scale: an.k; transformOrigin: Item.TopLeft; options: app.layouts; current: -1; label: "Layout" }
            DocCallout { n: 1; side: "left"; line: -40; surface: true; rect: Qt.rect(0, 0, 220 * an.k, 36 * an.k) }
            DocCallout { n: 2; side: "top"; line: -36; rect: Qt.rect(12 * an.k, (36 - mV.implicitHeight) / 2 * an.k, mV.implicitWidth * an.k, mV.implicitHeight * an.k) }
            DocCallout { n: 3; side: "top"; line: -36; rect: Qt.rect((220 - 8 - 18) * an.k, 9 * an.k, 18 * an.k, 18 * an.k) }
            DocCallout { n: 4; side: "bottom"; line: an.height + 36
                         rect: Qt.rect(12 * an.k, 36 * an.k + 56 + (36 - mH.implicitHeight) / 2 * an.k, mH.implicitWidth * an.k, mH.implicitHeight * an.k) }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ s: "", c: -1 }, { s: "", c: 2 }, { s: "hover", c: 2 }, { s: "focus", c: 2 }, { s: "open", c: 2 }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 5
                Select { width: parent.width; anchors.verticalCenter: parent.verticalCenter; options: app.layouts; current: col.modelData.c; previewState: col.modelData.s; label: "Layout" }
            }
        }
    }

    F { n: "open"
        DocCentre { cw: 330; ch: 36 + 6 + 140
            DocKPanel { x: -40; y: -24; width: 410; height: 36 + 6 + 140 + 48 }
            Select { id: os; x: 110; width: 220; options: app.layouts; current: 2; previewState: "open"; label: "Layout" }
            MenuSurface { items: app.layouts; cursor: 2; keyboard: true; x: os.x + os.width - width; y: 36 + 6 }
        }
    }

    F { n: "sizes"
        Item {
            id: sz
            readonly property real k: 2
            x: (parent.width - 220 * k) / 2 + 28; y: 117
            Select { scale: sz.k; transformOrigin: Item.TopLeft; options: app.layouts; current: 2; label: "Layout" }
            DocDim { from: 0; to: 220 * sz.k; at: -30; flip: true; n: "220" }
            DocDim { vertical: true; from: 0; to: 36 * sz.k; at: -30; n: "36" }
            DocDim { from: 0; to: 12 * sz.k; at: 36 * sz.k + 24; n: "12" }
            DocDim { from: 194 * sz.k; to: 212 * sz.k; at: 36 * sz.k + 24; n: "18" }
            DocDim { from: 212 * sz.k; to: 220 * sz.k; at: 36 * sz.k + 24; n: "8" }
        }
    }

    component Panel: Item {
        default property alias content: col.data
        property alias spacing: col.spacing
        width: 340; height: col.height + 32
        DocKPanel { anchors.fill: parent }
        Column { id: col; x: 16; y: 16; width: parent.width - 32 }
    }
    F { n: "do-label"; DocCentre { Panel { spacing: 8; TacitText { text: "Layout"; ink: "sec" } Select { width: parent.width; options: app.layouts; current: 2; label: "Layout" } } } }
    F { n: "dont-nolabel"; DocCentre { Panel { Select { width: parent.width; options: app.layouts; current: 2; label: "Layout" } } } }
    F { n: "do-many"; DocCentre { Column { spacing: 8; width: 300; TacitText { text: "Time zone"; ink: "sec" } Select { width: parent.width; options: ["Europe/Stockholm"]; current: 0; label: "Time zone" } } } }
    F { n: "dont-many"; DocCentre { Column { spacing: 8; width: 300; TacitText { text: "Time zone"; ink: "sec" }
        Choices { model: ["Europe/London", "Europe/Paris", "Europe/Stockholm", "Africa/Nairobi", "Africa/Mogadishu", "Asia/Dubai", "Asia/Kolkata"]; current: 2; label: "Time zone" } } } }
}
