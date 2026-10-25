// Window ground page's figures: a Files window on the wallpaper (hero), the ground and its corner called out, the ground at three
// see-through settings, the corner measured, one guideline.
import QtQuick
import Quickshell
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 300], ["sizes", 760, 300], ["do-ground", 418, 220], ["dont-own-fill", 418, 220]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property string wallFile: "file://" + Quickshell.env("FIGURE_ASSETS") + "/wall-" + app.wall + ".jpg"

    // a window on the unblurred wallpaper, its ground drawn by WindowGround; the content is neutral
    component Win: Item {
        id: w
        property real see: -1             // a see-through setting to draw instead of the user's, for the states
        property real wx: 0
        property real wy: 0
        property real winW: 400
        property real winH: 200
        property bool real: false           // the opening figure's real rows; the spec figures keep neutral ones
        clip: true
        Image { x: -400 + 0; y: -620; width: 1600; height: 1000; source: app.wallFile }
        Item {
            x: w.wx; y: w.wy; width: w.winW; height: w.winH
            WindowGround { visible: w.see < 0 }
            Rectangle { visible: w.see >= 0; anchors.fill: parent; radius: Kit.tokens.radius.window; color: Qt.alpha(Kit.tokens.windowGround, 1 - w.see) }
            PageHeader { width: parent.width; crumbs: ["Home"]; here: "Pictures" }
            Column { x: 12; y: 78; width: parent.width - 24
                Repeater { model: [["dune-light.jpg", "3.4 MB"], ["orbit-red.jpg", "2.9 MB"], ["Holiday 2024 014.jpg", "5.1 MB"]]
                    ListRow { required property var modelData; width: parent.width; focusable: false; glyph: "image"
                              name: w.real ? modelData[0] : "Name"; facts: w.real ? [] : ["Fact"]; factWidths: [64] } } }
        }
    }

    Win { visible: app.fig === "hero"; anchors.fill: parent; wx: 72; wy: 44; winW: 760; winH: 400; real: true }

    Item { visible: app.fig === "anatomy"; anchors.fill: parent
        Win { anchors.fill: parent; wx: 110; wy: 60; winW: 700; winH: 400 }
        DocCallout { n: 1; side: "top"; line: 26; surface: true; along: 620; inset: 24; rect: Qt.rect(110, 60, 700, 240) }
        DocCallout { n: 2; side: "top"; line: 26; surface: true; along: 50; inset: 24; rect: Qt.rect(0, 60, 100, 240) }
        DocCallout { n: 3; side: "top"; line: 26; along: 122; rect: Qt.rect(110, 60, 18, 18) }
    }

    Item { visible: app.fig === "states"; anchors.fill: parent
        Repeater {
            model: [0, 0.15, 0.4]
            Item {
                id: col
                required property real modelData
                required property int index
                x: index * 760 / 3; width: 760 / 3; height: 300; clip: true
                Win { anchors.fill: parent; see: col.modelData; wx: 24; wy: 60; winW: 400; winH: 500 }
                DocMarker { x: 24; y: 18; n: col.index + 1 }
            }
        }
    }

    F { n: "sizes"
        Item {
            id: sz
            clip: false
            readonly property real k: 5
            x: 250; y: 100; width: parent.width - x; height: parent.height - y
            Rectangle { width: 760; height: 400; radius: 18 * sz.k; color: Qt.alpha(Kit.tokens.inkMain, 0.06); border.width: 1; border.color: Qt.alpha(Kit.tokens.inkMain, 0.4) }
            DocDim { from: 0; to: 18 * sz.k; at: -26; flip: true; n: "18" }
            DocDim { vertical: true; from: 0; to: 18 * sz.k; at: -26; n: "18" }
        }
    }

    F { n: "do-ground"
        Win { anchors.fill: parent; wx: 40; wy: 30; winW: 500; winH: 300 } }
    F { n: "dont-own-fill"
        Win { anchors.fill: parent; wx: 40; wy: 30; winW: 500; winH: 300; see: 0 } }
}
