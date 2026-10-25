// The render catalogue: every Tacit.Kit part in its states, on the window's real ground, for one palette
// (XDG_STATE_HOME picks it). Runs inside a copy of the shell tree (it hands the shell's Tacit to the kit) with
// QML_IMPORT_PATH pointing at tacit-kit/qml; tools/catalogue.sh does both. Writes CATALOGUE_OUT.png and quits.
import QtQuick
import QtQuick.Controls
import Quickshell
import Qt5Compat.GraphicalEffects
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Tacit.Kit
import "MusicPeaks.js" as P

ApplicationWindow {
    id: app
    visible: true; width: 1320; height: 760; color: "black"
    readonly property int page: Number(Quickshell.env("CATALOGUE_PAGE") || 1)
    readonly property string mus: "file://" + Quickshell.env("HOME") + "/.cache/tacit-mocks/music/"
    readonly property string pics: "file://" + Quickshell.env("HOME") + "/.cache/tacit-mocks/files/"
    readonly property string wall: Quickshell.env("MOCK_WALL") || "dusk"
    Component.onCompleted: { MaterialThemeLoader.reapplyTheme(); Kit.tokens = Tacit; }

    component Label: Text { color: Kit.tokens.inkMeta; font.family: Kit.tokens.font.main; font.pixelSize: Kit.tokens.size.meta; width: 150 }

    Item {
        id: shot
        anchors.fill: parent
        Image { anchors.fill: parent; source: app.mus + "wall-" + app.wall + "-blur.jpg"; fillMode: Image.PreserveAspectCrop }
        Rectangle { anchors.fill: parent; color: Kit.tokens.windowGround; opacity: 1 - Kit.tokens.windowSeeThrough }

        Column {
            visible: app.page === 1
            x: 40; y: 32; spacing: 14
            Text { text: "ListRow"; color: Kit.tokens.inkMain; font.family: Kit.tokens.font.display; font.pixelSize: Kit.tokens.size.section; font.weight: Font.DemiBold }
            Repeater {
                model: [
                    ["rest", {}], ["hover", { previewState: "hover" }], ["pressed", { previewState: "pressed" }],
                    ["selected", { selected: true }], ["keyboard focus", { selected: true, previewState: "focus" }],
                    ["current", { current: true }], ["picture", { picture: app.pics + "p11.jpg" }],
                    ["long name", { name: "A very long file name that does not fit in the row at all, kept by its ends.pdf" }]
                ]
                Row {
                    required property var modelData
                    spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: parent.modelData[0] }
                    ListRow {
                        width: 820
                        glyph: "music_note"; name: "Undertow - Mara Velde.mp3"; aside: "bandcamp.com"; facts: ["11.6 MB", "18:02"]
                        Component.onCompleted: { const o = parent.modelData[1]; for (const k in o) this[k] = o[k]; }
                    }
                }
            }
            Item { width: 1; height: 8 }
            Text { text: "SectionHeading"; color: Kit.tokens.inkMain; font.family: Kit.tokens.font.display; font.pixelSize: Kit.tokens.size.section; font.weight: Font.DemiBold }
            Row {
                spacing: 16
                Label { anchors.bottom: parent.bottom; anchors.bottomMargin: 14; text: "heading over a row" }
                Column {
                    SectionHeading { text: "Yesterday" }
                    ListRow { width: 820; glyph: "archive"; name: "photos-october.zip"; aside: "drive.google.com"; facts: ["420 MB", "21:08"] }
                }
            }
        }

        // ---- page 2: the header, search, buttons, actions, a list with the keyboard on it, the docked panel
        Item {
            visible: app.page === 2
            anchors.fill: parent
            PageHeader {
                width: parent.width; crumbs: ["Home"]; here: "Downloads"; canGoBack: true
                SearchField { anchors.verticalCenter: parent.verticalCenter; scope: "Downloads" }
                MenuButton { anchors.verticalCenter: parent.verticalCenter; text: "Newest first"; items: [{ label: "Newest first", checked: true }, { label: "Name" }] }
            }
            Column {
                x: 40; y: 96; spacing: 12
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "search" }
                    SearchField { scope: "Downloads" }
                    SearchField { scope: "Downloads"; previewState: "hover" }
                    SearchField { scope: "Downloads"; previewState: "open" }
                }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "" }
                    SearchField { scope: "Downloads"; previewState: "typed" }
                    SearchField { scope: "Downloads"; previewState: "focus" }
                }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "icon button" }
                    IconButton { symbol: "arrow_back"; label: "Back" }
                    IconButton { symbol: "arrow_back"; label: "Back"; previewState: "hover" }
                    IconButton { symbol: "arrow_back"; label: "Back"; previewState: "pressed" }
                    IconButton { symbol: "arrow_back"; label: "Back"; previewState: "focus" }
                    IconButton { symbol: "arrow_forward"; label: "Forward"; enabled: false }
                }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "slab" }
                    Slab { text: "Open"; tone: "default" }
                    Slab { text: "Open"; tone: "default"; previewState: "hover" }
                    Slab { text: "Open"; tone: "default"; previewState: "focus" }
                    Slab { text: "Open with" }
                    Slab { text: "Open with"; previewState: "hover" }
                    Slab { text: "Delete for good"; tone: "risk" }
                }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "actions as words" }
                    Column {
                        WordAction { text: "Open with…" }
                        WordAction { text: "Park on the shelf"; previewState: "hover" }
                        WordAction { text: "Rename…"; previewState: "focus" }
                        WordAction { text: "Move to the trash"; risk: true }
                    }
                }
                Row { spacing: 16
                    Label { text: "row list, keyboard on row 2,\nrows 2 to 3 selected" }
                    RowList {
                        id: demoList
                        width: 560; height: 3 * 44
                        model: [{ name: "Undertow - Mara Velde.mp3", aside: "bandcamp.com", g: "music_note", f: ["11.6 MB", "18:02"] },
                                { name: "tacit-1.1.7-x86_64.iso", aside: "download.tacitos.co", g: "deployed_code", f: ["2.9 GB", "16:15"] },
                                { name: "Lease agreement.pdf", aside: "docs.google.com", g: "picture_as_pdf", f: ["2.2 MB", "14:40"] }]
                        delegate: ListRow {
                            required property var modelData
                            required property int index
                            width: demoList.rowWidth; focusable: false
                            glyph: modelData.g; name: modelData.name; aside: modelData.aside; facts: modelData.f
                            selected: demoList.isSelected(index); ring: demoList.ringAt(index)
                            joinAbove: demoList.isSelected(index - 1); joinBelow: demoList.isSelected(index + 1)
                        }
                        Component.onCompleted: { setSelection([1, 2]); cursor = 1; forceActiveFocus(); Kit.focusVisible = true; }
                    }
                }
            }
        }
        // ---- page 4: the docked panel, open, on the right edge under the header's line
        Item {
            visible: app.page === 4
            anchors.fill: parent
            PageHeader { width: parent.width; crumbs: ["Home"]; here: "Downloads" }
            DockedPanel {
                anchors.right: parent.right; y: 73; height: parent.height - 73 - 20; open: true
                Column {
                    x: 24; y: 24; width: 352; spacing: 0
                    TacitText { width: 352; wrapMode: Text.Wrap; text: "Undertow - Mara Velde.mp3"; size: "body"; weight: "medium" }
                    Item { width: 1; height: 6 }
                    TacitText { width: 352; text: "Mara Velde, Low Tide (2024), 5:01"; ink: "sec" }
                    Item { width: 1; height: 22 }
                    Slab { text: "Open"; tone: "default" }
                    Item { width: 1; height: 16 }
                    WordAction { text: "Open with…" }
                    WordAction { text: "Park on the shelf" }
                    WordAction { text: "Move to the trash"; risk: true }
                }
            }
        }
        // ---- page 5: the menu button and its menu, open, the keyboard on a line
        Item {
            visible: app.page === 5
            anchors.fill: parent
            PageHeader {
                width: parent.width; crumbs: ["Home"]; here: "Downloads"
                SearchField { anchors.verticalCenter: parent.verticalCenter; scope: "Downloads" }
                MenuButton {
                    id: sortButton
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Newest first"
                    items: [{ label: "Newest first", checked: true }, { label: "Oldest first" }, { label: "Name" }, { label: "Size" },
                            { label: "Kind" }, { rule: true }, { label: "Show hidden files" }]
                }
            }
            // the menu as it opens under the button, drawn in place, the keyboard on "Name"
            MenuSurface {
                x: parent.width - 24 - implicitWidth; y: 72 + 6
                items: [{ label: "Newest first", checked: true }, { label: "Oldest first" }, { label: "Name" }, { label: "Size" },
                        { label: "Kind" }, { rule: true }, { label: "Show hidden files" }, { rule: true }, { label: "Forget where I file things", risk: true }]
                cursor: 2
                keyboard: true
            }
            Column {
                x: 40; y: 120; spacing: 16
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "menu button" }
                    MenuButton { text: "Newest first" }
                    MenuButton { text: "Newest first"; previewState: "hover" }
                    MenuButton { text: "Newest first"; previewState: "focus" }
                }
            }
        }
        // ---- page 6: what plays: transport, waveform, the jump index
        Item {
            visible: app.page === 6
            anchors.fill: parent
            Column {
                x: 40; y: 32; spacing: 22
                Text { text: "Transport"; color: Kit.tokens.inkMain; font.family: Kit.tokens.font.display; font.pixelSize: Kit.tokens.size.section; font.weight: Font.DemiBold }
                Row { spacing: 40
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "stage, 64" }
                    Transport { size: 64; playing: true }
                    Transport { size: 64; playing: false; previewState: "hover" }
                    Transport { size: 64; playing: true; previewState: "focus" }
                }
                Row { spacing: 40
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "player bar, 40" }
                    Transport { size: 40; playing: true }
                    Transport { size: 40; playing: true; previewState: "pressed" }
                    Transport { size: 40; playing: false; canPrevious: false }
                }
                Item { width: 1; height: 6 }
                Text { text: "Waveform"; color: Kit.tokens.inkMain; font.family: Kit.tokens.font.display; font.pixelSize: Kit.tokens.size.section; font.weight: Font.DemiBold }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "stage, playhead" }
                    Waveform { width: 760; height: 104; bar: 3.5; peaks: P.peaks; position: 0.38; playhead: true }
                }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "player bar" }
                    Waveform { width: 380; height: 32; bar: 2.5; peaks: P.peaks; position: 0.38 }
                    Item { width: 24; height: 1 }
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "keyboard focus"; width: 110 }
                    Waveform { width: 380; height: 32; bar: 2.5; peaks: P.peaks; position: 0.38; previewState: "focus" }
                }
            }
            Row {
                anchors.right: parent.right; anchors.rightMargin: 20; y: 20; spacing: 8
                Label { text: "jump index\n(G under the pointer)"; width: 130; horizontalAlignment: Text.AlignRight }
                JumpIndex { present: "AGHIKLMNOPSTY".split(""); previewHover: "G" }
            }
        }
        // ---- page 7: no content, a failure, a page still being read
        Item {
            visible: app.page === 7
            anchors.fill: parent
            Repeater {
                model: [
                    { y: 0, here: "old", crumbs: ["Home", "Downloads"], loading: false, text: "Nothing in this folder. Drop files here to move them in.", failure: false, action: "" },
                    { y: 250, here: "TRANSFER", crumbs: [], loading: false, text: "TRANSFER was removed. Plug it in again to see its files.", failure: true, action: "Go to Home" },
                    { y: 500, here: "TRANSFER", crumbs: [], loading: true, text: "", failure: false, action: "" }
                ]
                Item {
                    required property var modelData
                    y: modelData.y; width: parent.width; height: 250
                    PageHeader { width: parent.width; crumbs: parent.modelData.crumbs; here: parent.modelData.here; loading: parent.modelData.loading }
                    PageState { visible: parent.modelData.text !== ""; x: 40; y: 104; text: parent.modelData.text; failure: parent.modelData.failure; action: parent.modelData.action }
                    Column {
                        visible: parent.modelData.loading
                        x: 12; y: 80
                        ListRow { width: 820; glyph: "folder"; name: "backups"; facts: ["12 items", "4 Oct"] }
                        ListRow { width: 820; glyph: "folder"; name: "Book4 archives"; facts: ["38 items", "22 Sep"] }
                        ListRow { width: 820; glyph: "folder"; name: "camera tests"; facts: ["214 items", "30 Sep"] }
                    }
                }
            }
        }
        // ---- page 8: the rail (Files', open; Music's, folded) and the picture grid
        Item {
            visible: app.page === 8
            anchors.fill: parent
            Rail {
                height: parent.height
                RailRow { glyph: "schedule"; label: "Recent"; fresh: true }
                RailSection { text: "Places" }
                RailRow { glyph: "home"; label: "Home" }
                RailRow { glyph: "desktop_windows"; label: "Desktop" }
                RailRow { glyph: "description"; label: "Documents"; previewState: "hover" }
                RailRow { glyph: "download"; label: "Downloads"; current: true }
                RailRow { glyph: "music_note"; label: "Music"; previewState: "focus" }
                RailRow { glyph: "image"; label: "Pictures" }
                RailRow { glyph: "movie"; label: "Videos" }
                RailSection { text: "Pinned" }
                RailRow { glyph: "folder"; label: "site" }
                RailSection { text: "Drives" }
                RailRow { glyph: "usb"; label: "TRANSFER"; context: "41 GB free" }
            }
            Rail {
                x: 300; height: parent.height
                folded: true
                action: "Shuffle all"; actionSymbol: "shuffle"
                RailRow { glyph: "graphic_eq"; label: "Playing"; current: true }
                RailSection { text: "Library" }
                RailRow { glyph: "artist"; label: "Artists"; context: "15" }
                RailRow { glyph: "note_stack"; label: "Albums"; context: "16" }
                RailRow { glyph: "music_note"; label: "Songs"; context: "177" }
            }
            PictureGrid {
                x: 380; y: 0; width: parent.width - 380 - 24; height: parent.height
                previewHover: 1
                pictures: {
                    const days = [["Today", [["p4", 1.778], ["p1", 0.75], ["p2", 1.333], ["p5", 1]]],
                        ["Tuesday 22 October", [["p7", 1.333], ["p3", 0.75], ["p8", 1.778], ["p6", 0.75], ["p10", 1.333], ["p9", 0.75], ["p12", 1.778], ["p11", 1]]],
                        ["Sunday 20 October", [["p13", 0.75], ["p14", 1.333]]]];
                    const out = [];
                    for (const d of days) for (const q of d[1]) out.push({ source: app.pics + q[0] + ".jpg", ratio: q[1], group: d[0], name: q[0] + ".jpg" });
                    return out;
                }
                Component.onCompleted: { setSelection([4, 5]); cursor = 5; forceActiveFocus(); Kit.focusVisible = true; }
            }
        }
        // ---- page 9 (proposal): switch, slider, tabs, progress, field, tooltip, each from where Tacit draws it now
        Row {
            visible: app.page === 9
            x: 40; y: 32; spacing: 80
            component Head: Text { color: Kit.tokens.inkMain; font.family: Kit.tokens.font.display; font.pixelSize: Kit.tokens.size.section; font.weight: Font.DemiBold }
            Column {
                spacing: 18
                Head { text: "Switch" }
                Repeater {
                    model: [["on", { checked: true }], ["off", {}], ["off, pointer over", { previewState: "hover" }],
                            ["on, keyboard", { checked: true, previewState: "focus" }], ["off, unavailable", { enabled: false }]]
                    Row { required property var modelData; spacing: 16
                        Label { anchors.verticalCenter: parent.verticalCenter; text: parent.modelData[0] }
                        Switch { label: "Spell check"; Component.onCompleted: { const o = parent.modelData[1]; for (const k in o) this[k] = o[k]; } }
                    }
                }
                Item { width: 1; height: 10 }
                Head { text: "Slider" }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "at rest" }
                    Slider { value: 0.7; word: "70 %"; label: "Volume" } }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "pointer over" }
                    Slider { value: 0.7; word: "70 %"; previewState: "hover" } }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "keyboard" }
                    Slider { value: 0.35; word: "35 %"; previewState: "focus" } }
                Item { width: 1; height: 10 }
                Head { text: "Tabs" }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "first chosen" }
                    Tabs { labels: ["Replace text", "Number them"]; current: 0 } }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "pointer on the other" }
                    Tabs { labels: ["Replace text", "Number them"]; current: 0; previewHover: 1 } }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "keyboard" }
                    Tabs { labels: ["Replace text", "Number them"]; current: 1; previewState: "focus" } }
            }
            Column {
                spacing: 18
                Head { text: "Progress" }
                Column { spacing: 10
                    Row { spacing: 12
                        TacitText { text: "Copying 3 of 12 files to TRANSFER" }
                        TacitText { text: "2 min left"; ink: "meta" } }
                    Progress { width: 420; value: 0.25; label: "Copying to TRANSFER" } }
                Column { spacing: 10
                    TacitText { text: "Reading TRANSFER" }
                    Progress { width: 420; going: true; label: "Reading TRANSFER" } }
                Item { width: 1; height: 10 }
                Head { text: "Field" }
                Repeater {
                    model: [["empty", { hint: "Find" }], ["pointer over", { hint: "Find", previewState: "hover" }],
                            ["typing", { text: "IMG_20", previewState: "focus" }]]
                    Row { required property var modelData; spacing: 16
                        Label { anchors.verticalCenter: parent.verticalCenter; text: parent.modelData[0] }
                        // a field lives in a panel: the panel's colour behind it
                        Rectangle {
                            width: 360; height: 52; radius: Kit.tokens.radius.slab; color: Kit.tokens.container
                            Field { anchors.centerIn: parent; width: 336; Component.onCompleted: { const o = parent.parent.modelData[1]; for (const k in o) this[k] = o[k]; } }
                        }
                    }
                }
                Item { width: 1; height: 10 }
                Head { text: "Tooltip" }
                Row { spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "under a symbol button,\nafter 600 ms" }
                    Item {
                        width: 200; height: 80
                        IconButton { id: tipTarget; symbol: "left_panel_close"; label: "Fold the places"; previewState: "hover" }
                        TooltipSurface { x: tipTarget.x + (tipTarget.width - width) / 2; y: tipTarget.height + 8; text: "Fold the places" }
                    }
                }
            }
        }
        // ---- page 10 (proposal): renaming many files in the docked panel, which the task takes over
        Item {
            visible: app.page === 10
            anchors.fill: parent
            Rail {
                height: parent.height
                RailRow { glyph: "schedule"; label: "Recent" }
                RailSection { text: "Places" }
                RailRow { glyph: "home"; label: "Home" }
                RailRow { glyph: "description"; label: "Documents" }
                RailRow { glyph: "download"; label: "Downloads" }
                RailRow { glyph: "image"; label: "Pictures"; current: true }
            }
            Item {
                x: 300; width: parent.width - 300; height: parent.height
                PageHeader {
                    width: parent.width; crumbs: ["Home"]; here: "Pictures"
                    SearchField { anchors.verticalCenter: parent.verticalCenter; scope: "Pictures" }
                }
                Column {
                    x: 12; y: 80; width: parent.width - 400 - 24
                    SectionHeading { text: "Saturday 19 October" }
                    Repeater {
                        model: [["p13", "IMG_2041.jpg", "3.1 MB", "14:02", true], ["p14", "IMG_2042.jpg", "2.8 MB", "14:05", true],
                                ["p6", "IMG_2043.jpg", "3.4 MB", "14:09", true], ["p9", "IMG_2044.jpg", "2.2 MB", "15:30", false],
                                ["p3", "IMG_2045.jpg", "2.9 MB", "15:31", false]]
                        ListRow {
                            required property var modelData
                            required property int index
                            width: parent.width
                            picture: app.pics + modelData[0] + ".jpg"; name: modelData[1]; facts: [modelData[2], modelData[3]]
                            selected: modelData[4]
                            joinAbove: index > 0 && index < 3; joinBelow: index < 2
                        }
                    }
                }
                DockedPanel {
                    anchors.right: parent.right; y: 73; height: parent.height - 73 - 20; open: true
                    Column {
                        x: 24; y: 24; width: 352; spacing: 0
                        TacitText { text: "Rename 3 pictures"; size: "body"; weight: "medium" }
                        Item { width: 1; height: 14 }
                        Tabs { x: -Kit.tokens.space.m; labels: ["Replace text", "Number them"]; current: 0 }
                        Item { width: 1; height: 16 }
                        Field { width: 352; text: "IMG_20"; hint: "Find"; previewState: "focus" }
                        Item { width: 1; height: 10 }
                        Field { width: 352; text: "Holiday "; hint: "Replace with" }
                        Item { width: 1; height: 22 }
                        Repeater {
                            model: [["IMG_2041.jpg", "Holiday 41.jpg"], ["IMG_2042.jpg", "Holiday 42.jpg"], ["IMG_2043.jpg", "Holiday 43.jpg"]]
                            Row {
                                required property var modelData
                                height: 30; spacing: 10
                                TacitText { width: 140; text: parent.modelData[0]; ink: "sec"; elide: Text.ElideMiddle }
                                TacitText { text: "→"; ink: "meta" }
                                TacitText { text: parent.modelData[1] }
                            }
                        }
                        Item { width: 1; height: 24 }
                        Row {
                            spacing: 20
                            Slab { text: "Rename"; tone: "default" }
                            WordAction { anchors.verticalCenter: parent.verticalCenter; text: "Cancel" }
                        }
                    }
                }
            }
        }
        // ---- page 12 (approved 2026-10-25): view controls, the kit's pattern for any app (Files here). MOCK_VC: rest | filter | active | sort | columns
        Item {
            id: vc
            visible: app.page === 12
            anchors.fill: parent
            readonly property string st: Quickshell.env("MOCK_VC") || "rest"
            readonly property bool rowShown: st === "filter" || st === "active"
            readonly property bool active: st === "active"
            readonly property var files: [
                ["picture", "", "p11", "ov02c10-capture.jpg", "", "640 kB", "11:20", 1],
                ["document", "picture_as_pdf", "", "Lease agreement.pdf", "docs.google.com", "2.2 MB", "Yesterday", 1],
                ["music", "music_note", "", "Undertow - Mara Velde.mp3", "bandcamp.com", "11.6 MB", "Yesterday", 1],
                ["picture", "", "p7", "IMG_2041.jpg", "", "3.1 MB", "Tuesday", 1],
                ["archive", "archive", "", "photos-october.zip", "drive.google.com", "420 MB", "Monday", 1],
                ["document", "description", "", "Invoice 2026-09.pdf", "mail", "180 kB", "29 Sep", 0],
                ["picture", "", "p13", "IMG_1988.jpg", "", "2.7 MB", "21 Sep", 0],
                ["document", "description", "", "notes-2026.md", "", "44 kB", "18 Sep", 0],
                ["disc", "deployed_code", "", "tacit-1.1.7-x86_64.iso", "download.tacitos.co", "2.9 GB", "14 Sep", 0]]
            readonly property var shown: active ? files.filter(f => (f[0] === "picture" || f[0] === "document") && f[7] === 1) : files

            Rail {
                height: parent.height
                RailRow { glyph: "schedule"; label: "Recent" }
                RailSection { text: "Places" }
                RailRow { glyph: "home"; label: "Home"; current: vc.st === "columns" }
                RailRow { glyph: "download"; label: "Downloads"; current: vc.st !== "columns" }
                RailRow { glyph: "description"; label: "Documents" }
                RailRow { glyph: "image"; label: "Pictures" }
            }
            Item {
                id: page12
                x: 300; width: parent.width - 300; height: parent.height
                PageHeader {
                    width: parent.width
                    crumbs: vc.st === "columns" ? [] : ["Home"]; here: vc.st === "columns" ? "Home" : "Downloads"
                    SearchField { anchors.verticalCenter: parent.verticalCenter; scope: vc.st === "columns" ? "Home" : "Downloads"; fieldWidth: 260 }
                }
                // the view bar (the kit's ViewBar, its FilterFields inside)
                ViewBar {
                    id: vbar
                    y: 73; width: parent.width
                    count: vc.st === "columns" ? "Documents › Taxes 2026, 3 items" : "9 items"
                    filtering: vc.rowShown
                    active: vc.active
                    shown: "3 of 9"
                    order: "Newest first"
                    views: ["List", "Grid", "Gallery", "Columns"]
                    view: vc.st === "columns" ? 3 : 0
                    FilterField { id: kindField; label: "Kind"; value: vc.active ? "Pictures, Documents" : "Any"; on: vc.active }
                    FilterField { label: "Modified"; value: vc.active ? "Last 7 days" : "Any time"; on: vc.active }
                    FilterField { label: "Size"; value: "Any" }
                }
                Item { id: sortBtn; width: 140 }
                // the list (or the columns)
                Column {
                    visible: vc.st !== "columns"
                    x: 12; y: 73 + vbar.height; width: parent.width - 24
                    SectionHeading { text: vc.active ? "This week" : "Today" }
                    Repeater {
                        model: vc.shown
                        ListRow {
                            required property var modelData
                            width: parent.width
                            glyph: modelData[1]; picture: modelData[2] !== "" ? app.pics + modelData[2] + ".jpg" : ""
                            name: modelData[3]; aside: modelData[4]; facts: [modelData[5], modelData[6]]; factWidths: [96, 96]
                        }
                    }
                }
                // hierarchy: one column per folder level, the selection's content at the end
                Row {
                    visible: vc.st === "columns"
                    y: 73 + 44; height: parent.height - 73 - 44
                    component Col: Item {
                        property var rows: []; property int chosen: -1; property bool last: false
                        width: 250; height: parent.height
                        Column {
                            x: 8; y: 8; width: parent.width - 16
                            Repeater {
                                model: parent.parent.rows
                                ListRow {
                                    required property var modelData
                                    required property int index
                                    width: parent.width
                                    glyph: modelData[0]; name: modelData[1]; facts: []
                                    selected: index === parent.parent.chosen
                                    Symbol { visible: modelData[0] === "folder"; anchors.right: parent.right; anchors.rightMargin: 10; anchors.verticalCenter: parent.verticalCenter; text: "chevron_right"; size: 18; color: Kit.tokens.inkMeta }
                                }
                            }
                        }
                        Rectangle { visible: !parent.last; anchors.right: parent.right; width: 1; height: parent.height; color: Kit.tokens.hairline }
                    }
                    Col { rows: [["folder", "Desktop"], ["folder", "Documents"], ["folder", "Downloads"], ["folder", "Music"], ["folder", "Pictures"], ["folder", "Videos"]]; chosen: 1 }
                    Col { rows: [["folder", "Contracts"], ["folder", "Taxes 2026"], ["description", "CV.pdf"], ["description", "notes-2026.md"]]; chosen: 1 }
                    Col { rows: [["picture_as_pdf", "Declaration.pdf"], ["picture_as_pdf", "Receipts.pdf"], ["description", "Summary.ods"]]; chosen: 0; last: true }
                }
                // the menus, drawn where they open
                MenuSurface {
                    visible: vc.st === "filter"
                    x: kindField.x + 16 + 34; y: 73 + 40
                    items: [{ heading: true, label: "Kind" },
                            { label: "Folders", detail: 0 }, { label: "Pictures", checked: true, detail: 3, keepOpen: true },
                            { label: "Documents", checked: true, detail: 3, keepOpen: true }, { label: "Music", detail: 1, keepOpen: true },
                            { label: "Archives", detail: 1, keepOpen: true }, { label: "Disc images", detail: 1, keepOpen: true },
                            { rule: true }, { label: "Any kind" }]
                    cursor: 4
                }
                MenuSurface {
                    visible: vc.st === "sort"
                    x: page12.width - 16 - 270 - 16 - sortBtn.width - 60; y: 73 + 40
                    items: [{ heading: true, label: "Sort by" }, { label: "Name" }, { label: "Kind" }, { label: "Date modified", checked: true },
                            { label: "Date added" }, { label: "Size" }, { rule: true },
                            { heading: true, label: "Order" }, { label: "Newest first", checked: true }, { label: "Oldest first" }, { rule: true },
                            { heading: true, label: "Group by" }, { label: "None" }, { label: "Date", checked: true }, { label: "Kind" }, { rule: true },
                            { label: "Show hidden files", detail: "Ctrl+H" }]
                    cursor: 13
                }
            }
        }
        // ---- page 13: the gaps closed (ListRow quiet / lead / accessory / picture fallback, RailRow, Rail foot, Field, Slab, IconButton)
        Item {
            visible: app.page === 13
            anchors.fill: parent
            Rail {
                height: parent.height
                foot: [ RailRow { glyph: "delete"; label: "Trash"; dropTarget: true } ]
                RailRow { glyph: "schedule"; label: "Recent" }
                RailSection { text: "Places" }
                RailRow { glyph: "home"; label: "Home"; current: true }
                RailRow { glyph: "download"; label: "Downloads"; attention: true; previewState: "hover" }
                RailRow { glyph: "description"; label: "Documents"; dropTarget: true }
                RailSection { text: "Drives" }
                RailRow { glyph: "usb"; label: "TRANSFER"; context: "41 GB free" }
                RailRow {
                    glyph: "usb"; label: "BACKUP"; context: "not shown"; previewState: "hover"
                    accessory: [ IconButton { symbol: "eject"; label: "Eject BACKUP"; size: Kit.tokens.icon.rail } ]
                }
            }
            Rail {
                x: 300; height: parent.height; folded: true
                foot: [ RailRow { glyph: "delete"; label: "Trash" } ]
                RailRow { glyph: "home"; label: "Home"; current: true }
                RailRow { glyph: "download"; label: "Downloads"; attention: true; previewState: "hover" }
            }
            Column {
                x: 380; y: 24; spacing: 8
                Head { text: "ListRow" }
                Repeater {
                    model: [
                        ["quiet (cut file)", { quiet: true, name: "Lease draft.pdf", aside: "cut", glyph: "description", facts: ["2.1 MB", "09:14"] }],
                        ["quiet, selected", { quiet: true, selected: true, name: "Lease draft.pdf", aside: "partial", glyph: "description", facts: ["2.1 MB", "09:14"] }],
                        ["picture fails", { picture: "file:///nonexistent.jpg", glyph: "image", name: "IMG_2041.jpg", facts: ["3.4 MB", "Mon"] }],
                        ["lead", { lead: "7", glyph: "music_note", name: "Undertow", aside: "Mara Velde", facts: ["4:12"] }],
                        ["lead, two digits", { lead: "12", glyph: "music_note", name: "Undertow", aside: "Mara Velde", facts: ["4:12"] }],
                        ["accessory", { name: "Undertow - Mara Velde.mp3", aside: "bandcamp.com", glyph: "music_note", facts: ["11.6 MB", "18:02"], withButton: true }],
                        ["accessory, tight", { w: 420, name: "A very long file name that does not fit in the row.pdf", glyph: "description", facts: ["11.6 MB", "18:02"], withButton: true }]
                    ]
                    Row {
                        required property var modelData
                        spacing: 16
                        Label { anchors.verticalCenter: parent.verticalCenter; text: parent.modelData[0]; width: 110 }
                        ListRow {
                            id: gapRow
                            width: parent.modelData[1].w ?? 480
                            Component.onCompleted: { const o = parent.modelData[1]; for (const k in o) if (k !== "w" && k !== "withButton") this[k] = o[k]; if (o.withButton) accessory = [ btn.createObject(gapRow) ]; }
                            Component { id: btn; IconButton { symbol: "star"; label: "Pin"; size: Kit.tokens.icon.rail } }
                        }
                    }
                }
                Item { width: 1; height: 6 }
                Head { text: "IconButton" }
                Row {
                    spacing: 16
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "off, on, over, key" }
                    IconButton { symbol: "list"; label: "List"; checkable: true }
                    IconButton { symbol: "list"; label: "List"; checked: true }
                    IconButton { symbol: "list"; label: "List"; checked: true; previewState: "hover" }
                    IconButton { symbol: "list"; label: "List"; checked: true; previewState: "focus" }
                }
            }
            Column {
                x: 1000; y: 20; spacing: 6
                Head { text: "Field" }
                Repeater {
                    model: [["error", { hint: "Name", error: true }], ["error, typed", { text: "a/b", error: true, previewState: "focus" }],
                            ["hint gone", { text: "IMG_20", hint: "Find" }], ["persistent", { text: "IMG_20", hint: ".jpg", persistentHint: true }],
                            ["persist, empty", { hint: "Find", persistentHint: true }]]
                    Row { required property var modelData; spacing: 12
                        Label { anchors.verticalCenter: parent.verticalCenter; text: parent.modelData[0]; width: 84 }
                        Rectangle {
                            width: 160; height: 52; radius: Kit.tokens.radius.slab; color: Kit.tokens.container
                            Field { anchors.centerIn: parent; width: 136; Component.onCompleted: { const o = parent.parent.modelData[1]; for (const k in o) this[k] = o[k]; } }
                        }
                    }
                }
                Item { width: 1; height: 6 }
                Head { text: "Slab" }
                Repeater {
                    model: [["waiting", { text: "Copying", waiting: true }], ["waiting, main", { text: "Copying", tone: "default", waiting: true }],
                            ["waiting, over", { text: "Copying", waiting: true, previewState: "hover" }],
                            ["max 120", { text: "Move to Documents/Leases", maxWidth: 120 }],
                            ["max 150 main", { text: "Move to Documents/Leases", tone: "default", maxWidth: 150 }],
                            ["max 150 risk", { text: "Delete everything", tone: "risk", maxWidth: 150 }]]
                    Row { required property var modelData; spacing: 12
                        Label { anchors.verticalCenter: parent.verticalCenter; text: parent.modelData[0]; width: 84 }
                        Slab { Component.onCompleted: { const o = parent.modelData[1]; for (const k in o) this[k] = o[k]; } }
                    }
                }
            }
        }
        // ---- page 14: the fixes after the docs review (accessible values, tip, PageHeader crumbs, ViewBar status line,
        // disabled RailRow and Field, Slider pressed, Menu headings, DockedPanel label)
        Item {
            visible: app.page === 14
            anchors.fill: parent
            Rail {
                height: parent.height
                RailRow { glyph: "home"; label: "Home"; current: true }
                RailRow { glyph: "download"; label: "Downloads"; context: "12" }
                RailSection { text: "Drives" }
                RailRow { glyph: "usb"; label: "TRANSFER"; context: "41 GB free" }
                RailRow { glyph: "usb"; label: "BACKUP"; context: "not here"; enabled: false }
                RailRow { glyph: "usb"; label: "BACKUP (hover tried)"; enabled: false; previewState: "hover" }
            }
            Column {
                x: 330; y: 8; spacing: 4
                Head { text: "PageHeader: parents are stops" }
                Row { spacing: 12
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "hover ink"; width: 70 }
                    PageHeader { width: 520; crumbs: ["Home", "Documents"]; here: "Leases"; previewState: "crumbHover" }
                }
                Row { spacing: 12
                    Label { anchors.verticalCenter: parent.verticalCenter; text: "key focus"; width: 70 }
                    PageHeader { width: 520; crumbs: ["Home", "Documents"]; here: "Leases"; previewState: "crumbFocus" }
                }
            }
            Column {
                x: 330; y: 232; spacing: 4
                Head { text: "ViewBar: status after the fields (fits, then wraps)" }
                ViewBar {
                    width: 940; filtering: true; active: true; shown: "3 of 9"; order: "Newest first"; views: ["List", "Grid"]
                    FilterField { label: "Kind"; value: "Pictures"; on: true }
                    FilterField { label: "Size"; value: "Any" }
                }
                ViewBar {
                    width: 940; filtering: true; active: true; shown: "3 of 9"; order: "Newest first"; views: ["List", "Grid", "Gallery", "Columns"]
                    FilterField { label: "Kind"; value: "Pictures, Documents"; on: true }
                    FilterField { label: "Modified"; value: "Last 7 days"; on: true }
                    FilterField { label: "Size"; value: "Any" }
                }
            }
            Column {
                x: 330; y: 480; spacing: 8
                Head { text: "IconButton tip (key focus)" }
                Item { width: 150; height: 70
                    IconButton { id: tipBtn; symbol: "left_panel_close"; label: "Fold the places"; tip: "Fold the places"; previewState: "focus" }
                    // the real tooltip is a popup, outside this grab: drawn in place; tipShown says the real one is on
                    TooltipSurface { y: tipBtn.height + 8; text: "Fold the places" }
                }
                Text { color: Kit.tokens.inkSec; font.family: Kit.tokens.font.main; font.pixelSize: Kit.tokens.size.meta
                    text: "tipShown: " + tipBtn.tipShown }
            }
            Column {
                x: 600; y: 480; spacing: 8
                Head { text: "Menu headings" }
                MenuSurface {
                    items: [{ heading: true, label: "Sort by" }, { label: "Name", checked: true }, { label: "Date" }, { rule: true },
                            { heading: true, label: "Group by" }, { label: "Kind", detail: "3" }, { label: "None" }]
                }
            }
            Column {
                x: 830; y: 480; spacing: 6
                Head { text: "Accessible values" }
                Text { color: Kit.tokens.inkSec; font.family: Kit.tokens.font.main; font.pixelSize: Kit.tokens.size.meta
                    text: "Progress: value " + pg.value + ", min " + pg.minimumValue + ", max " + pg.maximumValue }
                Progress { id: pg; width: 300; value: 0.25; label: "Copying" }
                Text { color: Kit.tokens.inkSec; font.family: Kit.tokens.font.main; font.pixelSize: Kit.tokens.size.meta
                    text: "Waveform: value " + wv.value + ", step " + wv.stepSize }
                Waveform { id: wv; width: 300; height: 20; peaks: P.peaks; position: 0.4 }
                Text { color: Kit.tokens.inkSec; font.family: Kit.tokens.font.main; font.pixelSize: Kit.tokens.size.meta
                    text: "Slider: step " + sl.stepSize + ", min " + sl.minimumValue + ", max " + sl.maximumValue + "; DockedPanel label: " + dp.label }
                Slider { id: sl; width: 300; value: 0.3; label: "Volume" }
                DockedPanel { id: dp; label: "Details" }
            }
            Column {
                x: 880; y: 8; spacing: 8
                Head { text: "Field, disabled" }
                Rectangle {
                    width: 270; height: 112; radius: Kit.tokens.radius.slab; color: Kit.tokens.container
                    Column { anchors.centerIn: parent; spacing: 8
                        Field { width: 236; hint: "Name"; enabled: false }
                        Field { width: 236; text: "Lease draft"; enabled: false }
                    }
                }
                Head { text: "Slider, pressed" }
                Slider { width: 270; value: 0.5; word: "50 %"; label: "Volume"; previewState: "hover" }
                Slider { width: 270; value: 0.5; word: "50 %"; label: "Volume"; previewState: "pressed" }
            }
        }
        // ---- page 11: editing rows, confirming actions, Notice, ScrollBar, WindowGround
        Item {
            visible: app.page === 11
            anchors.fill: parent
            component Pane: Item {
                id: pane
                property alias label: cap.text
                default property alias stuff: inner.data
                width: 400; height: 300
                Label { id: cap; width: pane.width }
                Item { id: inner; y: 22; width: pane.width; height: pane.height - 22; clip: true }
            }
            component Head11: Text { color: Kit.tokens.inkMain; font.family: Kit.tokens.font.display; font.pixelSize: Kit.tokens.size.section; font.weight: Font.DemiBold }
            component PageRows: Column {
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 0 }
                Repeater {
                    model: ["Undertow - Mara Velde.mp3", "Lease draft.pdf", "Photos October.zip", "notes-2026.md", "Receipts.pdf"]
                    ListRow { required property string modelData; width: parent.width; glyph: "description"; name: modelData; facts: ["2.1 MB", "09:14"] }
                }
            }
            Row {
                x: 24; y: 16; spacing: 24
                Pane { label: "Row editing: rename (the stem chosen)"; width: 620; height: 240
                    WindowGround { radius: Kit.tokens.radius.panel }
                    Column { width: parent.width
                        Repeater {
                            model: [["Undertow - Mara Velde.mp3", "2.1 MB"], ["Budget 2027.xlsx", "84 kB"], ["Photos October.zip", "420 MB"], ["notes-2026.md", "6 kB"], ["Receipts.pdf", "1.1 MB"]]
                            ListRow { required property var modelData; required property int index
                                width: parent.width; glyph: "description"; name: modelData[0]; facts: [modelData[1], "09:14"]
                                selected: index === 1; previewState: index === 1 ? "editing" : "" }
                        }
                    }
                }
                Pane { label: "Row editing: a new folder (all of it chosen), a long name"; width: 620; height: 240
                    WindowGround { radius: Kit.tokens.radius.panel }
                    Column { width: parent.width
                        Repeater {
                            model: [["folder", "Untitled folder", "Empty"], ["description", "Lease draft.pdf", "2.1 MB"], ["description", "Photos October, the long weekend by the lake with everyone.zip", "2.1 MB"], ["description", "notes-2026.md", "6 kB"], ["description", "Receipts.pdf", "1.1 MB"]]
                            ListRow { required property var modelData; required property int index
                                width: parent.width; glyph: modelData[0]; name: modelData[1]; facts: [modelData[2], "09:14"]
                                editAll: index === 0; selected: index === 0 || index === 2; previewState: index === 0 || index === 2 ? "editing" : "" }
                        }
                    }
                }
            }
            Grid {
                x: 24; y: 270; columns: 2; columnSpacing: 40; rowSpacing: 14
                Repeater {
                    model: [["Slab, rest", "default", ""], ["Slab, confirming", "default", "confirming"],
                            ["Slab (risk), rest", "risk", ""], ["Slab (risk), confirming", "risk", "confirming"]]
                    Column { required property var modelData; spacing: 6; width: 290
                        Label { text: parent.modelData[0] }
                        Slab { text: "Empty trash"; confirm: "Delete 12 files for good"; tone: parent.modelData[1]; previewState: parent.modelData[2] }
                    }
                }
                Repeater {
                    model: [["WordAction, rest", ""], ["WordAction, confirming", "confirming"]]
                    Column { required property var modelData; spacing: 6; width: 290
                        Label { text: parent.modelData[0] }
                        WordAction { width: 260; text: "Empty trash"; confirm: "Delete 12 files for good"; previewState: parent.modelData[1] }
                    }
                }
            }
            Column {
                x: 668; y: 270; spacing: 2
                Head11 { text: "Notice" }
                Repeater {
                    model: [["undo", { text: "Moved 3 files to Documents", actionWords: "Undo", previewState: "shown" }],
                            ["undo, pointer on it", { text: "Moved 3 files to Documents", actionWords: "Undo", previewState: "held" }],
                            ["undo, key focus", { text: "Moved 3 files to Documents", actionWords: "Undo", previewState: "focus" }],
                            ["no action", { text: "Copied to the clipboard", previewState: "shown" }],
                            ["long line", { text: "Moved 3 files from Downloads/Photos October to Documents/Leases/2026 and renamed two of them", actionWords: "Undo", previewState: "shown" }]]
                    Row { required property var modelData; spacing: 12
                        Label { anchors.verticalCenter: parent.verticalCenter; text: parent.modelData[0]; width: 110 }
                        Item { width: 480; height: 46
                            Notice { Component.onCompleted: { const o = parent.parent.modelData[1]; for (const k in o) this[k] = o[k]; } }
                        }
                    }
                }
            }
            Row {
                x: 24; y: 556; spacing: 24
                Repeater {
                    model: [["bar: moving", "moving"], ["bar: pointer near the edge", "near"], ["bar: dragged", "dragging"], ["bar: at rest (hidden)", ""]]
                    Pane {
                        required property var modelData
                        label: modelData[0]; width: 180; height: 190
                        Flickable {
                            id: fl
                            anchors.fill: parent; contentHeight: 600; clip: true; contentY: modelData[1] === "dragging" ? 140 : 60
                            Column { width: parent.width; Repeater { model: 14; ListRow { width: fl.width; glyph: "description"; name: "Row " + (index + 1); facts: [] } } }
                        }
                        ScrollBar { view: fl; anchors.fill: fl; previewState: modelData[1] }
                    }
                }
            }
        }
        // ---- page 3: the kit's text against the shell's, the same words, for weight
        Column {
            visible: app.page === 3
            x: 40; y: 40; spacing: 10
            Label { text: "kit TacitText (row, regular / medium / strong)" }
            TacitText { text: "Undertow - Mara Velde.mp3 11.6 MB 18:02" }
            TacitText { text: "Undertow - Mara Velde.mp3 11.6 MB 18:02"; weight: "medium" }
            TacitText { text: "Undertow - Mara Velde.mp3 11.6 MB 18:02"; weight: "strong" }
            Label { text: "shell StyledText (row, Normal / Medium / DemiBold)" }
            StyledText { text: "Undertow - Mara Velde.mp3 11.6 MB 18:02"; color: Tacit.inkMain; font.pixelSize: Tacit.size.row }
            StyledText { text: "Undertow - Mara Velde.mp3 11.6 MB 18:02"; color: Tacit.inkMain; font.pixelSize: Tacit.size.row; font.weight: Font.Medium }
            StyledText { text: "Undertow - Mara Velde.mp3 11.6 MB 18:02"; color: Tacit.inkMain; font.pixelSize: Tacit.size.row; font.weight: Font.DemiBold }
        }
        // ---- page 20: Check, Choices
        Row {
            visible: app.page === 20
            x: 40; y: 32; spacing: 64
            component Head2: Text { color: Kit.tokens.inkMain; font.family: Kit.tokens.font.display; font.pixelSize: Kit.tokens.size.section; font.weight: Font.DemiBold }
            Column {
                spacing: 12
                Head2 { text: "Check" }
                Repeater {
                    model: [["off", {}], ["on", { checked: true }], ["mixed", { mixed: true }], ["off, pointer over", { previewState: "hover" }],
                            ["on, keyboard", { checked: true, previewState: "focus" }], ["off, keyboard", { previewState: "focus" }],
                            ["mixed, keyboard", { mixed: true, previewState: "focus" }],
                            ["off, unavailable", { enabled: false }], ["on, unavailable", { checked: true, enabled: false }]]
                    Row { required property var modelData; spacing: 16
                        Label { anchors.verticalCenter: parent.verticalCenter; text: parent.modelData[0]; width: 120 }
                        Check { label: "Show hidden files"; Component.onCompleted: { const o = parent.modelData[1]; for (const k in o) this[k] = o[k]; } }
                    }
                }
                Item { width: 1; height: 8 }
                Head2 { text: "Choices, unavailable" }
                Choices { current: 1; enabled: false; model: ["Name", "Date modified", "Size"] }
            }
            Column {
                spacing: 12
                Head2 { text: "Choices" }
                Repeater {
                    model: [["rest", { current: 1 }], ["pointer over", { current: 0, previewState: "hover" }], ["keyboard", { current: 1, previewState: "focus" }]]
                    Row { required property var modelData; spacing: 16
                        Label { text: parent.modelData[0]; width: 120 }
                        Choices { model: ["Name", "Date modified", "Size"]; Component.onCompleted: { const o = parent.modelData[1]; for (const k in o) this[k] = o[k]; } }
                    }
                }
                Head2 { text: "Choices, with details" }
                Choices { current: 0; previewState: "focus"
                    model: [{ label: "Ask every time", detail: "Files asks where each download goes" },
                            { label: "Downloads", detail: "Everything lands in your Downloads folder" },
                            { label: "Transfer drive", detail: "Not here" }] }
            }
        }
        // ---- page 21: Select, TextArea
        Row {
            visible: app.page === 21
            x: 40; y: 32; spacing: 64
            Column {
                spacing: 12
                Head2 { text: "Select" }
                Repeater {
                    model: [["rest", { current: 1 }], ["pointer over", { current: 1, previewState: "hover" }], ["keyboard", { current: 1, previewState: "focus" }],
                            ["nothing chosen", { current: -1 }], ["unavailable", { current: 1, enabled: false }]]
                    Row { required property var modelData; spacing: 16
                        Label { anchors.verticalCenter: parent.verticalCenter; text: parent.modelData[0]; width: 100 }
                        Rectangle {
                            width: 260; height: 52; radius: Kit.tokens.radius.slab; color: Kit.tokens.container
                            Select { anchors.centerIn: parent; width: 236; options: ["Newest first", "Oldest first", "Name", "Size"]; hint: "Sort by"
                                Component.onCompleted: { const o = parent.parent.modelData[1]; for (const k in o) this[k] = o[k]; } }
                        }
                    }
                }
                Row { spacing: 16
                    Label { text: "open (the menu)"; width: 100 }
                    MenuSurface { items: [{ label: "Newest first" }, { label: "Oldest first", checked: true }, { label: "Name" }, { label: "Size" }]; cursor: 1 }
                }
            }
            Column {
                spacing: 12
                Head2 { text: "TextArea" }
                Repeater {
                    model: [["empty", { hint: "Describe the problem" }], ["pointer over", { hint: "Describe the problem", previewState: "hover" }],
                            ["typing", { text: "Rename the 14 photos from the trip to the date they were taken, then move them to Pictures.", previewState: "focus" }],
                            ["longer than max (scrolls)", { maxLines: 3, previewState: "focus", text: "One line\nTwo lines\nThree lines\nFour lines\nFive lines" }],
                            ["error", { text: "Too short", error: true }],
                            ["unavailable", { text: "Locked while sending", enabled: false }]]
                    Column { required property var modelData; spacing: 4
                        Label { text: parent.modelData[0]; width: 200 }
                        Rectangle {
                            width: 380; height: ta.height + 16; radius: Kit.tokens.radius.slab; color: Kit.tokens.container
                            TextArea { id: ta; x: 8; y: 8; width: 364; minLines: 2; maxLines: 4
                                Component.onCompleted: { const o = parent.parent.modelData[1]; for (const k in o) this[k] = o[k]; } }
                        }
                    }
                }
            }
        }
    }
    Timer {
        interval: 2500; running: true
        onTriggered: shot.grabToImage(g => { g.saveToFile(Quickshell.env("CATALOGUE_OUT") + "-" + app.page + ".png"); Qt.quit(); })
    }
}
