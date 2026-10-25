// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// The panel that shows the selection's content, hung from the page header's line into the window's right edge: one
// shape with both (Docked, edge top-right). Its material is the page lifted by a 6 % wash of the main ink (2026-10-25:
// a solid container read as a flat grey patch over the warm page): it keeps the wallpaper's hue and glow as the page
// does. It is see-through, so where it covers content (a window at half width) the page clips that content at the
// panel's edge. It arrives by
// growing from the edge (Arrive, 300 ms) and leaves faster (Leave, 200 ms); its content travels with its edge and fades
// in 120 ms after it starts (motion.follow). `label` is the panel's name for a screen reader ("Details"). Place it at the window's right edge, its top on the header's line; put the content in it.
// A panel opened by a key takes the keyboard and gives it back when it closes (below); Esc and Space belong to the app.
Item {
    id: panel
    property bool open: false
    property string label: ""
    property real openWidth: Kit.tokens.width.panel
    default property alias content: inner.data

    property real shown: open ? 1 : 0
    Behavior on shown {
        NumberAnimation {
            duration: Kit.ms(panel.open ? Kit.tokens.motion.arrive.ms : Kit.tokens.motion.leave.ms)
            easing.type: Easing.BezierSpline
            easing.bezierCurve: panel.open ? Kit.tokens.motion.arrive.curve : Kit.tokens.motion.leave.curve
        }
    }
    property real contentShown: open ? 1 : 0
    Behavior on contentShown {
        SequentialAnimation {
            PauseAnimation { duration: panel.open ? Kit.ms(Kit.motion("follow").ms) : 0 }
            NumberAnimation {
                duration: Kit.ms(panel.open ? Kit.tokens.motion.fade.ms : Kit.motion("follow").ms)
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Kit.tokens.motion.fade.curve
            }
        }
    }

    // The keyboard: opened while the focus ring is showing (Kit.focusVisible: a key opened it), the focus goes into the
    // panel, to the first stop for Tab in its content (the panel itself when it has none); when it closes with the focus
    // inside, the focus goes back to the item that had it when it opened (`opener`). Opened by the pointer, the focus stays
    // where it was. Closing on Esc, and Space asking for the panel, are the app's keys (a list's `peeked`): the panel
    // binds none.
    property Item opener: null
    property bool entering: false
    // the first stop for Tab in the content, in the order the items are declared
    function firstStop(item) {
        for (const child of item.children) {
            if (!child.visible || !child.enabled) continue;
            if (child.activeFocusOnTab) return child;
            const inner = panel.firstStop(child);
            if (inner) return inner;
        }
        return null;
    }
    function holdsFocus() {
        for (let p = panel.Window.activeFocusItem; p; p = p.parent) if (p === panel) return true;
        return false;
    }
    function enter() {
        entering = false;
        (panel.firstStop(inner) ?? panel).forceActiveFocus();
    }
    onOpenChanged: {
        if (open) {
            opener = panel.Window.activeFocusItem;
            entering = Kit.focusVisible;
            if (entering && visible) enter();
        } else {
            entering = false;
            if (holdsFocus() && opener && opener.visible) opener.forceActiveFocus();
            opener = null;
        }
    }
    onVisibleChanged: if (visible && entering) enter()

    width: openWidth * shown
    visible: shown > 0.001
    Accessible.role: Accessible.Pane
    Accessible.name: label

    Docked {
        anchors.fill: parent
        edge: "top-right"
        cornerRadius: Kit.tokens.radius.panel
        fillet: 10
        color: Qt.alpha(Kit.tokens.inkMain, Kit.tokens.wash.action)
    }
    Item {
        anchors.fill: parent
        clip: true
        Item {
            id: inner
            width: panel.openWidth
            height: parent.height
            opacity: panel.contentShown
        }
    }
}
