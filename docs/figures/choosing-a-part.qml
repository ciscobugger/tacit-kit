// Choosing a part page's figure: one app window made of kit parts, six of them called out. The page's own table says
// which part does which job; the figure shows where they sit in a window.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["overview", 760, 400]]
    readonly property var t: Kit.tokens
    readonly property var orderItems: [{ label: "Newest first", checked: true }, { label: "Oldest first" }, { label: "Name" }]

    DocGlass { anchors.fill: parent }

    Item {
        id: win
        x: 80; y: 74; width: 600; height: 290
        // the window: its ground, a faint edge
        WindowGround { }
        Rectangle { anchors.fill: parent; radius: Kit.tokens.radius.window; color: "transparent"; border.width: 1; border.color: Qt.alpha(Kit.tokens.inkMain, 0.12) }
        Item {
            anchors.fill: parent
            Rail {
                id: rail
                folded: true; height: parent.height
                RailRow { glyph: "schedule"; label: "Recent" }
                RailRow { glyph: "home"; label: "Home" }
                RailRow { glyph: "download"; label: "Downloads"; current: true }
                RailRow { glyph: "image"; label: "Pictures" }
            }
            PageHeader {
                id: head
                x: 56; width: parent.width - 56; crumbs: []; here: "Downloads"
                SearchField { id: sf; anchors.verticalCenter: parent.verticalCenter; scope: "Downloads"; fieldWidth: 240 }
            }
            ViewBar { id: vb; x: 56; y: 73; width: parent.width - 56; count: "9 items"; order: "Newest first"; views: ["List", "Grid"]; orderItems: app.orderItems }
            Column {
                id: list
                x: 56 + 12; y: 73 + 44 + 4; width: parent.width - 56 - 36
                ListRow { width: parent.width; focusable: false; picture: app.pics + "p11.jpg"; name: "ov02c10-capture.png"; facts: ["640 kB", "11:20"] }
                ListRow { width: parent.width; focusable: false; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; aside: "docs.google.com"; facts: ["2.2 MB", "14:40"]; selected: true }
            }
            Notice { id: note; previewState: "shown"; text: "Moved 2 files to Documents"; actionWords: "Undo" }
        }
        property rect sfRect
        property rect noteRect
        Timer { interval: 300; running: true
            onTriggered: {
                const a = sf.mapToItem(win, 0, 0), n = note.mapToItem(win, 0, 0);
                win.sfRect = Qt.rect(a.x, a.y, sf.width, sf.height);
                win.noteRect = Qt.rect(n.x, n.y, note.width, note.height);
            }
        }
        readonly property real topLine: -22

        // 1 the rail on the left, 2 the header and 3 the search above, 4 the bar and 5 the list on the right, 6 the notice below
        DocCallout { n: 1; side: "left"; line: -40; rect: Qt.rect(4, 54, 48, 176) }
        DocCallout { n: 2; side: "top"; line: win.topLine; rect: Qt.rect(70, 12, 235, 48) }
        DocCallout { n: 3; side: "top"; line: win.topLine; visible: win.sfRect.width > 0; rect: win.sfRect }
        DocCallout { n: 4; side: "right"; line: win.width + 40; rect: Qt.rect(60, 73 + 2, win.width - 60 - 4, 40) }
        DocCallout { n: 5; side: "right"; line: win.width + 40; rect: Qt.rect(60 + 8, 73 + 44 + 4, win.width - 60 - 28, 2 * 44) }
        DocCallout { n: 6; side: "right"; line: win.width + 40; visible: win.noteRect.width > 0; rect: win.noteRect }
    }
}
