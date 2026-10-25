import QtQuick
import Quickshell
import Tacit.Kit

FloatingWindow {
    id: window
    title: "Downloads"
    implicitWidth: 880
    implicitHeight: 480
    color: "transparent"

    readonly property var files: [
        {
            name: "Undertow - Mara Velde.mp3", kind: "music_note", from: "bandcamp.com",
            size: "11.6 MB", when: "18:02"
        },
        {
            name: "tacit-1.1.7-x86_64.iso", kind: "deployed_code", from: "download.tacitos.co",
            size: "2.9 GB", when: "16:15"
        },
        {
            name: "Lease agreement.pdf", kind: "picture_as_pdf", from: "docs.google.com",
            size: "2.2 MB", when: "14:40"
        },
        {
            name: "Budget 2027.xlsx", kind: "description", from: "google.com",
            size: "84 kB", when: "09:12"
        },
        {
            name: "photos-october.zip", kind: "deployed_code", from: "google.com",
            size: "420 MB", when: "08:31"
        }
    ]
    readonly property var shown: files.filter(
        f => f.name.toLowerCase().includes(search.text.toLowerCase()))

    // the window's ground, at the see-through the user has set; the compositor rounds the window itself
    WindowGround { radius: 0 }

    PageHeader {
        id: header
        width: parent.width
        crumbs: ["Files"]
        here: "Downloads"
        canGoBack: false
        SearchField {
            id: search
            anchors.verticalCenter: parent.verticalCenter
            scope: "Downloads"
            onDown: list.forceActiveFocus()
            onDismissed: list.forceActiveFocus()
        }
    }

    RowList {
        id: list
        anchors {
            top: header.bottom; topMargin: Kit.tokens.space.m
            left: parent.left; leftMargin: Kit.tokens.space.m
            right: panel.left; rightMargin: Kit.tokens.space.m
            bottom: parent.bottom
        }
        label: "Downloads"
        model: window.shown
        delegate: ListRow {
            required property var modelData
            required property int index
            width: list.rowWidth
            focusable: false
            glyph: modelData.kind
            name: modelData.name
            aside: modelData.from
            facts: [modelData.size, modelData.when]
            selected: list.isSelected(index)
            ring: list.ringAt(index)
            onClicked: m => list.clickAt(index, m)
            onActivated: list.activated(index)
        }
        // Space shows the selection in the panel and hides it again; Enter would open the file
        onPeeked: panel.open = !panel.open
        Component.onCompleted: forceActiveFocus()
    }

    DockedPanel {
        id: panel
        label: "Details"
        Keys.onEscapePressed: open = false      // from anywhere inside the panel
        anchors.right: parent.right
        y: header.height
        height: parent.height - header.height - Kit.tokens.space.xl
        Column {
            x: Kit.tokens.space.xl
            y: Kit.tokens.space.xl
            width: Kit.tokens.width.panel - 2 * Kit.tokens.space.xl
            TacitText {
                width: parent.width
                text: window.shown[list.cursor]?.name ?? ""
                size: "body"
                weight: "medium"
                wrapMode: Text.Wrap
            }
            Item { width: 1; height: Kit.tokens.space.xl }
            Slab { text: "Open"; tone: "default" }
            Item { width: 1; height: Kit.tokens.space.l }
            WordAction { text: "Open with…" }
            WordAction { text: "Move to the trash"; risk: true }
        }
    }
}
