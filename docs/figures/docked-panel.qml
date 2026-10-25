// Docked panel page figures: a Files window with the panel for the selection, its pieces, its arriving, its measures and two guidelines.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 400], ["anatomy", 760, 400], ["states", 760, 400], ["sizes", 760, 400],
              ["do-docked", 418, 220], ["dont-floating", 418, 220], ["do-lifted", 418, 220], ["dont-solid", 418, 220]]
    readonly property var t: Kit.tokens
    component F: Item {
        property string n
        visible: app.fig === n
        anchors.fill: parent
        DocGlass { anchors.fill: parent }
    }
    component Names: Column {
        ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: [] }
        ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: []; selected: true }
        ListRow { width: parent.width; glyph: "description"; name: "Name"; facts: [] }
    }
    component Content: Column {
        property bool short: false
        x: 24; y: 22; width: 352; spacing: 2
        TacitText { text: "Lease agreement.pdf"; size: "body"; weight: "medium" }
        TacitText { text: "PDF document, 2.2 MB"; ink: "sec" }
        Item { width: 1; height: 12 }
        Slab { tone: "default"; text: "Open" }
        Item { width: 1; height: 6 }
        WordAction { width: 352; text: "Share" }
        WordAction { width: 352; text: "Rename" }
        WordAction { visible: !parent.short; width: 352; text: "Move to the trash"; risk: true }
    }

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        wx: 24; wy: 24
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Files"]; here: "Downloads" }
        Column {
            x: 12; y: 76; width: hw.shown - 400 - 24
            SectionHeading { text: "Today" }
            ListRow { width: parent.width; glyph: "music_note"; name: "Undertow - Mara Velde.mp3"; facts: ["18:02"]; factWidths: [56] }
            ListRow { width: parent.width; glyph: "deployed_code"; name: "tacit-1.1.7-x86_64.iso"; facts: ["16:15"]; factWidths: [56] }
            ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; facts: ["14:40"]; factWidths: [56]; selected: true }
            ListRow { width: parent.width; picture: app.pics + "p11.jpg"; name: "ov02c10-capture.png"; facts: ["11:20"]; factWidths: [56] }
        }
        DockedPanel {
            x: hw.shown - 400; y: 73; height: 300; open: true
            Content { }
        }
    }

    // the window top-left region with its header, list and the panel hung from the header's line; shared by the whole
    // views and the magnified crops, so a crop is the real thing at 5 times
    readonly property real px: 150            // the panel's left edge; its right edge, the window's, is 400 further
    readonly property real winTop: 62
    readonly property real hl: winTop + 73    // the header's line, where the panel hangs
    component Scene: Item {
        id: sceneRoot
        property alias cnt: cnt
        property real winTop: app.winTop
        property real hl: winTop + 73
        property real ph: 270
        property bool short: false
        Rectangle {
            x: 0; y: winTop; width: app.px + 400; height: 400; radius: 18
            color: Qt.alpha(app.t.inkMain, 0.03); border.width: 1; border.color: Qt.rgba(1, 1, 1, 0.08)
        }
        PageHeader { y: winTop; width: app.px + 400; crumbs: []; here: "Files" }
        Names { x: 12; y: hl + 17; width: 128 }
        DockedPanel { x: app.px; y: hl; height: ph; open: true; Content { id: cnt; short: sceneRoot.short } }
    }
    // a crop of the scene at 5 times: `cx`, `cy` is its top-left in scene units, `side` its width and height in scene units
    component Lens: Item {
        id: lens
        property real cx
        property real cy
        property real winTop: app.winTop
        property real ph: 270
        property bool short: false
        property real side: 20
        width: side * 5; height: side * 5
        Item {
            anchors.fill: parent; clip: true
            Rectangle { anchors.fill: parent; color: Qt.alpha(app.t.inkMain, 0.02) }
            Item { x: -lens.cx * 5; y: -lens.cy * 5; scale: 5; transformOrigin: Item.TopLeft; Scene { winTop: lens.winTop; ph: lens.ph; short: lens.short } }
        }
        Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: Qt.alpha(app.t.inkMain, 0.20); radius: 10 }
    }

    F { n: "anatomy"; id: an
        readonly property real ringY: 37
        Item { x: 26; width: parent.width; height: parent.height; clip: true
        Scene { id: sc }
        // the cove, enlarged on the right: where the panel meets the header's line, the page's lift against the window
        Lens { id: lensCove; x: 608; y: 150; side: 20; cx: app.px - 12; cy: app.hl - 6 }
        DocCallout { n: 1; side: "bottom"; line: lensCove.y + lensCove.height + 30
                     rect: Qt.rect(lensCove.x + 2 * 5, lensCove.y + 6 * 5, 50, 50) }
        DocCallout { n: 3; side: "top"; line: an.ringY; along: app.px + 200; rect: Qt.rect(app.px + 24, app.hl + 22, 352, sc.cnt.implicitHeight) }
        DocCallout { n: 2; side: "left"; line: app.px - 34; surface: true; along: app.hl + 200; rect: Qt.rect(app.px, app.hl, 400, 270) }
        DocCallout { n: 4; side: "right"; line: app.px + 400 + 26; surface: true; along: app.hl + 135; rect: Qt.rect(app.px + 392, app.hl + 100, 8, 70) }
        }
    }

    // the panel's arrival in three bands: the header's line stands for the line the panel hangs from, and each band
    // holds the whole panel at that moment (nothing is cut by the band, only by the panel's own growing edge)
    F { n: "states"
        Repeater {
            model: [{ shown: 0, content: 0 }, { shown: 0.6, content: 0.5 }, { shown: 1, content: 1 }]
            Item {
                id: band
                required property var modelData
                required property int index
                x: 44; y: 23 + index * 118; width: 716; height: 118; clip: true
                Rectangle { visible: band.index > 0; x: -44; y: 0; width: 760; height: 1; color: Qt.alpha(app.t.inkMain, 0.10) }
                PageHeader { y: -14; width: 716; crumbs: ["Files"]; here: "Downloads" }
                ListRow { x: 12; y: 68; width: 716 - 400 - 24; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; facts: ["14:40"]; factWidths: [56]; selected: true }
                DockedPanel {
                    id: pn
                    x: 716 - width; y: 59; height: 56; open: false
                    shown: band.modelData.shown; contentShown: band.modelData.content
                    Column {
                        x: 24; y: 8; width: 352; spacing: 2
                        TacitText { text: "Lease agreement.pdf"; size: "body"; weight: "medium" }
                        TacitText { text: "PDF document, 2.2 MB"; ink: "sec" }
                    }
                }
            }
        }
        Repeater {
            model: 3
            DocMarker { required property int index; x: 11; y: 23 + index * 118 + 30; n: index + 1 }
        }
    }

    F { n: "sizes"
        // the panel hung from the header, its width below the panel; its cove and its free corner enlarged on the right
        Item { x: 26; width: parent.width; height: parent.height; clip: true
            Scene { winTop: 32; ph: 225; short: true }
            DocDim { from: app.px; to: app.px + 400; at: 32 + 73 + 225 + 16; n: "400" }
            Lens { id: lc; x: 608; y: 32; winTop: 32; ph: 225; short: true; side: 20; cx: app.px - 12; cy: 32 + 73 - 6 }
            DocDim { from: lc.x + 2 * 5; to: lc.x + 12 * 5; at: lc.y + lc.height + 16; n: "10" }
            Lens { id: lf; x: 608; y: 210; winTop: 32; ph: 225; short: true; side: 20; cx: app.px - 4; cy: 32 + 73 + 225 - 14 }
            DocDim { from: lf.x + 4 * 5; to: lf.x + 18 * 5; at: lf.y + lf.height + 16; n: "14" }
        }
    }

    F { n: "do-docked"
        Item { y: 4; width: parent.width; height: parent.height
        Rectangle { x: 0; y: 30; width: 418; height: 1; color: app.t.hairline }
        Names { x: 12; y: 50; width: 170 }
        DockedPanel { x: 418 - 230; y: 31; height: 140; open: true; openWidth: 230
            TacitText { x: 20; y: 18; text: "Lease agreement.pdf"; weight: "medium" }
            WordAction { x: 20; y: 52; width: 190; text: "Rename" }
        }
        }
    }
    F { n: "dont-floating"
        Item { y: 4; width: parent.width; height: parent.height
        Rectangle { x: 0; y: 30; width: 418; height: 1; color: app.t.hairline }
        Names { x: 12; y: 50; width: 170 }
        // drawn by hand: a card with four round corners, not docked into anything
        Rectangle { x: 202; y: 50; width: 190; height: 126; radius: 14; color: Qt.alpha(app.t.inkMain, app.t.wash.action); border.width: 1; border.color: Qt.alpha(app.t.inkMain, 0.14)
            TacitText { x: 16; y: 14; text: "Lease agreement.pdf"; weight: "medium" }
            WordAction { x: 16; y: 48; width: 158; text: "Rename" }
        }
        }
    }
    F { n: "do-lifted"
        Item { y: 4; width: parent.width; height: parent.height
        Rectangle { x: 0; y: 30; width: 418; height: 1; color: app.t.hairline }
        Names { x: 12; y: 50; width: 170 }
        DockedPanel { x: 418 - 230; y: 31; height: 140; open: true; openWidth: 230
            TacitText { x: 20; y: 18; text: "Lease agreement.pdf"; weight: "medium" }
        }
        }
    }
    F { n: "dont-solid"
        Item { y: 4; width: parent.width; height: parent.height
        Rectangle { x: 0; y: 30; width: 418; height: 1; color: app.t.hairline }
        Names { x: 12; y: 50; width: 170 }
        // the same silhouette in the solid container colour: a flat patch over the page
        Docked { x: 418 - 230; y: 31; width: 230; height: 140; edge: "top-right"; cornerRadius: 14; fillet: 10; color: app.t.container
            TacitText { x: 20; y: 18; text: "Lease agreement.pdf"; weight: "medium" }
        }
        }
    }
}
