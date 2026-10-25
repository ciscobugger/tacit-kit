// Runs an app offscreen and saves what its window draws (tools/grab.sh runs it once per palette). A window's own content
// item has no QML engine and cannot be grabbed, so the app's window is hidden and its content moves into one that can.
import QtQuick
import QtQuick.Controls
import Quickshell

ShellRoot {
    id: root
    readonly property string out: Quickshell.env("GRAB_OUT") || "/tmp/grab.png"
    readonly property int settle: Number(Quickshell.env("GRAB_SETTLE") || 1500)
    readonly property var comp: Qt.createComponent("file://" + Quickshell.env("GRAB_APP"))
    property var win: null
    ApplicationWindow {
        id: host; visible: true; color: "transparent"
        width: root.win ? (root.win.width || root.win.implicitWidth || 800) : 800
        height: root.win ? (root.win.height || root.win.implicitHeight || 600) : 600
        Item { id: holder; anchors.fill: parent }
    }
    Component.onCompleted: {
        if (comp.status !== Component.Ready) { console.log("GRAB error", comp.errorString()); Qt.quit(); return; }
        win = comp.createObject(root);
        win.visible = false;
        for (const c of Array.from(win.contentItem.children)) c.parent = holder;
        shot.start();
    }
    Timer {
        id: shot; interval: root.settle
        onTriggered: holder.grabToImage(g => { console.log("GRAB", g.saveToFile(root.out) ? "saved" : "failed", root.out); Qt.quit(); })
    }
}
