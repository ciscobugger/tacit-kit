// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// Words in a line of text that go somewhere (the artist on an album's page): the secondary ink at rest, the main ink
// under the pointer, no underline. One tab stop with the focus ring around the words; Enter and Space follow it, as a
// click does (activated). It is a link to the screen reader. `size`, `weight` and `ink` (the ink at rest) are
// TacitText's; the link is as wide and high as its words.
Item {
    id: link

    property alias text: words.text
    property alias size: words.size
    property alias weight: words.weight
    property alias elide: words.elide
    property string ink: "sec"
    // for the catalogue and the docs: "hover" or "focus" shows that state without a pointer or key
    property string previewState: ""
    signal activated()

    readonly property bool hovered: hover.hovered || previewState === "hover"

    implicitWidth: words.implicitWidth
    implicitHeight: words.implicitHeight
    width: implicitWidth
    height: implicitHeight
    activeFocusOnTab: true
    Accessible.role: Accessible.Link
    Accessible.name: link.text
    Accessible.onPressAction: link.activated()

    FocusRing {
        corner: Kit.tokens.radius.art
        shown: (link.activeFocus && Kit.focusVisible) || link.previewState === "focus"
    }
    TacitText {
        id: words
        width: link.width
        ink: link.hovered ? "main" : link.ink
    }
    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
    TapHandler { onTapped: { Kit.focusVisible = false; link.activated(); } }
    Keys.onPressed: event => {
        Kit.focusVisible = true;
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            link.activated();
            event.accepted = true;
        }
    }
}
