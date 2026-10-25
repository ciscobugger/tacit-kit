// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// The keyboard focus ring: 2 px of the accent, 2 px outside what has focus, its corner that one's plus the gap.
// Put it in the focused item; `shown` is usually `activeFocus && Kit.focusVisible`. A Field and a TextArea show it
// whenever they have the keyboard, pointer or not: where typing goes must always show.
Rectangle {
    property bool shown: false
    property real corner: Kit.tokens.radius.row

    anchors.fill: parent
    anchors.margins: -(Kit.tokens.state.focusGap + Kit.tokens.state.focusRing)
    radius: corner + Kit.tokens.state.focusGap + Kit.tokens.state.focusRing
    color: "transparent"
    border.width: Kit.tokens.state.focusRing
    border.color: Kit.tokens.accent
    visible: shown
}
