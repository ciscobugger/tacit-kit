// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick
import QtQuick.Effects

// Square covers in even columns, each with a title in the main ink and a subtitle in the secondary ink under it (albums,
// playlists, books). A sibling of PictureGrid, not a mode of it: PictureGrid sets pictures of any shape in rows that fill
// the width, with no words; this sets one shape in columns, with words, and keeps its covers' edges 24 px apart.
// A cover aims at `cover` wide; the columns widen it to fill the row. The selection is the cursor: a wash over the cover (the pressed amount, 22 %), and while the keyboard has the grid the focus ring 4 px
// outside it. `label` names the grid for a screen reader ("Covers"). One tab stop: ← → step, ↑ ↓ go a row, Home End, Enter opens; click selects, double-click opens,
// right-click or the Menu key asks for a menu. The pointer is a wash on the cover; the focus ring shows only after a key.
// `items`: [{ source, title, subtitle, current }], in order. `current` puts the accent mark before the title (what is
// playing); `glyph` is the symbol on a cover that has no picture or cannot load it. Only the rows on screen are made.
FocusScope {
    id: grid

    property var items: []
    property int cursor: -1
    property string glyph: "image"
    property string label: "Covers"
    property int previewHover: -1        // a cover shown under the pointer, for the catalogue and the docs
    readonly property int cover: 180
    readonly property int gap: Kit.tokens.space.xl
    readonly property int columns: Math.max(1, Math.floor((width + gap) / (cover + gap)))
    readonly property real cell: (width + gap) / columns
    readonly property int ringRoom: 6    // the ring reaches 4 px past a cover, 2 px wide
    readonly property int count: items.length

    signal activated(int index)
    signal contextRequested(int index, point at)

    function moveTo(i) {
        if (count === 0) return;
        cursor = Math.max(0, Math.min(count - 1, i));
        view.positionViewAtIndex(cursor, GridView.Contain);
    }

    implicitWidth: 900
    implicitHeight: 600
    activeFocusOnTab: true
    onActiveFocusChanged: if (activeFocus && cursor < 0) moveTo(0)
    onItemsChanged: if (cursor >= count) cursor = count - 1   // fewer covers than before: keep the cursor on one that is there
    Accessible.role: Accessible.List
    Accessible.name: label
    Keys.onPressed: event => {
        const by = { [Qt.Key_Left]: -1, [Qt.Key_Right]: 1, [Qt.Key_Up]: -columns, [Qt.Key_Down]: columns }[event.key];
        Kit.focusVisible = true;
        if (by !== undefined) moveTo(cursor + by);
        else if (event.key === Qt.Key_Home) moveTo(0);
        else if (event.key === Qt.Key_End) moveTo(count - 1);
        else if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && cursor >= 0) activated(cursor);
        else if (event.key === Qt.Key_Menu && cursor >= 0) contextRequested(cursor, Qt.point(width / 2, 0));
        else return;
        event.accepted = true;
    }

    GridView {
        id: view
        // GridView counts columns over its width less the margins, so the right side reaches one gap further
        anchors { fill: parent; margins: -grid.ringRoom; rightMargin: -grid.gap - grid.ringRoom }
        leftMargin: grid.ringRoom; rightMargin: grid.ringRoom; topMargin: grid.ringRoom; bottomMargin: grid.ringRoom
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        cellWidth: grid.cell
        cellHeight: grid.cell + 2 * Kit.tokens.space.xl     // the cover, its two lines of words, and a gap
        model: grid.items

        delegate: Item {
            id: tile
            required property var modelData
            required property int index
            readonly property bool chosen: grid.cursor === index
            readonly property bool hovered: hover.hovered || grid.previewHover === index
            readonly property real side: grid.cell - grid.gap
            readonly property real corner: Kit.tokens.radius.slab

            width: grid.cell
            height: view.cellHeight
            Accessible.role: Accessible.ListItem
            Accessible.name: (modelData.title ?? "") + ((modelData.subtitle ?? "") === "" ? "" : ", " + modelData.subtitle)
            Accessible.description: tile.modelData.current === true ? "Playing" : ""
            Accessible.selected: tile.chosen

            Image {
                id: pic
                visible: false
                width: tile.side; height: tile.side
                source: tile.modelData.source ?? ""
                sourceSize: Qt.size(tile.side * 2, tile.side * 2)
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }
            Rectangle { id: mask; visible: false; width: tile.side; height: tile.side; radius: tile.corner; layer.enabled: true }
            MultiEffect {
                width: tile.side; height: tile.side
                visible: pic.status === Image.Ready
                source: pic
                maskEnabled: true
                maskSource: mask
            }
            Rectangle {
                width: tile.side; height: tile.side
                visible: pic.status !== Image.Ready
                radius: tile.corner
                color: Kit.tokens.container
                Symbol {
                    anchors.centerIn: parent
                    text: grid.glyph
                    size: Math.round(tile.side / 3)
                }
            }
            Rectangle {
                width: tile.side; height: tile.side
                radius: tile.corner
                color: Kit.tokens.inkMain
                opacity: tap.pressed ? Kit.tokens.wash.pressed
                            : tile.chosen ? Kit.tokens.wash.pressed
                            : tile.hovered ? Kit.tokens.wash.hover : 0
                Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
            }
            Item {
                width: tile.side; height: tile.side
                FocusRing { shown: tile.chosen && grid.activeFocus && Kit.focusVisible; corner: tile.corner }
            }
            Symbol {
                id: mark
                visible: tile.modelData.current === true
                y: tile.side + Kit.tokens.space.m
                text: "graphic_eq"
                color: Kit.tokens.accent
            }
            TacitText {
                x: mark.visible ? mark.width + Kit.tokens.space.s : 0
                y: mark.y
                width: tile.side - x
                text: tile.modelData.title ?? ""
                weight: "medium"
                elide: Text.ElideRight
            }
            TacitText {
                y: mark.y + mark.height + Kit.tokens.space.xs
                width: tile.side
                text: tile.modelData.subtitle ?? ""
                ink: "sec"; size: "fileText"
                elide: Text.ElideRight
            }
            HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
            TapHandler {
                id: tap
                onTapped: { grid.forceActiveFocus(Qt.MouseFocusReason); Kit.focusVisible = false; grid.cursor = tile.index; }
                onDoubleTapped: grid.activated(tile.index)
            }
            TapHandler {
                acceptedButtons: Qt.RightButton
                onTapped: point => {
                    grid.cursor = tile.index;
                    grid.contextRequested(tile.index, point.position);
                }
            }
        }
    }
    Glide { view: view }
}
