// Runs docs/examples/downloads.qml as it is, offscreen, and saves its pixels. Not part of the page: its figure
// (your-first-app.qml) puts the saved picture on the wallpaper the way the compositor would.
import QtQuick
import QtQuick.Controls
import Quickshell

ShellRoot {
    id: root
    readonly property string out: Quickshell.env("FIGURE_OUT") || "/tmp/fig"
    readonly property var comp: Qt.createComponent("file://" + Quickshell.env("FIGURE_APP"))
    property var win: null
    // a window's own content item has no QML engine and cannot be grabbed, so its children move into one that has
    ApplicationWindow { id: host; visible: true; width: 880; height: 480; color: "transparent"; Item { id: holder; anchors.fill: parent } }
    function find(item, test) {
        if (test(item)) return item;
        for (const c of item.children) { const f = find(c, test); if (f) return f; }
        return null;
    }
    Component.onCompleted: {
        if (comp.status !== Component.Ready) { console.log("DUMP error", comp.errorString()); Qt.quit(); return; }
        win = comp.createObject(root);
        win.visible = false;
    }
    Timer {
        interval: 1500; running: true
        onTriggered: {
            for (const c of Array.from(root.win.contentItem.children)) c.parent = holder;
            const list = root.find(holder, i => typeof i.moveTo === "function" && i.hasOwnProperty("cursor"));
            const panel = root.find(holder, i => i.hasOwnProperty("openWidth"));
            list.forceActiveFocus(); list.moveTo(1, "select"); panel.open = true;
            done.start();
        }
    }
    Timer {
        id: done; interval: 1200
        onTriggered: holder.grabToImage(g => { console.log("DUMP saved", g.saveToFile(root.out + "/app.png")); Qt.quit(); })
    }
}
