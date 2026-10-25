// Page header page's figures: the header over a list in a window (hero), anatomy, four states, sizes, two judged examples.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 400], ["sizes", 760, 200],
              ["do-path", 418, 160], ["dont-subtitle", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader {
            width: hw.shown; crumbs: ["Home"]; here: "Downloads"
            SearchField { anchors.verticalCenter: parent.verticalCenter; scope: "Downloads"; fieldWidth: 240 }
        }
        Column {
            x: 12; y: 73; width: hw.shown - 36
            SectionHeading { text: "Today" }
            ListRow { width: parent.width; focusable: false; glyph: "music_note"; name: "Undertow - Mara Velde.mp3"; aside: "bandcamp.com"; facts: ["11.6 MB", "18:02"]; selected: true }
            ListRow { width: parent.width; focusable: false; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; aside: "docs.google.com"; facts: ["2.2 MB", "14:40"] }
            ListRow { width: parent.width; focusable: false; glyph: "deployed_code"; name: "tacit-1.1.7-x86_64.iso"; aside: "download.tacitos.co"; facts: ["2.9 GB", "16:15"] }
        }
    }

    F { n: "anatomy"
        // the path's words, measured as PageHeader sets them: headline, Display cut; the page itself strong
        TacitText { id: mHome; visible: false; text: "Home"; size: "headline"; cut: "display" }
        TacitText { id: mSep; visible: false; text: "›"; size: "headline"; cut: "display" }
        TacitText { id: mHere; visible: false; text: "Downloads"; size: "headline"; cut: "display"; weight: "strong" }
        Item {
            id: an
            // back 16, forward 4 on, a gap of 8 between 4s, then the path with 8 between its words
            readonly property real pathX: 16 + 36 + 4 + 36 + 4 + 8 + 4
            readonly property real hereX: pathX + mHome.implicitWidth + 8 + mSep.implicitWidth + 8
            x: (parent.width - 700) / 2; y: (parent.height - 73) / 2; width: 700; height: 73
            PageHeader { width: 700; crumbs: ["Home"]; here: "Downloads"
                SearchField { id: sf; anchors.verticalCenter: parent.verticalCenter; scope: "Downloads" } }
            DocCallout { n: 1; side: "top"; line: -34; rect: Qt.rect(16, 18, 76, 36) }
            DocCallout { n: 2; side: "top"; line: -34; open: "right"; rect: Qt.rect(an.pathX, 36 - mHome.implicitHeight / 2, mHome.implicitWidth + 8 + mSep.implicitWidth, mHome.implicitHeight) }
            DocCallout { n: 3; side: "top"; line: -34; open: "left"; rect: Qt.rect(an.hereX, 36 - mHere.implicitHeight / 2, mHere.implicitWidth, mHere.implicitHeight) }
            DocCallout { n: 4; side: "top"; line: -34; rect: Qt.rect(700 - 24 - sf.width, 36 - sf.height / 2, sf.width, sf.height) }
            DocCallout { n: 5; side: "bottom"; line: an.height + 34; surface: true; inset: 0.5; along: 380; rect: Qt.rect(16, 72, 684, 1) }
        }
    }

    // states: four headers, one under the other
    F { n: "states"
        Column {
            x: 0; y: 25; width: 760
            Repeater {
                model: [{ n: 1, here: "Downloads", cr: ["Home"] }, { n: 2, here: "Downloads", cr: ["Home"], fwd: true },
                        { n: 3, here: "Home", cr: [], back: false }, { n: 4, here: "TRANSFER", cr: [], loading: true }]
                Item {
                    id: row
                    required property var modelData
                    width: 760; height: 92
                    DocMarker { n: row.modelData.n; x: 14; y: 20 }
                    PageHeader { x: 40; width: 700; crumbs: row.modelData.cr; here: row.modelData.here
                        canGoBack: row.modelData.back ?? true; canGoForward: row.modelData.fwd ?? false; loading: (row.modelData.loading ?? false) && app.fig === "states"
                        SearchField { anchors.verticalCenter: parent.verticalCenter; scope: row.modelData.here } }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            id: m
            readonly property real k: 1.5
            // the header at 1.5 times, 49 px of dimension line to its left and 39 below
            x: (parent.width - 430 * k - 49) / 2 + 49; y: (parent.height - 73 * k - 39) / 2
            Item { scale: m.k; transformOrigin: Item.TopLeft; width: 430; height: 73
                PageHeader { width: 430; crumbs: []; here: "Music"
                    SearchField { anchors.verticalCenter: parent.verticalCenter; scope: "Music" } } }
            DocDim { vertical: true; from: 0; to: 72 * m.k; at: -24; n: "72" }
            DocDim { from: 0; to: 16 * m.k; at: 73 * m.k + 16; n: "16" }
            DocDim { from: (430 - 24) * m.k; to: 430 * m.k; at: 73 * m.k + 16; n: "24" }
        }
    }

    F { n: "do-path"
        PageHeader { x: 0; y: 43; width: 418; crumbs: ["Home"]; here: "Music" }
    
    }
    F { n: "dont-subtitle"
        Item { x: 0; y: 43; width: 418; height: 73
            Item { x: 16; y: 0; width: 300; height: 72
                TacitText { y: 8; text: "Music"; size: "headline"; cut: "display"; weight: "strong" }
                TacitText { y: 46; text: "177 songs, 12 hours"; ink: "meta" }
            }
            Rectangle { x: 16; y: 72; width: parent.width - 16; height: 1; color: app.t.hairline }
        }
    
    }
}
