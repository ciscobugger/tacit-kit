// Cover grid page's figures: Music's Albums page in a window (hero), anatomy, states (rest, pointer, selected, keyboard),
// sizes (cover 180, gap 24, title 12 below), two judged examples.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 400], ["anatomy", 760, 400], ["states", 760, 400], ["sizes", 760, 400], ["do-words", 418, 300], ["dont-no-words", 418, 300],
              ["do-short", 418, 300], ["dont-long", 418, 300]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens
    function cv(c, title, sub, cur) { return { source: app.mus + c + ".jpg", title: title, subtitle: sub, current: cur === true }; }
    readonly property var albums: [cv("c15", "Bloom", "Petal Club"), cv("c2", "Brass and Rain", "The Northern Room"), cv("c13", "Deep Green", "Okonkwo Trio"),
                                   cv("c1", "Dry Season", "Noor Haddad"), cv("c12", "Dusk Pilot", "Yuki Hara"), cv("c14", "Ember Roads", "Ana Ruiz")]

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Library"]; here: "Albums" }
        CoverGrid {
            x: 24; y: 73 + 24; width: hw.shown - 48; height: parent.height - y
            glyph: "music_note"
            previewHover: 1
            items: [app.cv("c15", "Bloom", "Petal Club", true), app.cv("c2", "Brass and Rain", "The Northern Room"), app.cv("c13", "Deep Green", "Okonkwo Trio"),
                    app.cv("c1", "Dry Season", "Noor Haddad"), app.cv("c12", "Dusk Pilot", "Yuki Hara"), app.cv("c14", "Ember Roads", "Ana Ruiz")]
        }
    }

    F { n: "anatomy"
        // three covers in one row, the first playing and the second selected; the words as the grid sets them
        Item {
            id: an
            readonly property real cell: 204
            readonly property real side: 180
            readonly property real titleY: side + 12
            x: (parent.width - 588) / 2; y: 105; width: 588; height: 240
            CoverGrid {
                width: 588; height: 240
                cursor: 1
                items: [app.cv("c15", "Bloom", "Petal Club", true), app.cv("c2", "Brass and Rain", "The Northern Room"), app.cv("c13", "Deep Green", "Okonkwo Trio")]
            }
            TacitText { id: mTitle2; visible: false; text: "Deep Green"; weight: "medium" }
            TacitText { id: mSub2; visible: false; text: "Okonkwo Trio"; size: "fileText" }
            readonly property real topLine: -30
            DocCallout { n: 1; side: "top"; line: an.topLine; surface: true; along: 90
                         rect: Qt.rect(0, 0, an.side, an.side) }
            DocCallout { n: 2; side: "top"; line: an.topLine; surface: true; along: an.side + 12
                         rect: Qt.rect(an.side, 40, 24, 100) }
            DocCallout { n: 3; side: "top"; line: an.topLine; surface: true; along: an.cell + 90
                         rect: Qt.rect(an.cell, 0, an.side, an.side) }
            DocCallout { n: 4; side: "left"; line: -44
                         rect: Qt.rect(0, an.titleY - 1, 20, 22) }
            DocCallout { n: 5; side: "right"; line: 588 + 44
                         rect: Qt.rect(2 * an.cell, an.titleY, mTitle2.implicitWidth, mTitle2.implicitHeight) }
            DocCallout { n: 6; side: "right"; line: 588 + 44
                         rect: Qt.rect(2 * an.cell, an.titleY + 20 + 4, mSub2.implicitWidth, mSub2.implicitHeight) }
        }
    }

    F { n: "states"
        Repeater {
            model: [{ h: -1, c: -1, k: false }, { h: 0, c: -1, k: false }, { h: -1, c: 0, k: false }, { h: -1, c: 0, k: true }]
            DocCol {
                id: col
                required property var modelData
                required property int index
                slot: index; count: 4
                CoverGrid {
                    y: (parent.height - 212) / 2 + 6; width: parent.width; height: 212
                    previewHover: col.modelData.h
                    cursor: col.modelData.c
                    items: [app.cv("c2", "Brass and Rain", "The Northern Room")]
                    Component.onCompleted: if (col.modelData.k) { Kit.focusVisible = true; forceActiveFocus(); }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            id: m
            // 180 covers 24 apart; 44 px of dimension line above the row, 60 to its left
            x: (parent.width - 384 - 60) / 2 + 60; y: (parent.height - 228 - 44) / 2 + 44
            CoverGrid {
                width: 384; height: 232
                cursor: 0
                items: [app.cv("c2", "Brass and Rain", "The Northern Room"), app.cv("c13", "Deep Green", "Okonkwo Trio")]
            }
            DocDim { from: 0; to: 180; at: -24; n: "180"; flip: true }
            DocDim { from: 180; to: 204; at: -24; n: "24"; flip: true }
            DocDim { vertical: true; from: 0; to: 180; at: -24; n: "180" }
            DocDim { vertical: true; from: 180; to: 192; at: -24; n: "12" }
        }
    }

    F { n: "do-words"
        DocCentre { CoverGrid { width: 180; height: 232; items: [app.cv("c2", "Brass and Rain", "The Northern Room")] } }
    }
    F { n: "dont-no-words"
        DocCentre { CoverGrid { width: 180; height: 232; items: [app.cv("c2", "", "")] } }
    }
    F { n: "do-short"
        DocCentre { CoverGrid { width: 180; height: 232; items: [app.cv("c1", "Dry Season", "Noor Haddad")] } }
    }
    F { n: "dont-long"
        DocCentre { CoverGrid { width: 180; height: 232; items: [app.cv("c1", "Dry Season", "Noor Haddad, 2024, 3 songs, 11 minutes")] } }
    }
}
