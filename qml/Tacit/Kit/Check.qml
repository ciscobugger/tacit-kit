// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A box that is ticked or not, with its label: the multi-choice control for forms and settings (several of these can
// be on; one of a few is Choices). Its look is the Switch's (Settings' Toggle) at box size: ticked is an accent fill with
// the dark mark (the menus' check), not ticked an outline, `mixed` ("some of these": a parent over children, only
// part ticked) the accent fill with a dash. The label is in the secondary ink, the main ink under the pointer; the whole
// row is the target. A click or Space asks for the opposite: `toggled(checked)` carries the new value and the app sets
// `checked` (as Switch does); a mixed box asks for ticked. Unavailable (`enabled: false`): box, mark and label in the
// faint ink, no hover, no key, and a screen reader hears it as disabled. One Tab stop, the focus ring round the box
// after a key press. A screen reader hears a check box named by `label`, checked, unchecked or partially checked.
Item {
    id: check
    property bool checked: false
    property bool mixed: false
    property string label
    property string previewState: ""
    signal toggled(bool checked)

    readonly property bool hovered: enabled && (hover.hovered || previewState === "hover")
    readonly property bool filled: checked || mixed
    readonly property int box: 20
    implicitWidth: box + Kit.tokens.space.m + words.implicitWidth
    implicitHeight: Kit.tokens.height.railRow
    activeFocusOnTab: enabled
    Accessible.role: Accessible.CheckBox
    Accessible.name: label
    Accessible.checkable: true
    Accessible.checked: checked
    Accessible.onToggleAction: check.flip()
    Accessible.onPressAction: check.flip()
    Accessible.description: mixed ? "Some are on" : ""

    function flip() { if (check.enabled) check.toggled(check.mixed ? true : !check.checked); }

    Rectangle {
        id: boxShape
        width: check.box; height: check.box
        anchors.verticalCenter: parent.verticalCenter
        radius: Kit.tokens.radius.art
        color: check.filled ? (check.enabled ? Kit.tokens.accent : Kit.tokens.inkFaint) : "transparent"
        border.width: check.filled ? 0 : 1.5
        border.color: !check.enabled ? Kit.tokens.inkFaint : Qt.alpha(Kit.tokens.inkMain, check.hovered ? 0.45 : 0.3)
        Behavior on color { ColorAnimation { duration: Kit.ms(Kit.motion("hover").ms) } }
        FocusRing { shown: check.enabled && ((check.activeFocus && Kit.focusVisible) || check.previewState === "focus"); corner: boxShape.radius }
        Symbol {
            anchors.centerIn: parent
            visible: check.checked && !check.mixed
            size: 16
            text: "check"
            color: Kit.tokens.inkOnAccent
        }
        Rectangle {
            anchors.centerIn: parent
            visible: check.mixed
            width: 10; height: 2; radius: 1
            color: Kit.tokens.inkOnAccent
        }
    }
    TacitText {
        id: words
        x: check.box + Kit.tokens.space.m
        anchors.verticalCenter: parent.verticalCenter
        text: check.label
        ink: !check.enabled ? "faint" : check.hovered ? "main" : "sec"
    }
    HoverHandler { id: hover; enabled: check.enabled; cursorShape: Qt.PointingHandCursor }
    TapHandler { enabled: check.enabled; onTapped: { Kit.focusVisible = false; check.flip(); } }
    Keys.onPressed: event => {
        Kit.focusVisible = true;
        if (event.key === Qt.Key_Space) {
            check.flip();
            event.accepted = true;
        }
    }
}
