// Inline link page's figures: an album's header in a window (hero), anatomy, states (rest, pointer, keyboard), sizes,
// two judged examples.
import QtQuick
import QtQuick.Effects
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 200], ["sizes", 760, 300], ["do-name", 418, 160], ["dont-click-here", 418, 160],
              ["do-slab", 418, 160], ["dont-link-action", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens

    // the album's header lines as Music sets them: title, the artist as a link, the facts
    component Lines: Column {
        property string artist: "Mara Velde"
        property string linkState: ""
        property real k: 1
        property string title: "Low Tide"
        property string facts: "2024, 4 songs, 16 minutes"
        TacitText { text: parent.title; size: "headline"; weight: "medium" }
        InlineLink { text: parent.artist; size: "section"; weight: "medium"; previewState: parent.linkState }
        TacitText { text: parent.facts; ink: "meta" }
    }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Library", "Albums"]; here: "Low Tide" }
        Item {
            x: 24; y: 73 + 24
            Image { id: cv; visible: false; width: 148; height: 148; source: app.mus + "c1.jpg"; sourceSize: Qt.size(296, 296); fillMode: Image.PreserveAspectCrop }
            Rectangle { id: cm; visible: false; width: 148; height: 148; radius: 12; layer.enabled: true }
            MultiEffect { width: 148; height: 148; source: cv; maskEnabled: true; maskSource: cm }
            Lines { x: 148 + 32; }
            Row { x: 148 + 32; y: 148 - 40; spacing: 12
                Slab { text: "Play"; tone: "default" }
                Slab { text: "Shuffle" }
            }
        }
    }

    F { n: "anatomy"
        // the header's three lines at 2 times, the link with the ring so the whole of it shows
        Item {
            id: an
            readonly property real k: 2
            x: 225; y: 62; width: 400; height: 150
            Lines { id: ln; transformOrigin: Item.TopLeft; scale: an.k; linkState: "focus" }
            // the link is as wide and high as its words; its ring is 4 px outside them
            readonly property real lx: ln.children[1].x * k
            readonly property real ly: ln.children[1].y * k
            readonly property real lw: ln.children[1].width * k
            readonly property real lh: ln.children[1].height * k
            DocCallout { n: 1; side: "right"; line: an.lw + 70; pad: 4
                         rect: Qt.rect(an.lx, an.ly, an.lw, an.lh) }
            DocCallout { n: 2; side: "left"; line: -44; surface: true; inset: 2 * an.k
                         rect: Qt.rect(an.lx - 4 * an.k, an.ly, 2 * an.k, an.lh) }
        }
    }

    F { n: "states"
        Repeater {
            model: ["", "hover", "focus"]
            DocCol {
                id: col
                required property string modelData
                required property int index
                slot: index; count: 3
                InlineLink { anchors.centerIn: parent; text: "Mara Velde"; size: "section"; weight: "medium"; previewState: col.modelData }
            }
        }
    }

    F { n: "sizes"
        InlineLink { id: sz; visible: false; text: "Mara Velde"; size: "section"; weight: "medium" }
        Item {
            // the link at 4 times, ring on; dimension lines above and to its right
            readonly property real k: 3
            x: (parent.width - sz.width * k) / 2 - 31; y: 136
            InlineLink { transformOrigin: Item.TopLeft; scale: parent.k; text: "Mara Velde"; size: "section"; weight: "medium"; previewState: "focus" }
            DocDim { from: -4 * parent.k; to: 0; at: -4 * parent.k - 28; flip: true; n: "4" }
            DocDim { vertical: true; from: 0; to: sz.height * parent.k; at: sz.width * parent.k + 4 * parent.k + 36; flip: true; n: Math.round(sz.height) + "" }
        }
    }

    F { n: "do-name"
        DocCentre { Lines { } }
    }
    F { n: "dont-click-here"
        DocCentre { Lines { artist: "Click here for the artist" } }
    }
    F { n: "do-slab"
        DocCentre {
            Row { spacing: 12
                Slab { text: "Play"; tone: "default" }
                Slab { text: "Shuffle" }
            }
        }
    }
    F { n: "dont-link-action"
        DocCentre {
            Row { spacing: 24
                InlineLink { text: "Play" }
                InlineLink { text: "Shuffle" }
            }
        }
    }
}
