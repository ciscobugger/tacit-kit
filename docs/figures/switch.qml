// Switch page figures: settings rows in a window, the pieces, the states, the measures and two guidelines.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 200], ["sizes", 760, 200], ["do-real-setting", 418, 160], ["dont-action", 418, 160], ["do-setting-name", 418, 160], ["dont-verb-name", 418, 160]]
    readonly property var t: Kit.tokens
    component F: Item {
        property string n
        visible: app.fig === n
        anchors.fill: parent
        DocGlass { anchors.fill: parent }
    }
    // a settings row: the setting's name and its switch at the end
    component SettingRow: Item {
        id: sr
        property string name
        property alias checked: sw.checked
        property alias previewState: sw.previewState
        property real fade: 1
        height: 44
        opacity: fade
        TacitText { x: 16; anchors.verticalCenter: parent.verticalCenter; text: sr.name }
        Switch { id: sw; anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; label: sr.name }
    }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Settings"]; here: "Notifications" }
        Column {
            x: 12; y: 80; width: hw.shown - 36
            SectionHeading { text: "While you work" }
            SettingRow { width: parent.width; name: "Do not disturb" }
            SettingRow { width: parent.width; name: "Show previews in notifications"; checked: true; previewState: "hover" }
            SettingRow { width: parent.width; name: "Sound for new messages"; checked: true }
        }
    }

    F { n: "anatomy"
        // two rows at 1.6 times, the switch on above and off below; rings on a line above and a line below
        Item {
            id: an
            readonly property real k: 1.6
            x: 188; y: 82; width: 240 * k; height: 88 * k
            SettingRow { width: 240; name: "Night light"; checked: true; transformOrigin: Item.TopLeft; scale: an.k }
            SettingRow { y: 44 * an.k; width: 240; name: "Show previews"; checked: false; transformOrigin: Item.TopLeft; scale: an.k }
            // the switch is 40 by 24, 16 from the row's right edge and centred in 44; its knob is 18, 3 from the track's edge
            readonly property real sx: (240 - 16 - 40) * k
            readonly property real topLine: -20
            readonly property real botLine: 88 * k + 16
            DocCallout { n: 1; side: "top"; line: an.topLine; surface: true; along: an.sx + 8 * an.k
                         rect: Qt.rect(an.sx, 10 * an.k, 40 * an.k, 24 * an.k) }
            DocCallout { n: 2; side: "top"; line: an.topLine; along: an.sx + 33 * an.k
                         rect: Qt.rect(an.sx + 19 * an.k, 13 * an.k, 18 * an.k, 18 * an.k) }
            DocCallout { n: 3; side: "bottom"; line: an.botLine
                         rect: Qt.rect(an.sx, (44 + 10) * an.k, 40 * an.k, 24 * an.k) }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ c: false, s: "", e: true }, { c: false, s: "hover", e: true }, { c: true, s: "", e: true }, { c: true, s: "hover", e: true },
                    { c: true, s: "focus", e: true }, { c: true, s: "", e: false }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 6; marker: false
                DocMarker { n: col.index + 1; x: (parent.width - 22) / 2; y: (parent.height - 22 - 24 - 24 * 1.6) / 2 }
                Switch {
                    x: (parent.width - 40 * 1.6) / 2; y: (parent.height - 22 - 24 - 24 * 1.6) / 2 + 22 + 24; scale: 1.6; transformOrigin: Item.TopLeft
                    label: "Night light"; checked: col.modelData.c; previewState: col.modelData.s; enabled: col.modelData.e
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            // the switch at 4 times; 63 px of dimension line to its left, 63 to its right, 43 below
            x: (parent.width - 160) / 2; y: (parent.height - 96 - 43) / 2
            Switch { scale: 4; transformOrigin: Item.TopLeft; label: "Night light"; checked: true }
            DocDim { from: 0; to: 160; at: 96 + 20; n: "40" }
            DocDim { vertical: true; from: 0; to: 96; at: -36; n: "24" }
            DocDim { vertical: true; from: 0; to: 12; at: 160 + 36; flip: true; n: "3" }
            DocDim { vertical: true; from: 12; to: 84; at: 160 + 36; flip: true; n: "18" }
        }
    }

    F { n: "do-real-setting"
        DocCentre {
            Column {
                anchors.centerIn: parent; width: 340
                SettingRow { width: parent.width; name: "Night light"; checked: true }
                SettingRow { width: parent.width; name: "Do not disturb" }
            }
        }
    }
    F { n: "dont-action"
        DocCentre {
            Column {
                anchors.centerIn: parent; width: 340
                SettingRow { width: parent.width; name: "Empty the trash" }
                SettingRow { width: parent.width; name: "Restart now" }
            }
        }
    }
    F { n: "do-setting-name"
        DocCentre {
            Column {
                anchors.centerIn: parent; width: 340
                SettingRow { width: parent.width; name: "Night light"; checked: true }
            }
        }
    }
    F { n: "dont-verb-name"
        DocCentre {
            Column {
                anchors.centerIn: parent; width: 340
                SettingRow { width: parent.width; name: "Disable night light"; checked: true }
            }
        }
    }
}
