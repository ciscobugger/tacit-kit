// Tabs: the part in use, anatomy, states, sizes, and one do and one don't. Rendered by docs/render.sh.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 200], ["states", 760, 200], ["sizes", 760, 200], ["do-words", 418, 160], ["dont-many", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    DocWindow {
        visible: app.fig === "hero"
        anchors.fill: parent
        wx: 64; wy: 40; wallX: -400; wallY: -600
        PageHeader { width: 704; canGoBack: true; crumbs: ["Home", "Pictures"]; here: "Orbits" }
        Tabs { x: 16; y: 88; labels: ["Preview", "Details", "History"]; current: 1 }
        Rectangle { x: 16; y: 120; width: 660; height: 1; color: Kit.tokens.hairline }
        Column {
            x: 12; y: 128; width: 660
            ListRow { width: parent.width; glyph: "image"; name: "Kind"; facts: ["PNG picture"]; factWidths: [200] }
            ListRow { width: parent.width; glyph: "drive"; name: "Size"; facts: ["640 kB"]; factWidths: [200] }
            ListRow { width: parent.width; glyph: "clock"; name: "Changed"; facts: ["Today, 11:20"]; factWidths: [200] }
        }
    }

    F { n: "anatomy"
        // the words as the tabs set them: the chosen one strong, the others regular, 12 px of room each side
        TacitText { id: mStrong; visible: false; text: "Name"; weight: "strong" }
        TacitText { id: mWord; visible: false; text: "Name" }
        Item {
            id: anat
            readonly property real k: 2
            readonly property real room: Kit.tokens.space.m
            readonly property real w0: mStrong.implicitWidth + 2 * room     // the chosen tab
            readonly property real w1: mWord.implicitWidth + 2 * room       // each other tab
            readonly property real ty: (32 - mWord.implicitHeight) / 2
            readonly property real topLine: -22
            readonly property real botLine: 32 * k + 22
            width: (w0 + 2 * w1) * k; height: 32 * k
            x: (760 - width) / 2; y: 100 - height / 2
            Tabs { labels: ["Name", "Name", "Name"]; current: 0; scale: anat.k; transformOrigin: Item.TopLeft }
            DocCallout { n: 1; side: "top"; line: anat.topLine
                         rect: Qt.rect(anat.room * anat.k, anat.ty * anat.k, mStrong.implicitWidth * anat.k, mWord.implicitHeight * anat.k) }
            // the line is 2 px, 1 above the tab's bottom: the dot sits on its middle
            DocCallout { n: 2; side: "bottom"; line: anat.botLine; surface: true; inset: anat.k
                         rect: Qt.rect(anat.room * anat.k, 29 * anat.k, mStrong.implicitWidth * anat.k, 2 * anat.k) }
            DocCallout { n: 3; side: "top"; line: anat.topLine
                         rect: Qt.rect((anat.w0 + anat.room) * anat.k, anat.ty * anat.k, mWord.implicitWidth * anat.k, mWord.implicitHeight * anat.k) }
            DocCallout { n: 3; side: "top"; line: anat.topLine
                         rect: Qt.rect((anat.w0 + anat.w1 + anat.room) * anat.k, anat.ty * anat.k, mWord.implicitWidth * anat.k, mWord.implicitHeight * anat.k) }
        }
    }

    F { n: "states"
        Item {
            anchors.fill: parent
            Repeater {
                model: [{ cur: 0 }, { cur: 0, hover: 1 }, { cur: 0, st: "focus" }, { cur: 1 }]
                DocCol {
                    id: col
                    required property var modelData
                    required property int index
                    slot: index; count: 4; marker: false
                    Column {
                        anchors.centerIn: parent; spacing: 24
                        DocMarker { anchors.horizontalCenter: parent.horizontalCenter; n: col.index + 1 }
                        Tabs {
                            labels: ["Name", "Name"]; current: col.modelData.cur
                            previewHover: col.modelData.hover ?? -1; previewState: col.modelData.st ?? ""
                        }
                    }
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            id: m
            readonly property real k: 2.5
            // the tabs, 49 px of dimension line to their left and 39 below, centred as a whole (two tabs, 132 wide at this scale)
            x: (parent.width - tb.width * k + 49) / 2 + 17; y: (parent.height - 32 * k - 39) / 2
            Tabs { id: tb; labels: ["Name", "Name"]; current: 0; scale: m.k; transformOrigin: Item.TopLeft }
            DocDim { from: 0; to: 12 * m.k; at: 32 * m.k + 16; n: "12" }
            DocDim { from: 12 * m.k; to: 54 * m.k; at: 32 * m.k + 16; n: "word" }
            DocDim { from: 54 * m.k; to: 66 * m.k; at: 32 * m.k + 16; n: "12" }
            DocDim { vertical: true; from: 0; to: 32 * m.k; at: -24; n: "32" }
        }
    }

    F { n: "do-words"
        DocCentre { cw: 370
            Tabs { y: 70; labels: ["Songs", "Albums", "Artists"]; current: 0 }
            Column { y: 112; width: parent.width
                ListRow { width: parent.width; glyph: "music_note"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
            }
        }
    }
    F { n: "dont-many"
        DocCentre {
            Tabs { x: 12; y: 70; labels: ["Songs", "Albums", "Artists", "Genres", "Years"]; current: 0 }
        }
    }
}
