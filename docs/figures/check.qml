// Check page figures: a backup form in a window, the pieces, the states, the measures and three guidelines.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 400], ["anatomy", 760, 400], ["states", 760, 200], ["sizes", 760, 200], ["do-form", 418, 300], ["dont-instant", 418, 300],
              ["do-mixed", 418, 220], ["dont-mixed", 418, 220], ["do-name", 418, 160], ["dont-negative", 418, 160]]
    readonly property var t: Kit.tokens
    component F: Item {
        property string n
        visible: app.fig === n
        anchors.fill: parent
        DocGlass { anchors.fill: parent }
    }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Settings"]; here: "Backup" }
        Column {
            x: 12; y: 80; width: hw.shown - 36; spacing: 0
            SectionHeading { text: "What to include" }
            Check { x: 16; label: "Everything below"; mixed: true }
            Check { x: 40; label: "Documents"; checked: true }
            Check { x: 40; label: "Pictures"; checked: true; previewState: "hover" }
            Check { x: 40; label: "Music" }
            Check { x: 40; label: "Downloads" }
            Item { width: 1; height: 8 }
            Slab { x: 16; tone: "default"; text: "Back up now" }
        }
    }

    F { n: "anatomy"
        // three rows at 2 times: ticked, partly ticked, not ticked; rings left for the box, above for the mark, right for the label
        TacitText { id: mName; visible: false; text: "Name" }
        Item {
            id: an
            readonly property real k: 2
            readonly property real rowH: 32 * k
            readonly property real gap: 24
            readonly property real wLabel: mName.implicitWidth
            x: 306; y: 106; width: (32 + wLabel) * k; height: 3 * rowH + 2 * gap
            Check { y: 0; scale: an.k; transformOrigin: Item.TopLeft; label: "Name"; checked: true }
            Check { y: an.rowH + an.gap; scale: an.k; transformOrigin: Item.TopLeft; label: "Name"; mixed: true }
            Check { y: 2 * (an.rowH + an.gap); scale: an.k; transformOrigin: Item.TopLeft; label: "Name" }
            // the box is 20 at 6 from the top of its 32; the mark 16 inside it; the dash 10 by 2 in its middle
            DocCallout { n: 1; side: "left"; line: -52; surface: true; rect: Qt.rect(0, 6 * an.k, 20 * an.k, 20 * an.k) }
            DocCallout { n: 2; side: "top"; line: -36; rect: Qt.rect(2 * an.k, 8 * an.k, 16 * an.k, 16 * an.k) }
            DocCallout { n: 3; side: "right"; line: an.width + 52
                         rect: Qt.rect(32 * an.k, (an.rowH - mName.implicitHeight * an.k) / 2, an.wLabel * an.k, mName.implicitHeight * an.k) }
            DocCallout { n: 4; side: "left"; line: -52
                         rect: Qt.rect(5 * an.k, an.rowH + an.gap + 15 * an.k - 1 * an.k, 10 * an.k, 2 * an.k) }
            DocCallout { n: 5; side: "left"; line: -52; surface: true
                         rect: Qt.rect(0, 2 * (an.rowH + an.gap) + 6 * an.k, 20 * an.k, 20 * an.k) }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ c: false, m: false, s: "", e: true }, { c: false, m: false, s: "hover", e: true }, { c: true, m: false, s: "", e: true },
                    { c: false, m: true, s: "", e: true }, { c: true, m: false, s: "focus", e: true }, { c: true, m: false, s: "", e: false }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 6
                Check {
                    id: ck
                    x: (parent.width - ck.width * 1.3) / 2; y: (parent.height - 32 * 1.3) / 2; scale: 1.3; transformOrigin: Item.TopLeft
                    label: "Name"; checked: col.modelData.c; mixed: col.modelData.m; previewState: col.modelData.s; enabled: col.modelData.e
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            // a check at 3 times: 96 high, the box 60 at 18, the gap 36
            id: sz
            x: (parent.width - 280) / 2 + 64; y: (parent.height - 96 - 43) / 2
            Check { scale: 3; transformOrigin: Item.TopLeft; label: "Name"; checked: true }
            DocDim { from: 0; to: 60; at: 96 + 20; n: "20" }
            DocDim { from: 60; to: 96; at: 96 + 20; n: "12" }
            DocDim { vertical: true; from: 0; to: 96; at: -40; n: "32" }
        }
    }

    component Panel: Item {
        default property alias content: col.data
        property alias spacing: col.spacing
        width: 340; height: col.height + 32
        DocKPanel { anchors.fill: parent }
        Column { id: col; x: 16; y: 16; width: parent.width - 32 }
    }

    F { n: "do-form"
        DocCentre {
            Panel { spacing: 4
                Check { label: "Documents"; checked: true }
                Check { label: "Pictures"; checked: true }
                Check { label: "Music" }
                Item { width: 1; height: 8 }
                Slab { tone: "default"; text: "Back up" }
            }
        }
    }
    F { n: "dont-instant"
        DocCentre {
            Panel { spacing: 4
                Check { label: "Night light"; checked: true }
                Check { label: "Do not disturb" }
                Check { label: "Sound for new messages"; checked: true }
            }
        }
    }
    F { n: "do-mixed"
        DocCentre {
            Panel { spacing: 4
                Check { label: "Everything below"; mixed: true }
                Check { x: 24; label: "Documents"; checked: true }
                Check { x: 24; label: "Music" }
            }
        }
    }
    F { n: "dont-mixed"
        DocCentre {
            Panel { spacing: 4
                Check { label: "Everything below"; checked: true }
                Check { x: 24; label: "Documents"; checked: true }
                Check { x: 24; label: "Music" }
            }
        }
    }
    F { n: "do-name"
        DocCentre {
            Panel { Check { label: "Show hidden files"; checked: true } }
        }
    }
    F { n: "dont-negative"
        DocCentre {
            Panel { Check { label: "Do not hide hidden files"; checked: true } }
        }
    }
}
