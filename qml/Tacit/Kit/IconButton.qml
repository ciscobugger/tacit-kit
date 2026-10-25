// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A symbol you press (back, forward, close, the rail's toggle). 36 square for the pointer, a round wash on hover and
// press, the focus ring after a key (36 is its smallest target; a larger symbol keeps the room around it). `label` is what a screen reader says; it is required, the symbol alone says
// nothing to one. `checked` is a toggle that is on: the symbol in the accent over the current wash. A toggle sets
// `checkable` too, so a screen reader hears it as one while it is off (`checked` alone also counts).
// `tip` is the name in a tooltip: it shows when the pointer rests on the button and while the button has the keyboard
// (so a keyboard user sees the name too); the tooltip shows no sooner than 600 ms after either. Use it for symbols
// whose meaning is not plain.
// `enabled` is the Item's own: a disabled button draws its symbol in the faint ink, takes no pointer, no key and no Tab
// stop, and a screen reader hears it as disabled.
Item {
    id: button
    property string symbol
    property string label
    property string tip: ""
    property int size: Kit.tokens.icon.row
    property bool checked: false
    property bool checkable: false
    property string previewState: ""
    signal activated()

    readonly property bool hovered: hover.hovered || previewState === "hover"
    readonly property bool tipShown: tip !== "" && (hovered || (activeFocus && Kit.focusVisible) || previewState === "focus")
    readonly property bool down: tap.pressed || previewState === "pressed"

    // 36 for the sizes of rows and tools; a larger symbol (the transport's) keeps the same room around it
    implicitWidth: Math.max(36, Math.round(size * 1.6))
    implicitHeight: implicitWidth
    activeFocusOnTab: enabled
    Accessible.role: Accessible.Button
    Accessible.name: label
    Accessible.checkable: checkable || checked
    Accessible.checked: checked
    Accessible.onPressAction: if (button.enabled) button.activated()

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: Kit.tokens.inkMain
        opacity: !button.enabled ? 0 : button.down ? Kit.tokens.wash.pressed
            : button.checked ? (button.hovered ? Kit.tokens.wash.currentHover : Kit.tokens.wash.current)
            : button.hovered ? Kit.tokens.wash.hoverSmall : 0
        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
    }
    FocusRing { shown: (button.activeFocus && Kit.focusVisible) || button.previewState === "focus"; corner: button.width / 2 }
    Symbol {
        anchors.centerIn: parent
        text: button.symbol
        size: button.size
        color: !button.enabled ? Kit.tokens.inkFaint : button.checked ? Kit.tokens.accent : button.hovered ? Kit.tokens.inkMain : Kit.tokens.inkSec
    }
    Tooltip { text: button.tip; shown: button.tipShown }
    HoverHandler { id: hover; enabled: button.enabled; cursorShape: Qt.PointingHandCursor }
    TapHandler {
        id: tap
        enabled: button.enabled
        onTapped: { Kit.focusVisible = false; button.activated(); }
    }
    Keys.onPressed: event => {
        if (!button.enabled) return;
        Kit.focusVisible = true;
        if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space)) {
            button.activated();
            event.accepted = true;
        }
    }
}
