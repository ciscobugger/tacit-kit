// Menu page figures: a sort menu open under its button in a window, the pieces, the line states, the measures and a guideline.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 400], ["anatomy", 760, 300], ["states", 760, 300], ["sizes", 760, 400],
              ["do-risk-last", 418, 220], ["dont-risk-middle", 418, 220]]
    readonly property var t: Kit.tokens
    component F: Item {
        property string n
        visible: app.fig === n
        anchors.fill: parent
        DocGlass { anchors.fill: parent }
    }
    readonly property var sortItems: [{ heading: true, label: "Sort by" }, { label: "Newest first", checked: true }, { label: "Oldest first" },
        { label: "Name" }, { rule: true }, { heading: true, label: "Show" }, { label: "Hidden files", keepOpen: true }]
    readonly property var fileItems: [{ label: "Open", detail: "Enter" }, { label: "Rename", detail: "F2" }, { rule: true },
        { label: "Move to the trash", risk: true }]

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader { width: hw.shown; crumbs: ["Files"]; here: "Downloads" }
        Column {
            x: 12; y: 80; width: hw.shown - 36
            Item {
                width: parent.width; height: 44
                MenuButton { anchors.right: parent.right; anchors.rightMargin: 6; anchors.verticalCenter: parent.verticalCenter; text: "Newest first"; previewState: "hover" }
            }
            SectionHeading { text: "Today" }
            ListRow { width: parent.width; glyph: "music_note"; name: "Undertow - Mara Velde.mp3"; aside: "bandcamp.com"; facts: ["11.6 MB", "18:02"] }
            ListRow { width: parent.width; glyph: "deployed_code"; name: "tacit-1.1.7-x86_64.iso"; aside: "download.tacitos.co"; facts: ["2.9 GB", "16:15"] }
            ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; aside: "docs.google.com"; facts: ["2.2 MB", "14:40"] }
        }
        MenuSurface { id: heroMenu; items: app.sortItems; cursor: 2; x: hw.shown - 12 - width - 6; y: 80 + 44 + 2 }
    }

    F { n: "anatomy"
        // the pieces' sizes, measured as MenuSurface sets them
        TacitText { id: mHead; visible: false; text: "Sort by"; size: "meta"; weight: "medium" }
        TacitText { id: mDetail; visible: false; text: "A to Z"; size: "meta"; cut: "numbers" }
        Item {
            id: an
            readonly property real k: 1.4
            // lines: 4 in, a heading 28 high, two lines 34, a rule 9, a line 34
            readonly property real lw: ms.lineWidth
            x: (parent.width - ms.width * k) / 2; y: (parent.height - ms.height * k) / 2; width: ms.width * k; height: ms.height * k
            MenuSurface {
                id: ms
                items: [{ heading: true, label: "Sort by" }, { label: "Newest first", checked: true }, { label: "Name", detail: "A to Z" },
                        { rule: true }, { label: "Delete", risk: true }]
                cursor: 2
                transformOrigin: Item.TopLeft; scale: an.k
            }
            DocCallout { n: 1; side: "left"; line: -34
                         rect: Qt.rect(16 * an.k, (18 + 2) * an.k - mHead.implicitHeight * an.k / 2, mHead.implicitWidth * an.k, mHead.implicitHeight * an.k) }
            DocCallout { n: 2; side: "left"; line: -34; rect: Qt.rect(14 * an.k, (49 - 8) * an.k, 16 * an.k, 16 * an.k) }
            DocCallout { n: 3; side: "left"; line: -34; surface: true; rect: Qt.rect(4 * an.k, 66 * an.k, an.lw * an.k, 34 * an.k) }
            DocCallout { n: 6; side: "left"; line: -34; rect: Qt.rect(14 * an.k, (126 - 8) * an.k, 16 * an.k, 16 * an.k) }
            DocCallout { n: 4; side: "right"; line: an.width + 34
                         rect: Qt.rect((ms.width - 12 - mDetail.implicitWidth) * an.k, 83 * an.k - mDetail.implicitHeight * an.k / 2, mDetail.implicitWidth * an.k, mDetail.implicitHeight * an.k) }
            DocCallout { n: 5; side: "right"; line: an.width + 34; surface: true; rect: Qt.rect(16 * an.k, 104 * an.k, (an.lw - 24) * an.k, an.k) }
        }
    }

    F { n: "states"
        Repeater {
            model: [-1, 1, -2]
            DocCol {
                id: col
                required property int modelData
                required property int index
                slot: index; count: 3
                MenuSurface {
                    anchors.centerIn: parent
                    items: [{ label: "Newest first", checked: col.modelData === -2 }, { label: "Oldest first" }, { label: "Name" }]
                    cursor: col.modelData === 1 ? 1 : -1
                }
            }
        }
    }

    F { n: "sizes"
        Item {
            id: sz
            readonly property real k: 2
            // the menu, its vertical dimension lines on the left (number and tick 49 px) and its horizontal ones below (40 px)
            x: (parent.width - sm.width * k + 49) / 2; y: (parent.height - sm.height * k - 40) / 2
            MenuSurface {
                id: sm
                items: [{ heading: true, label: "Sort by" }, { label: "Newest first", checked: true, detail: "Ctrl N" }, { rule: true }, { label: "Name" }]
                cursor: 1
                transformOrigin: Item.TopLeft; scale: sz.k
            }
            // vertical: 28 for the group name, 34 for a line, 9 for the rule
            DocDim { vertical: true; from: 4 * sz.k; to: 32 * sz.k; at: -24; n: "28" }
            DocDim { vertical: true; from: 32 * sz.k; to: 66 * sz.k; at: -24; n: "34" }
            DocDim { vertical: true; from: 66 * sz.k; to: 75 * sz.k; at: -24; n: "9" }
            // horizontal: 14 to the tick, 16 for the tick
            DocDim { from: 0; to: 14 * sz.k; at: sm.height * sz.k + 16; n: "14" }
            DocDim { from: 14 * sz.k; to: 30 * sz.k; at: sm.height * sz.k + 16; n: "16" }
        }
    }

    F { n: "do-risk-last"
        MenuSurface { anchors.centerIn: parent; items: app.fileItems; cursor: 1 }
    }
    F { n: "dont-risk-middle"
        MenuSurface { anchors.centerIn: parent; items: [{ label: "Open", detail: "Enter" }, { label: "Move to the trash", risk: true }, { label: "Rename", detail: "F2" }, { rule: true }, { label: "Share" }]; cursor: 1 }
    }
}
