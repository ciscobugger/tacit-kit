// Focus ring page's figures: a list in a window with the ring on a row (hero), anatomy, the same ring on five parts,
// states (hidden, shown, a field), sizes, two judged examples.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["parts", 760, 200], ["states", 760, 200], ["sizes", 760, 400], ["do-ring", 418, 160], ["dont-own-outline", 418, 160],
              ["do-room", 418, 160], ["dont-clipped", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Home"]; here: "Downloads" }
        Column {
            x: 12; y: 80; width: hw.shown - 36
            SectionHeading { text: "Today" }
            ListRow { width: parent.width; focusable: false; picture: app.pics + "p11.jpg"; name: "ov02c10-capture.png"; facts: ["640 kB", "11:20"] }
            ListRow { width: parent.width; focusable: false; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; aside: "docs.google.com"; facts: ["2.2 MB", "14:40"]; previewState: "focus" }
            ListRow { width: parent.width; focusable: false; glyph: "description"; name: "Notes.txt"; facts: ["3 kB", "09:12"] }
        }
    }

    F { n: "anatomy"
        // a Slab at 2.4 times with the ring on; the ring's top edge and the gap above the Slab are the two surfaces
        Item {
            id: an
            readonly property real k: 2.4
            x: (parent.width - sl.implicitWidth * k) / 2; y: 107; width: sl.implicitWidth * k; height: sl.implicitHeight * k
            Slab { id: sl; text: "Open"; tone: ""; previewState: "focus"; transformOrigin: Item.TopLeft; scale: an.k }
            readonly property real w: width
            readonly property real py: (sl.implicitHeight - sl.quietHeight) / 2 * k   // the quiet pill is shorter than the Slab's item
            readonly property real h: sl.quietHeight * k
            DocCallout { n: 1; side: "top"; line: -50; surface: true; inset: an.k; along: an.w * 0.3
                         rect: Qt.rect(0, an.py - 4 * an.k, an.w, 2 * an.k) }
            DocCallout { n: 2; side: "top"; line: -50; surface: true; inset: an.k; along: an.w * 0.7
                         rect: Qt.rect(0, an.py - 2 * an.k, an.w, 2 * an.k) }
            DocCallout { n: 3; side: "bottom"; line: an.py + an.h + 44; pad: 4
                         rect: Qt.rect(0, an.py, an.w, an.h) }
        }
    }

    // the ring on the kinds of part that take a key, one at a time as the keyboard has one
    F { n: "parts"
        Repeater {
            model: 5
            DocCol {
                id: col
                required property int index
                slot: index; count: 5
                marker: true
                Loader {
                    anchors.centerIn: parent
                    sourceComponent: [btn, slab, sw, tabs, row][col.index]
                }
            }
        }
    }
    Component { id: btn; IconButton { symbol: "star"; label: "Star"; previewState: "focus" } }
    Component { id: slab; Slab { text: "Open"; tone: ""; previewState: "focus" } }
    Component { id: sw; Switch { label: "Night light"; checked: true; previewState: "focus" } }
    Component { id: tabs; Tabs { labels: ["List", "Grid"]; current: 0; previewState: "focus" } }
    Component { id: row; ListRow { width: 118; glyph: "description"; name: "Name"; facts: []; selected: true; previewState: "focus"; focusable: false } }

    F { n: "states"
        Repeater {
            model: [0, 1, 2, 3]
            DocCol {
                id: col
                required property int index
                slot: index; count: 4
                Slab { visible: col.index < 2; anchors.centerIn: parent; text: "Open"; tone: ""; previewState: col.index === 1 ? "focus" : "" }
                Field { visible: col.index >= 2; anchors.centerIn: parent; width: parent.width - 16; label: "Name"; text: col.index === 2 ? "Holiday" : "Holi/day"
                        error: col.index === 3; previewState: col.index === 2 ? "focus" : "" }
            }
        }
    }

    F { n: "sizes"
        Item {
            // an icon button at 5 times, ring on; the ring's two 2 px steps above it and the whole width beside it
            readonly property real k: 5
            x: (parent.width - 180) / 2; y: 136
            IconButton { id: ib; symbol: "star"; label: "Star"; previewState: "focus"; transformOrigin: Item.TopLeft; scale: parent.k }
            DocDim { from: -4 * parent.k; to: 0; at: -4 * parent.k - 28; flip: true; n: "4" }
            DocDim { vertical: true; from: 0; to: 36 * parent.k; at: -4 * parent.k - 36; n: "36" }
            DocDim { vertical: true; from: -4 * parent.k; to: 40 * parent.k; at: 36 * parent.k + 4 * parent.k + 36; flip: true; n: "44" }
        }
    }

    component Tile: Item {
        id: t
        property bool ring: true
        width: 120; height: 40
        Slab { anchors.centerIn: parent; text: "Open"; tone: ""; previewState: t.ring ? "focus" : "" }
    }
    F { n: "do-ring"
        DocCentre { Tile { } }
    }
    F { n: "dont-own-outline"
        DocCentre {
            Item { width: 120; height: 40
                Slab { id: own; anchors.centerIn: parent; text: "Open"; tone: "" }
                Rectangle { anchors.fill: own; anchors.margins: -4; radius: height / 2; color: "transparent"; border.width: 1; border.color: Kit.tokens.inkMain }
            }
        }
    }
    F { n: "do-room"
        DocCentre {
            Item { width: 340; height: 56; clip: true
                Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: Qt.alpha(Kit.tokens.inkMain, 0.2) }
                ListRow { x: 6; y: 6; width: 328; focusable: false; glyph: "description"; name: "Notes.txt"; facts: ["3 kB"]; selected: true; previewState: "focus" } }
        }
    }
    F { n: "dont-clipped"
        DocCentre {
            Item { width: 340; height: 44; clip: true
                Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: Qt.alpha(Kit.tokens.inkMain, 0.2); z: 1 }
                // room at the sides, none above and below: the ring shows at the ends and is cut along the top and bottom
                ListRow { x: 6; width: 328; focusable: false; glyph: "description"; name: "Notes.txt"; facts: ["3 kB"]; selected: true; previewState: "focus" } }
        }
    }
}
