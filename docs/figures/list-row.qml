// The List row page's figures (docs-composition.md), rendered at twice the size by tools/figures.sh into
// FIGURE_OUT/<name>.png. The opening sits in a window on the wallpaper with real content; spec figures sit on a calm
// stage (the window's glass, a faint dot grid) with neutral content; guideline examples on the same calm stage.
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Tacit.Kit

ApplicationWindow {
    id: app
    visible: true; width: 760; height: 320; color: "black"
    readonly property string mus: "file://" + Quickshell.env("FIGURE_ASSETS") + "/"
    readonly property string pics: "file://" + Quickshell.env("FIGURE_ASSETS") + "/"
    readonly property string wall: Quickshell.env("MOCK_WALL") || "dusk"
    readonly property string out: Quickshell.env("FIGURE_OUT") || "/tmp/fig"

    // name, width, height
    readonly property var figures: [["hero", 760, 330], ["anatomy", 760, 300], ["states", 760, 400], ["sizes", 760, 300], ["editing", 760, 300], ["do-one-signal", 418, 220], ["dont-signals", 418, 220], ["do-name-first", 418, 220], ["dont-name-cut", 418, 220]]
    property int i: 0
    readonly property string fig: figures[Math.min(i, figures.length - 1)][0]

    // the calm stage: the window's glass (the blurred wallpaper under its ground) and a faint dot grid
    component Glass: Item {
        property bool dots: true
        clip: true
        Image { x: -400; y: -660; width: 1600; height: Math.max(1000, parent.height + 660); source: app.mus + "wall-" + app.wall + "-blur.jpg" }
        Rectangle { anchors.fill: parent; color: Kit.tokens.windowGround; opacity: 1 - Kit.tokens.windowSeeThrough }
        Grid {
            visible: parent.dots
            anchors.fill: parent; anchors.margins: 8
            columns: Math.floor(width / 16) + 1; rows: Math.floor(height / 16) + 1
            columnSpacing: 15; rowSpacing: 15
            Repeater { model: parent.columns * parent.rows
                Rectangle { width: 1; height: 1; color: Qt.alpha(Kit.tokens.inkMain, 0.10) } }
        }
    }
    // a numbered marker, sat on the piece it names
    component Marker: DocMarker {}
    // the rows around the one being shown, receded: a row is always seen in its list
    component Neighbour: ListRow { opacity: 0.32; glyph: "description"; name: "Name"; aside: "Beside the name"; facts: ["Fact", "Fact"]; factWidths: [96, 72] }

    Item {
        id: stage
        width: app.figures[app.i][1]; height: app.figures[app.i][2]

        // ---- the opening: a crop of a window on the wallpaper, the part doing its job. The window runs off the
        // figure's right and bottom edges, so only one corner shows: four round corners on the wallpaper read as a
        // floating card (the launcher's shape), not an app
        Item {
            visible: app.fig === "hero"
            anchors.fill: parent
            clip: true
            Image { x: -400; y: -620; width: 1600; height: 1000; source: app.mus + "wall-" + app.wall + ".jpg" }
            Item {
                id: win
                x: 72; y: 44; width: parent.width; height: parent.height
                readonly property real shown: parent.width - x
                layer.enabled: true
                layer.effect: MultiEffect { maskEnabled: true; maskSource: winMask }
                Glass { anchors.fill: parent; dots: false }
                Column {
                    x: 12; y: 6; width: win.shown - 36
                    SectionHeading { text: "Today" }
                    ListRow { width: parent.width; glyph: "music_note"; name: "Undertow - Mara Velde.mp3"; aside: "bandcamp.com"; facts: ["11.6 MB", "18:02"]; selected: true }
                    ListRow { width: parent.width; glyph: "deployed_code"; name: "tacit-1.1.7-x86_64.iso"; aside: "download.tacitos.co"; facts: ["2.9 GB", "16:15"] }
                    ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; aside: "docs.google.com"; facts: ["2.2 MB", "14:40"]; previewState: "hover" }
                    ListRow { width: parent.width; picture: app.pics + "p11.jpg"; name: "ov02c10-capture.png"; facts: ["640 kB", "11:20"] }
                }
            }
            Rectangle { id: winMask; visible: false; layer.enabled: true; width: win.width; height: win.height; radius: 18 }
            Rectangle { x: win.x - 1; y: win.y - 1; width: win.width + 2; height: win.height + 2; radius: 19; color: "transparent"; border.width: 1; border.color: Qt.rgba(1, 1, 1, 0.08) }
        }

        // ---- anatomy: one row, enlarged, between its neighbours; each piece named by a callout outside the row
        Item {
            visible: app.fig === "anatomy"
            anchors.fill: parent
            Glass { anchors.fill: parent }
            // the pieces' sizes, measured as the row sets them
            TacitText { id: mName; visible: false; text: "Name" }
            TacitText { id: mAside; visible: false; text: "Beside the name" }
            TacitText { id: mFact; visible: false; text: "Fact"; cut: "numbers" }
            Item {
                id: anat
                readonly property real k: 1.25
                readonly property real ty: (44 - mName.implicitHeight) / 2
                x: (parent.width - 480 * k) / 2; y: 142; width: 480 * k; height: 44 * k
                Neighbour { y: -44 * anat.k; width: 480; transformOrigin: Item.TopLeft; scale: anat.k; opacity: 0.22 }
                ListRow {
                    width: 480; transformOrigin: Item.TopLeft; scale: anat.k
                    glyph: "description"; name: "Name"; aside: "Beside the name"; facts: ["Fact", "Fact"]; factWidths: [96, 72]
                    selected: true
                }
                Neighbour { y: 44 * anat.k; width: 480; transformOrigin: Item.TopLeft; scale: anat.k; opacity: 0.22 }
                readonly property real ringLine: -44 * k - 26
                DocCallout { n: 1; side: "left"; line: -44; rect: Qt.rect(16 * anat.k, 12 * anat.k, 20 * anat.k, 20 * anat.k) }
                DocCallout { n: 2; side: "top"; line: anat.ringLine; rect: Qt.rect(52 * anat.k, anat.ty * anat.k, mName.implicitWidth * anat.k, mName.implicitHeight * anat.k) }
                DocCallout { n: 3; side: "top"; line: anat.ringLine
                             rect: Qt.rect((52 + mName.implicitWidth + 12) * anat.k, anat.ty * anat.k, mAside.implicitWidth * anat.k, mAside.implicitHeight * anat.k) }
                DocCallout { n: 4; side: "top"; line: anat.ringLine
                             rect: Qt.rect((392 - mFact.implicitWidth) * anat.k, anat.ty * anat.k, (464 - 392 + mFact.implicitWidth) * anat.k, mFact.implicitHeight * anat.k) }
                DocCallout { n: 5; side: "right"; line: anat.width + 44; surface: true; rect: Qt.rect(0, 0, anat.width, anat.height) }
            }
        }

        // ---- states: the same row side by side, one column each
        Item {
            visible: app.fig === "states"
            anchors.fill: parent
            Glass { anchors.fill: parent }
            // two lines of three cells: six columns would leave a row 105 px wide, too narrow for its name
            Repeater {
                model: [{}, { previewState: "hover" }, { previewState: "pressed" }, { selected: true },
                        { selected: true, previewState: "hover" }, { selected: true, previewState: "focus" }]
                Item {
                    id: col
                    required property var modelData
                    required property int index
                    readonly property real colW: (stage.width - 32) / 3
                    x: 16 + (index % 3) * colW; y: Math.floor(index / 3) * stage.height / 2; width: colW; height: stage.height / 2
                    Rectangle { visible: col.index % 3 > 0; width: 1; height: parent.height; color: Qt.alpha(Kit.tokens.inkMain, 0.10) }
                    Rectangle { visible: col.index >= 3; width: parent.width + (col.index === 3 ? 16 : 0) + (col.index === 5 ? 16 : 0); x: col.index === 3 ? -16 : 0; height: 1; color: Qt.alpha(Kit.tokens.inkMain, 0.10) }
                    // 8 px of room each side of the cell: the ring reaches 4 px past the row, so it and the wash show whole
                    Marker { n: col.index + 1; x: 16; anchors.verticalCenter: parent.verticalCenter }
                    Item {
                        x: 56; width: parent.width - 56 - 16; anchors.verticalCenter: parent.verticalCenter; height: 132
                        ListRow { y: 0; width: parent.width; opacity: 0.22; glyph: "description"; name: "Name"; facts: [] }
                        ListRow { y: 88; width: parent.width; opacity: 0.22; glyph: "description"; name: "Name"; facts: [] }
                        ListRow {
                            y: 44
                            width: parent.width; glyph: "description"; name: "Name"; facts: []
                            z: 1
                            selected: col.modelData.selected === true
                            previewState: col.modelData.previewState ?? ""
                        }
                    }
                }
            }
        }

        // ---- sizes: the whole row at 1.5 times, its spaces measured around it
        Item {
            visible: app.fig === "sizes"
            anchors.fill: parent
            Glass { anchors.fill: parent }
            Item {
                id: meas
                readonly property real k: 1.5
                readonly property real w: 420
                x: (parent.width - w * k - 49) / 2 + 49; y: (parent.height - 66 - 16 - 24 - 66 + 0) / 2 + 66; width: w * k; height: 44 * k
                ListRow { y: -44 * meas.k; width: meas.w; transformOrigin: Item.TopLeft; scale: meas.k; opacity: 0.22
                    glyph: "description"; name: "Name"; aside: "Beside the name"; facts: ["Fact"]; factWidths: [64] }
                ListRow {
                    width: meas.w; transformOrigin: Item.TopLeft; scale: meas.k
                    glyph: "description"; name: "Name"; aside: "Beside the name"; facts: ["Fact"]; factWidths: [64]
                    selected: true
                }
                // 16 | 20 | 16 before the name, the 64 fact column; the height on the left
                DocDim { from: 0; to: 16 * meas.k; at: meas.height + 16; n: "16" }
                DocDim { from: 16 * meas.k; to: 36 * meas.k; at: meas.height + 16; n: "20" }
                DocDim { from: 36 * meas.k; to: 52 * meas.k; at: meas.height + 16; n: "16" }
                DocDim { from: (meas.w - 80) * meas.k; to: (meas.w - 16) * meas.k; at: meas.height + 16; n: "64" }
                DocDim { vertical: true; from: 0; to: meas.height; at: -24; n: "44" }
            }
        }

        // ---- editing: the name edited in its row; a rename (the stem chosen) and a new item (all chosen)
        Item {
            visible: app.fig === "editing"
            anchors.fill: parent
            Glass { anchors.fill: parent }
            Repeater {
                model: [{ name: "Name.ext", all: false, fresh: false }, { name: "Untitled folder", all: true, fresh: true }]
                Item {
                    id: ed
                    required property var modelData
                    required property int index
                    y: index * 150; width: stage.width; height: 150
                    Rectangle { visible: ed.index > 0; x: 16; width: parent.width - 32; height: 1; color: Qt.alpha(Kit.tokens.inkMain, 0.10) }
                    Marker { n: ed.index + 1; x: 28; anchors.verticalCenter: parent.verticalCenter }
                    Item {
                        x: 80; width: parent.width - 80 - 24; anchors.verticalCenter: parent.verticalCenter; height: 132
                        ListRow { y: 0; width: parent.width; opacity: 0.22; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
                        ListRow { y: 88; width: parent.width; opacity: 0.22; glyph: "description"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
                        ListRow {
                            y: 44; width: parent.width; selected: true
                            glyph: ed.modelData.fresh ? "folder" : "description"; name: ed.modelData.name; facts: ["Fact"]; factWidths: [64]
                            previewState: "editing"; editAll: ed.modelData.all; fresh: ed.modelData.fresh
                        }
                    }
                }
            }
        }

        // ---- guideline examples: a short real list on the calm stage, the example row in the middle
        Item {
            visible: app.fig.startsWith("do")
            anchors.fill: parent
            Glass { anchors.fill: parent }
            readonly property bool narrowNames: app.fig === "do-name-first" || app.fig === "dont-name-cut"
            Column {
                x: 24; width: 370; anchors.verticalCenter: parent.verticalCenter
                ListRow { width: parent.width; glyph: "deployed_code"; name: parent.parent.narrowNames ? "tacit-1.1.7-x86_64.iso" : "tacit.iso"; aside: "tacitos.co"; facts: ["16:15"]; factWidths: [56] }
                ListRow {
                    visible: app.fig !== "dont-name-cut"
                    width: parent.width
                    glyph: "music_note"
                    name: app.fig === "do-name-first" ? "Undertow - Mara Velde.mp3" : "Undertow.mp3"
                    aside: "bandcamp.com"; facts: ["18:02"]; factWidths: [56]
                    selected: app.fig === "do-one-signal" || app.fig === "dont-signals"
                    current: app.fig === "dont-signals"
                    Rectangle { visible: app.fig === "dont-signals"; x: 0; y: 8; width: 4; height: 28; radius: 2; color: Kit.tokens.accent }
                }
                // drawn by hand: a name cut while the name beside it stays whole (the part never does this)
                Item {
                    visible: app.fig === "dont-name-cut"
                    width: parent.width; height: 44
                    Symbol { x: 16; anchors.verticalCenter: parent.verticalCenter; text: "music_note" }
                    TacitText { x: 52; width: 110; anchors.verticalCenter: parent.verticalCenter; text: "Undertow - Mara Velde.mp3"; elide: Text.ElideMiddle }
                    TacitText { x: 174; anchors.verticalCenter: parent.verticalCenter; text: "bandcamp.com"; ink: "meta" }
                    TacitText { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; width: 56; horizontalAlignment: Text.AlignRight; text: "18:02"; ink: "sec"; cut: "numbers" }
                }
                ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease.pdf"; aside: "docs.google.com"; facts: ["14:40"]; factWidths: [56] }
            }
        }
    }

    Timer {
        id: go; interval: 900; running: true
        onTriggered: stage.grabToImage(g => {
            g.saveToFile(app.out + "/" + app.fig + ".png");
            if (app.i + 1 >= app.figures.length) Qt.quit(); else { app.i++; go.restart(); }
        })
    }
}
