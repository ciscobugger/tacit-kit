// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick
import QtQuick.Effects

// One thing in a list: its kind (a symbol, or a small picture), its name, a name beside it (where it came from, who
// made it), and its facts on the right (size, time, length). 44 high. One selection signal, the wash; hover and press
// are lighter and stronger washes; the keyboard focus ring shows only after a key.
//
// `quiet` is a cut file or a partial download: the name, the name beside it, the facts and the kind symbol move to the
// quiet ink (never opacity); the wash is unchanged. A picture that fails to load falls back to the glyph. `lead` is a
// short string before the name in the meta ink with tabular figures (a track number); the name moves right by its
// width. `leadFigures` holds that room for that many figures (a ten-track album sets 2): the lead is right-aligned in
// it, so 1 and 10 end in one column, and the name starts at the same place whether or not a row has a lead.
// `accessory` takes items (a button, a mark) drawn just before the facts; the name's room shrinks to leave
// space for them.
//
// `editing` turns the name into a line to type in, where the name is: the text does not move. A box 32 high with the
// row's corner, the window's ground as its fill and a 2 px accent ring holds it (it grows with the text, as far as the
// facts), and the stem is chosen (up to the last dot, so "Budget 2027" of "Budget 2027.xlsx"; all of it with `editAll`
// or when there is no dot). The aside hides meanwhile; the kind and the facts stay. Enter, or the keyboard leaving,
// says `renamed(text)` when the text changed and is not empty, else `editCancelled()`; Esc says `editCancelled()`.
// `fresh` is a row the app has just added (a new folder): Enter keeps the name as it stands, so it says `renamed`
// even when unchanged. The app sets `editing` back to false when it hears either signal. Enter and Esc give the
// keyboard back to what had it; a RowList's keys do not act on the row while it edits. A screen reader finds an
// editable text named `label`, or "Name". The app starts it from RowList's `editRequested` (F2) or its own button.
//
// clicked: a single press (select). activated: a double click, Enter or Space (open). contextRequested: a right click
// or the Menu key, at a point in the row.
FocusScope {
    id: row

    property string glyph: ""
    property url picture: ""
    property string name: ""
    property string lead: ""
    property int leadFigures: 0
    property bool quiet: false
    property string aside: ""
    property var facts: []
    property var factWidths: [108, 64]
    property alias accessory: accessoryRow.data
    property bool selected: false
    property bool current: false
    // a run of selected rows is one wash, round only at its ends: the list sets these when the row above or below is
    // also selected (stacked round washes touched and notched each other)
    property bool joinAbove: false
    property bool joinBelow: false
    // the keyboard's place in a RowList: the focus ring shows here while the list has focus after a key
    property bool ring: false
    // false inside a RowList: the list is one tab stop and keeps the focus itself
    property bool focusable: true
    property bool editing: false
    property bool editAll: false
    property bool fresh: false
    property string label: ""
    // for the catalogue and the docs' figures: "hover", "pressed", "focus" or "editing" shows that state without a
    // pointer or key
    property string previewState: ""
    // for the docs' anatomy figures: "kind", "name", "aside", "facts" or "wash" stays lit, the rest of the row recedes
    property string previewLit: ""
    readonly property real litFade: 0.22
    function litOpacity(piece) { return row.previewLit === "" || row.previewLit === piece ? 1 : row.litFade; }

    signal clicked(int modifiers)
    signal activated()
    signal contextRequested(point at)
    signal renamed(string text)
    signal editCancelled()

    readonly property bool hovered: hover.hovered || previewState === "hover"
    readonly property bool pressed: tap.pressed || previewState === "pressed"
    readonly property var t: Kit.tokens
    readonly property bool showEditor: row.editing || row.previewState === "editing"
    readonly property bool showPicture: row.picture.toString() !== "" && thumb.status !== Image.Error

    implicitWidth: 480
    implicitHeight: t.height.row
    activeFocusOnTab: focusable
    Accessible.role: Accessible.ListItem
    Accessible.name: row.aside === "" ? row.name : `${row.name}, ${row.aside}`
    Accessible.selected: row.selected
    Accessible.onPressAction: row.activated()

    Rectangle {
        anchors.fill: parent
        readonly property bool joined: row.selected && !row.pressed
        topLeftRadius: joined && row.joinAbove ? 0 : row.t.radius.row
        topRightRadius: topLeftRadius
        bottomLeftRadius: joined && row.joinBelow ? 0 : row.t.radius.row
        bottomRightRadius: bottomLeftRadius
        color: row.t.inkMain
        opacity: row.previewLit === "wash" ? row.t.wash.current
            : row.pressed ? row.t.wash.pressed : row.selected ? (row.hovered ? row.t.wash.currentHover : row.t.wash.current)
            : row.hovered ? row.t.wash.hover : 0
        Behavior on opacity { NumberAnimation { duration: Kit.ms(row.t.motion.hover.ms) } }
    }
    FocusRing { shown: ((row.activeFocus || row.ring) && Kit.focusVisible) || row.previewState === "focus" }

    Symbol {
        opacity: row.litOpacity("kind")
        visible: !row.showPicture
        x: row.t.space.l
        anchors.verticalCenter: parent.verticalCenter
        text: row.glyph
        color: row.quiet ? row.t.quiet : row.t.inkSec
    }
    // the small picture, its corners cut by a rounded mask
    Image {
        id: thumb
        visible: false
        source: row.picture
        sourceSize: Qt.size(52, 52)
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        width: 26
        height: 26
    }
    Rectangle {
        id: thumbMask
        visible: false
        width: 26
        height: 26
        radius: row.t.radius.art
        layer.enabled: true
    }
    MultiEffect {
        visible: row.showPicture
        // centred where the symbol's centre is (16 + 20 / 2), so pictures and symbols line up down a list
        x: row.t.space.l + row.t.icon.row / 2 - 13
        anchors.verticalCenter: parent.verticalCenter
        width: 26
        height: 26
        source: thumb
        maskEnabled: true
        maskSource: thumbMask
    }

    // the name comes first: the name beside it shortens, then goes, before the name itself is shortened
    readonly property real leadBox: Math.max(row.lead === "" ? 0 : leadText.implicitWidth, row.leadFigures > 0 ? leadFigure.width * row.leadFigures : 0)
    readonly property real leadWidth: leadBox === 0 ? 0 : leadBox + row.t.space.m
    readonly property real accessoryWidth: accessoryRow.visibleChildren.length > 0 ? accessoryRow.width + row.t.space.m : 0
    readonly property real textRoom: Math.max(0, row.width - 52 - row.leadWidth - factsRow.width - accessoryWidth - row.t.space.xl)
    readonly property real nameRoom: Math.min(nameText.implicitWidth, textRoom)
    readonly property real asideRoom: row.aside === "" ? 0 : textRoom - nameRoom - row.t.space.m
    TextMetrics {
        id: leadFigure
        text: "0"
        font: leadText.font
    }
    TacitText {
        id: leadText
        opacity: row.litOpacity("name")
        visible: row.lead !== ""
        x: 52
        width: row.leadBox
        horizontalAlignment: Text.AlignRight
        anchors.baseline: nameText.baseline
        text: row.lead
        ink: row.quiet ? "quiet" : "meta"
        cut: "numbers"
    }
    TacitText {
        id: nameText
        opacity: row.litOpacity("name")
        visible: !row.showEditor
        x: 52 + row.leadWidth
        anchors.verticalCenter: parent.verticalCenter
        width: row.nameRoom
        text: row.name
        ink: row.quiet ? "quiet" : "main"
        weight: row.current ? "medium" : "regular"
        elide: Text.ElideMiddle
    }
    TacitText {
        id: asideText
        opacity: row.litOpacity("aside")
        visible: row.asideRoom >= 48 && !row.showEditor
        x: nameText.x + nameText.width + row.t.space.m
        width: Math.min(implicitWidth, row.asideRoom)
        anchors.baseline: nameText.baseline
        text: row.aside
        ink: row.quiet ? "quiet" : "meta"
        elide: Text.ElideRight
    }

    // the line to type in, over the name: its text starts where the name did
    readonly property real editRoom: Math.max(0, row.width - (nameText.x - row.t.space.s) - factsRow.width - accessoryWidth - row.t.space.l)
    property Item returnTo: null
    property bool settled: false
    function beginEdit() {
        row.settled = false;
        const w = row.Window.window;
        const had = w ? w.activeFocusItem : null;
        row.returnTo = had === editInput ? null : had;
        row.chooseStem();
        editInput.forceActiveFocus();
    }
    function chooseStem() {
        editInput.text = row.name;
        const dot = row.name.lastIndexOf(".");
        editInput.select(0, row.editAll || dot <= 0 ? row.name.length : dot);
    }
    // `giveBack`: Enter and Esc return the keyboard; focus that left for somewhere else is not taken back
    function finish(keep, giveBack) {
        if (!row.editing || row.settled) return;
        row.settled = true;
        const text = editInput.text;
        if (keep && text.trim() !== "" && (row.fresh || text !== row.name)) row.renamed(text);
        else row.editCancelled();
        if (giveBack && row.returnTo) row.returnTo.forceActiveFocus();
    }
    onEditingChanged: {
        if (row.editing) row.beginEdit();
        else if (editInput.activeFocus && row.returnTo) row.returnTo.forceActiveFocus();
    }
    Component.onCompleted: {
        if (row.editing) row.beginEdit();
        else if (row.previewState === "editing") row.chooseStem();
    }
    Rectangle {
        id: editBox
        visible: row.showEditor
        x: nameText.x - row.t.space.s
        anchors.verticalCenter: parent.verticalCenter
        width: Math.min(editInput.contentWidth + 2 * row.t.space.s + 40, row.editRoom)
        height: 32
        radius: row.t.radius.row
        color: row.t.windowGround
        border.width: row.t.state.focusRing
        border.color: row.t.accent
        TextInput {
            id: editInput
            x: row.t.space.s
            width: parent.width - 2 * row.t.space.s
            anchors.verticalCenter: parent.verticalCenter
            clip: true
            color: row.t.inkMain
            persistentSelection: true
            selectionColor: Qt.alpha(row.t.accent, 0.32)
            selectedTextColor: row.t.inkMain
            font.family: row.t.font.main
            font.pixelSize: row.t.size.row
            font.variableAxes: ({ "wght": row.t.weight.regular, "wdth": 100 })
            font.hintingPreference: Font.PreferNoHinting
            renderType: Text.NativeRendering
            cursorDelegate: Rectangle { width: 1.5; color: row.t.accent; visible: editInput.cursorVisible }
            Accessible.role: Accessible.EditableText
            Accessible.name: row.label !== "" ? row.label : "Name"
            onActiveFocusChanged: {
                const w = row.Window.window;
                if (!activeFocus && (!w || w.active)) row.finish(true, false);
            }
            // a TextInput leaves Enter unaccepted so it travels on up (to the list's "open"): take it here
            Keys.onReturnPressed: event => { row.finish(true, true); event.accepted = true; }
            Keys.onEnterPressed: event => { row.finish(true, true); event.accepted = true; }
            Keys.onEscapePressed: event => { row.finish(false, true); event.accepted = true; }
        }
    }

    Row {
        id: factsRow
        opacity: row.litOpacity("facts")
        anchors.right: parent.right
        anchors.rightMargin: row.t.space.l
        anchors.verticalCenter: parent.verticalCenter
        Repeater {
            model: row.facts
            TacitText {
                required property string modelData
                required property int index
                width: row.factWidths[Math.min(index, row.factWidths.length - 1)]
                horizontalAlignment: Text.AlignRight
                text: modelData
                ink: row.quiet ? "quiet" : "sec"
                cut: "numbers"
            }
        }
    }

    Row {
        id: accessoryRow
        anchors.right: factsRow.left
        anchors.rightMargin: row.t.space.m
        anchors.verticalCenter: parent.verticalCenter
        spacing: row.t.space.s
    }

    HoverHandler { id: hover }
    TapHandler {
        id: tap
        enabled: !row.editing
        acceptedButtons: Qt.LeftButton
        onTapped: {
            Kit.focusVisible = false;
            if (row.focusable)
                row.forceActiveFocus(Qt.MouseFocusReason);
            row.clicked(tap.point.modifiers);
        }
        onDoubleTapped: row.activated()
    }
    TapHandler {
        enabled: !row.editing
        acceptedButtons: Qt.RightButton
        onTapped: point => row.contextRequested(point.position)
    }
    Keys.onPressed: event => {
        Kit.focusVisible = true;
        if (row.editing) {
            // the line has the keyboard: what it does not use is not the list's either (Tab still leaves)
            event.accepted = event.key !== Qt.Key_Tab && event.key !== Qt.Key_Backtab;
            return;
        }
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            row.activated();
            event.accepted = true;
        } else if (event.key === Qt.Key_Menu) {
            row.contextRequested(Qt.point(row.width / 2, row.height / 2));
            event.accepted = true;
        }
    }
}
