// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// On or off, for a real on/off only (Settings' Toggle): on is an accent track with the dark knob, off an outline with a
// quiet knob, so the two read apart at a glance. The knob travels on the spring (small, direct feedback). Space or
// Enter flips it; `label` is what a screen reader says. `enabled` is the Item's own: disabled, the outline, knob and
// fill are in the faint ink, it takes no pointer, key or Tab stop, and a screen reader hears it as disabled.
Item {
    id: sw
    property bool checked: false
    property string label
    property string previewState: ""
    signal toggled(bool checked)

    readonly property bool hovered: hover.hovered || previewState === "hover"
    implicitWidth: 40
    implicitHeight: 24
    activeFocusOnTab: enabled
    Accessible.role: Accessible.CheckBox
    Accessible.name: label
    Accessible.checkable: true
    Accessible.checked: checked
    Accessible.onToggleAction: sw.flip()
    Accessible.onPressAction: sw.flip()

    function flip() { if (sw.enabled) sw.toggled(!sw.checked); }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: sw.checked ? (sw.enabled ? Kit.tokens.accent : Kit.tokens.inkFaint) : "transparent"
        border.width: sw.checked ? 0 : 1.5
        border.color: sw.enabled ? Qt.alpha(Kit.tokens.inkMain, sw.hovered ? 0.45 : 0.3) : Kit.tokens.inkFaint
        Behavior on color { ColorAnimation { duration: Kit.ms(Kit.motion("tone").ms) } }
        FocusRing { shown: (sw.activeFocus && Kit.focusVisible) || sw.previewState === "focus"; corner: parent.radius }
        Rectangle {
            width: 18; height: 18; radius: width / 2
            y: 3
            x: sw.checked ? parent.width - width - 3 : 3
            color: sw.checked ? Kit.tokens.inkOnAccent : !sw.enabled ? Kit.tokens.inkFaint : sw.hovered ? Kit.tokens.inkMain : Kit.tokens.inkMeta
            Behavior on x {
                NumberAnimation { duration: Kit.ms(Kit.tokens.motion.spring.ms); easing.type: Easing.BezierSpline; easing.bezierCurve: Kit.tokens.motion.spring.curve }
            }
            Behavior on color { ColorAnimation { duration: Kit.ms(Kit.motion("tone").ms) } }
        }
    }
    HoverHandler { id: hover; enabled: sw.enabled; cursorShape: Qt.PointingHandCursor }
    TapHandler { enabled: sw.enabled; onTapped: { Kit.focusVisible = false; sw.flip(); } }
    Keys.onPressed: event => {
        if (!sw.enabled) return;
        Kit.focusVisible = true;
        if (event.key === Qt.Key_Space || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            sw.flip();
            event.accepted = true;
        }
    }
}
