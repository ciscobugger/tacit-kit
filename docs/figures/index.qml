// The front page's cards (docs/cards-brief): one small render per part, 360 by 240, the part on its own at its real size on the calm stage
// (no dot grid), centred by its ink; a part wider than the stage runs off an edge.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["card-list-row", 360, 240], ["card-row-list", 360, 240], ["card-section-heading", 360, 240], ["card-picture-grid", 360, 240],
              ["card-cover-grid", 360, 240], ["card-jump-index", 360, 240], ["card-rail", 360, 240], ["card-page-header", 360, 240],
              ["card-search-field", 360, 240], ["card-view-bar", 360, 240], ["card-tabs", 360, 240], ["card-page-state", 360, 240],
              ["card-slab", 360, 240], ["card-actions-as-words", 360, 240], ["card-icon-button", 360, 240], ["card-menu", 360, 240],
              ["card-inline-link", 360, 240], ["card-field", 360, 240], ["card-text-area", 360, 240], ["card-check", 360, 240],
              ["card-choices", 360, 240], ["card-select", 360, 240], ["card-switch", 360, 240], ["card-slider", 360, 240],
              ["card-window-ground", 360, 240], ["card-docked-panel", 360, 240], ["card-notice", 360, 240],
              ["card-tooltip", 360, 240], ["card-progress", 360, 240], ["card-focus-ring", 360, 240], ["card-transport", 360, 240],
              ["card-waveform", 360, 240], ["card-text", 360, 240], ["card-symbol", 360, 240], ["card-scrolling", 360, 240],
              ["card-scroll-bar", 360, 240]]
    readonly property var peaks: [0.4, 0.42, 0.41, 0.43, 0.43, 0.42, 0.42, 0.43, 0.44, 0.46, 0.45, 0.45, 0.47, 0.49, 0.51, 0.53, 0.58, 0.7, 0.57, 0.61, 0.57, 0.62, 0.64, 0.57, 0.28, 0.68, 0.68, 0.66, 0.69, 0.68, 0.68, 0.67, 0.68, 0.69, 0.69, 0.68, 0.64, 0.68, 0.68, 0.68, 0.58, 0.64, 0.97, 0.96, 0.97, 0.97, 0.97, 0.97, 0.94, 0.94, 0.98, 0.97, 0.95, 0.98, 0.98, 0.98, 0.96, 0.61, 0.84, 0.98, 0.98, 0.96, 0.97, 0.99, 0.96, 0.96, 0.97, 0.98, 0.95, 0.98, 0.98, 0.97, 0.97, 0.93, 0.39, 0.99, 0.98, 0.96, 0.99, 0.98, 0.98, 0.97, 0.95, 0.97, 0.98, 0.98, 0.98, 0.96, 0.99, 0.96, 0.8, 0.46, 0.5, 0.53, 0.55, 0.52, 0.48, 0.52, 0.54, 0.55, 0.77, 0.61, 0.6, 0.62, 0.63, 0.66, 0.47, 0.31, 0.82, 0.97, 0.97, 0.97, 0.95, 0.98, 0.95, 0.96, 0.97, 0.98, 0.95, 0.98, 0.98, 0.98, 0.97, 0.92, 0.41, 0.98, 0.97, 0.96, 0.97, 0.98, 0.98, 0.96, 0.95, 0.96, 0.98, 0.97, 0.97, 0.96, 0.99, 0.96, 0.8, 0.67, 1.0, 0.96, 0.98, 1.0, 0.98, 0.97, 0.96, 0.96, 0.98, 0.98, 0.97, 0.98, 0.98, 0.97, 0.96, 0.59, 0.62, 0.68, 0.68, 0.69, 0.64, 0.68, 0.68, 0.69, 0.69, 0.69, 0.65, 0.67, 0.69, 0.68, 0.69, 0.64, 0.27, 0.23, 0.15, 0.15, 0.15, 0.15]
    function pic(p, r, g) { return { source: app.pics + p + ".jpg", ratio: r, group: g, name: p + ".jpg" }; }
    component F: Item {
        property string n
        default property alias content: body.data
        visible: app.fig === "card-" + n
        anchors.fill: parent
        DocGlass { anchors.fill: parent; dots: false }
        Item { id: body; anchors.fill: parent }
    }

    F { n: "list-row"
        Column { x: 14; y: 54; width: 332
            ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease.pdf"; facts: ["2.2 MB"]; factWidths: [72] }
            ListRow { width: parent.width; glyph: "music_note"; name: "Undertow.mp3"; facts: ["11.6 MB"]; factWidths: [72]; selected: true }
            ListRow { width: parent.width; glyph: "description"; name: "Budget.xlsx"; facts: ["84 kB"]; factWidths: [72]; previewState: "hover" }
        }
    }

    F { n: "row-list"
        RowList {
            id: rl
            x: 14; y: 32; width: 450; height: 4 * 44
            model: [{ g: "music_note", n: "Undertow.mp3", f: ["11.6 MB"] }, { g: "picture_as_pdf", n: "Lease.pdf", f: ["2.2 MB"] },
                    { g: "description", n: "Budget.xlsx", f: ["84 kB"] }, { g: "folder", n: "Holiday 2024", f: ["12 items"] }]
            delegate: ListRow {
                required property var modelData
                required property int index
                width: rl.rowWidth; focusable: false
                glyph: modelData.g; name: modelData.n; facts: modelData.f
                selected: rl.isSelected(index)
                joinAbove: rl.isSelected(index - 1); joinBelow: rl.isSelected(index + 1)
                previewState: index === 2 ? "focus" : ""
            }
            Component.onCompleted: setSelection([1, 2])
        }
    }

    F { n: "section-heading"
        Column { x: 14; y: 76; width: 450
            SectionHeading { text: "Today" }
            ListRow { width: parent.width; focusable: false; glyph: "music_note"; name: "Undertow.mp3"; facts: ["18:02"]; factWidths: [64] }
            ListRow { width: parent.width; focusable: false; glyph: "picture_as_pdf"; name: "Lease.pdf"; facts: ["14:40"]; factWidths: [64] }
        }
    }

    F { n: "picture-grid"
        PictureGrid {
            x: 15; y: 20; width: 330; height: 200
            rowHeight: 92
            previewHover: 2
            pictures: [app.pic("p4", 1.778, "Today"), app.pic("p1", 0.75, "Today"), app.pic("p2", 1.333, "Today"), app.pic("p5", 1, "Today"),
                       app.pic("p7", 1.333, "Today"), app.pic("p3", 0.75, "Today"), app.pic("p8", 1.778, "Today")]
            Component.onCompleted: setSelection([1])
        }
    }

    F { n: "cover-grid"
        CoverGrid {
            x: 20; y: -5; width: 400; height: 260
            cursor: 0
            previewHover: 1
            items: [{ source: app.mus + "c1.jpg", title: "Low Tide", subtitle: "Mara Velde" }, { source: app.mus + "c2.jpg", title: "Salt Road", subtitle: "Hana Oru" },
                    { source: app.mus + "c3.jpg", title: "Harbour", subtitle: "Ines Okoro" }, { source: app.mus + "c4.jpg", title: "Kettle", subtitle: "Mara Velde" }]
        }
    }

    F { n: "jump-index"
        // the index beside the list it jumps through, on the letter the rows are at
        Column { x: 12; y: (240 - height) / 2; width: 360 - 12 - 16 - ji.width - 8
            Repeater { model: ["Hana Oru", "Harbour Lights", "Hollow Pine"]
                ListRow { required property string modelData; width: parent.width; focusable: false; glyph: "artist"; name: modelData; facts: [] } } }
        JumpIndex { id: ji; x: 360 - 16 - width; y: (240 - height) / 2; marks: "ABCDEFGH".split(""); present: ["A", "B", "D", "E", "G", "H"]; previewHover: "H" }
    }

    F { n: "rail"
        Rail {
            x: 40; y: 0; height: 240
            RailRow { glyph: "home"; label: "Home" }
            RailRow { glyph: "description"; label: "Documents" }
            RailRow { glyph: "download"; label: "Downloads"; current: true }
            RailRow { glyph: "image"; label: "Pictures" }
        }
    }

    F { n: "page-header"
        PageHeader { y: 84; width: 440; crumbs: ["Files"]; here: "Downloads"
            IconButton { anchors.verticalCenter: parent.verticalCenter; symbol: "search"; label: "Search" } }
    }

    F { n: "search-field"
        DocCentre { SearchField { scope: "Downloads"; previewState: "typed"; fieldWidth: 280 } }
    }

    F { n: "view-bar"
        ViewBar { x: 40; y: 98; width: 328; count: ""; order: "Newest first"; views: ["List", "Grid"]; orderItems: [{ label: "Newest first", checked: true }, { label: "Oldest first" }, { label: "Name" }] }
    }

    F { n: "tabs"
        DocCentre { Tabs { labels: ["Preview", "Details", "History"]; current: 1 } }
    }

    F { n: "page-state"
        DocCentre { PageState { text: "Nothing in this folder.\nDrop files here to move them in." } }
    }

    F { n: "slab"
        DocCentre { Row { spacing: 12
            Slab { tone: "default"; text: "Restart now"; large: true }
            Slab { text: "Later"; large: true } } }
    }

    F { n: "actions-as-words"
        DocCentre { Column {
            WordAction { width: 220; text: "Open with…" }
            WordAction { width: 220; text: "Share"; previewState: "hover" }
            WordAction { width: 220; text: "Rename" }
            WordAction { width: 220; text: "Move to the trash"; risk: true } } }
    }

    F { n: "icon-button"
        DocCentre { Row { spacing: 8
            IconButton { symbol: "star"; label: "Star" }
            IconButton { symbol: "search"; label: "Search"; previewState: "hover" }
            IconButton { symbol: "grid_view"; label: "View" }
            IconButton { symbol: "more_horiz"; label: "More" } } }
    }

    F { n: "menu"
        DocCentre { MenuSurface { items: [{ label: "Open", detail: "Enter" }, { label: "Rename", detail: "F2" }, { label: "Share" }, { rule: true }, { label: "Move to the trash", risk: true }]; cursor: 1 } }
    }

    F { n: "inline-link"
        DocCentre { Row {
            TacitText { text: "Downloaded from "; ink: "sec" }
            InlineLink { text: "bandcamp.com"; previewState: "hover" } } }
    }

    F { n: "field"
        DocCentre { Field { width: 280; text: "Holiday 2024"; hint: "Name"; previewState: "focus" } }
    }

    F { n: "text-area"
        DocCentre { TextArea { width: 300; minLines: 3; text: "Rename the photos from the trip to the day they were taken."; previewState: "focus" } }
    }

    F { n: "check"
        DocCentre { Column { spacing: 4
            Check { label: "Show hidden files"; checked: true }
            Check { label: "Show file sizes"; mixed: true }
            Check { label: "Open in a new window" } } }
    }

    F { n: "choices"
        DocCentre { Choices { model: ["Name", "Date modified", "Size"]; current: 1 } }
    }

    F { n: "select"
        DocCentre { Item { width: 236; height: 40 + 8 + menuS.height
            Select { width: 236; options: ["Newest first", "Oldest first", "Name", "Size"]; current: 1; previewState: "hover" }
            MenuSurface { id: menuS; y: 48; items: [{ label: "Newest first" }, { label: "Oldest first", checked: true }, { label: "Name" }, { label: "Size" }]; cursor: 1 } } }
    }

    F { n: "switch"
        DocCentre { Column { width: 300
            Item { width: parent.width; height: 44
                TacitText { x: 16; anchors.verticalCenter: parent.verticalCenter; text: "Night light" }
                Switch { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; label: "Night light"; checked: true } }
            Item { width: parent.width; height: 44
                TacitText { x: 16; anchors.verticalCenter: parent.verticalCenter; text: "Do not disturb" }
                Switch { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; label: "Do not disturb" } } } }
    }

    F { n: "slider"
        DocCentre { Slider { width: 280; value: 0.65; word: "65 %"; label: "Volume"; previewState: "hover" } }
    }

    DocWindow {
        visible: app.fig === "card-window-ground"
        anchors.fill: parent
        wx: 72; wy: 56; wallX: -400; wallY: -620
    }

    F { n: "docked-panel"
        DockedPanel {
            x: 360 - 260; y: 10; height: 220; open: true; openWidth: 260
            Column { x: 20; y: 18; width: 220; spacing: 2
                TacitText { text: "Lease.pdf"; size: "body"; weight: "medium" }
                TacitText { text: "PDF document, 2.2 MB"; ink: "sec" }
                Item { width: 1; height: 10 }
                Slab { tone: "default"; text: "Open" }
                Item { width: 1; height: 4 }
                WordAction { width: 220; text: "Share" }
                WordAction { width: 220; text: "Rename" }
            }
        }
    }

    F { n: "notice"
        Item { x: 0; y: 70; width: 360; height: 100
            Notice { previewState: "shown"; text: "Moved 3 files to Documents"; actionWords: "Undo" } }
    }

    F { n: "tooltip"
        DocCentre { cw: 80; ch: 92
            IconButton { x: 22; symbol: "grid_view"; label: "Grid"; previewState: "hover" }
            TooltipSurface { x: 40 - width / 2; y: 36 + 8; text: "Grid" } }
    }

    F { n: "progress"
        DocCentre { Progress { width: 280; value: 0.62; label: "Copying photos-october.zip" } }
    }

    F { n: "focus-ring"
        DocCentre { Row { spacing: 14
            IconButton { symbol: "star"; label: "Star" }
            Slab { tone: "default"; text: "Open"; previewState: "focus" } } }
    }

    F { n: "transport"
        DocCentre { Transport { size: 64; playing: true } }
    }

    F { n: "waveform"
        DocCentre { Waveform { width: 300; height: 56; peaks: app.peaks; position: 0.38; playhead: true } }
    }

    F { n: "text"
        DocCentre { Column { spacing: 8
            TacitText { text: "Undertow"; size: "alarm"; cut: "display"; weight: "strong" }
            TacitText { text: "Mara Velde"; size: "section"; ink: "sec" }
            TacitText { text: "Low Tide, 2024"; size: "meta"; ink: "meta" } } }
    }

    F { n: "symbol"
        DocCentre { Row { spacing: 24
            Symbol { text: "music_note"; size: 20; color: Kit.tokens.inkMain }
            Symbol { text: "picture_as_pdf"; size: 20; color: Kit.tokens.inkMain }
            Symbol { text: "folder"; size: 20; color: Kit.tokens.inkMain }
            Symbol { text: "image"; size: 20; color: Kit.tokens.inkMain }
            Symbol { text: "download"; size: 20; color: Kit.tokens.inkMain } } }
    }

    F { n: "scrolling"
        Flickable { x: 30; y: 0; width: 400; height: 240; contentHeight: 600; contentY: 26; clip: true
            Column { width: parent.width
                ListRow { width: 330; glyph: "picture_as_pdf"; name: "Lease.pdf"; facts: ["14:40"]; factWidths: [64] }
                ListRow { width: 330; glyph: "description"; name: "Budget.xlsx"; facts: ["09:12"]; factWidths: [64]; selected: true }
                ListRow { width: 330; glyph: "music_note"; name: "Undertow.mp3"; facts: ["18:02"]; factWidths: [64] }
                ListRow { width: 330; glyph: "folder"; name: "Holiday 2024"; facts: ["12 items"]; factWidths: [64] }
                ListRow { width: 330; glyph: "deployed_code"; name: "photos-october.zip"; facts: ["08:31"]; factWidths: [64] }
                ListRow { width: 330; glyph: "image"; name: "dune-light.jpg"; facts: ["11:20"]; factWidths: [64] } }
        }
    }

    F { n: "scroll-bar"
        Item { x: 80; y: 20; width: 200; height: 200
            Flickable { id: fl; anchors.fill: parent; contentHeight: 600; contentY: 140; clip: true
                Column { width: parent.width
                    Repeater { model: ["Lease.pdf", "Budget.xlsx", "Undertow.mp3", "Holiday 2024", "Salt Road.mp3", "dune-light.jpg", "Notes.md", "Taxes 2026", "orbit-red.jpg", "Invoice.pdf", "Backup.zip", "Plan.md", "Cover.png"]
                        ListRow { required property string modelData; width: fl.width; focusable: false; glyph: "description"; name: modelData; facts: [] } } }
            }
            ScrollBar { view: fl; anchors.fill: fl; previewState: "dragging" }
        }
    }
}
