// Behaviour test for ListRow editing and the confirm of Slab and WordAction: real key and mouse events into an offscreen
// window, one line per check (PASS or FAIL) and the signals that came. Run: tools/behaviour.sh (TACIT_REDUCED_MOTION=1
// for the reduced-motion pass).
import QtQuick
import QtQuick.Controls
import QtTest
import Quickshell
import Tacit.Kit

ShellRoot {
    id: root
    property var log: []
    property int fails: 0
    function say(s) { console.log("BEH " + s); }
    function check(label, ok) { if (!ok) root.fails++; root.say((ok ? "PASS " : "FAIL ") + label); }
    function note(s) { root.log.push(s); root.say("  signal: " + s); }
    function take() { const l = root.log.join(","); root.log = []; return l; }

    ApplicationWindow {
        id: win
        visible: true; width: 700; height: 520; color: "#1e1b1a"
        property int editIdx: -1
        property bool editAll: false
        property bool fresh: false
        property int activations: 0
        property var names: ["Lease agreement.pdf", "Budget 2027.xlsx", "notes", ".profile"]

        RowList {
            id: list
            x: 20; y: 20; width: 600; height: 200
            model: win.names.map(n => ({ name: n }))
            onActivated: win.activations++
            onEditRequested: i => { root.note("editRequested " + i); win.editIdx = i; }
            delegate: ListRow {
                required property var modelData
                required property int index
                width: list.rowWidth; focusable: false
                glyph: "description"; name: modelData.name; facts: ["1 kB", "Mon"]
                selected: list.isSelected(index); ring: list.ringAt(index)
                editing: win.editIdx === index; editAll: win.editAll; fresh: win.fresh
                onClicked: m => list.clickAt(index, m)
                onActivated: list.activated(index)
                onRenamed: t => { root.note("renamed '" + t + "'"); win.editIdx = -1; }
                onEditCancelled: { root.note("editCancelled"); win.editIdx = -1; }
            }
        }
        Slab { id: slab; x: 20; y: 260; text: "Empty trash"; tone: "default"; confirm: "Delete 12 files for good"
            onActivated: root.note("slab activated"); onConfirmCancelled: root.note("slab confirmCancelled") }
        Slab { id: plain; x: 300; y: 260; text: "Plain"; onActivated: root.note("plain activated") }
        WordAction { id: word; x: 40; y: 340; width: 300; text: "Empty trash"; confirm: "Delete 12 files for good"
            onActivated: root.note("word activated"); onConfirmCancelled: root.note("word confirmCancelled") }
        Field { id: other; x: 400; y: 340; width: 200; label: "Other" }
    }

    TestCase {
        id: t
        name: "inplace"; when: win.visible && win.activeFocusItem !== undefined; windowShown: win.visible
        function row(i) { return list.view.itemAtIndex(i); }
        function find(item, test) {
            for (const c of item.children) { if (test(c)) return c; const d = find(c, test); if (d) return d; }
            return null;
        }
        function input(i) { return find(row(i), c => c.selectedText !== undefined); }
        function editor(i) { return input(i).parent; }
        function startEdit(i, all, fresh) {
            list.forceActiveFocus(); list.moveTo(i, "select"); win.editAll = all; win.fresh = fresh;
            keyClick(Qt.Key_F2); wait(60);
        }
        function test_all() {
            try { run(); } catch (e) { root.say("FAIL exception: " + e + " at line " + e.lineNumber); }
            Qt.quit();
        }
        function run() {
            wait(400);
            root.say("window active: " + win.active);
            // ---- rename, stem chosen
            list.forceActiveFocus(); list.moveTo(1, "select");
            keyClick(Qt.Key_F2); wait(60);
            root.check("F2 says editRequested(1)", root.take() === "editRequested 1");
            root.check("row 1 is editing, focus in its line", row(1).editing && input(1).activeFocus);
            root.check("stem chosen: '" + input(1).selectedText + "'", input(1).selectedText === "Budget 2027");
            root.check("line sits at the name's x (" + (input(1).mapToItem(row(1), 0, 0).x) + ")", input(1).mapToItem(row(1), 0, 0).x === 52);
            root.check("box 32 high", editor(1).height === 32);
            keyClick(Qt.Key_Down); keyClick(Qt.Key_Space); keyClick(Qt.Key_PageDown); wait(30);
            root.check("arrows and Space do not reach the list (cursor " + list.cursor + ", peeked none)", list.cursor === 1);
            input(1).text = "Budget 2027.xlsx"; input(1).select(0, 11); keyClick("X"); wait(30);
            root.check("typing replaces the stem: '" + input(1).text + "'", input(1).text === "X.xlsx");
            keyClick(Qt.Key_Return); wait(60);
            root.check("Enter says renamed", root.take() === "renamed 'X.xlsx'");
            root.check("Enter did not open the row", win.activations === 0);
            root.check("keyboard back on the list", list.activeFocus);
            keyClick(Qt.Key_Down); wait(30);
            root.check("list keys work again (cursor " + list.cursor + ")", list.cursor === 2);

            // ---- Esc
            startEdit(1, false, false); root.take();
            keyClick("Z"); keyClick(Qt.Key_Escape); wait(60);
            root.check("Esc says editCancelled", root.take() === "editCancelled");
            root.check("keyboard back on the list after Esc", list.activeFocus);

            // ---- unchanged and empty
            startEdit(1, false, false); root.take();
            keyClick(Qt.Key_Return); wait(60);
            root.check("Enter unchanged says editCancelled", root.take() === "editCancelled");
            startEdit(1, false, false); root.take();
            keyClick("a", Qt.ControlModifier); keyClick(Qt.Key_Delete); keyClick(Qt.Key_Return); wait(60);
            root.check("Enter on an empty name says editCancelled", root.take() === "editCancelled");

            // ---- a new folder: all chosen, Enter keeps the name
            win.names = ["Untitled folder", "Budget 2027.xlsx", "notes", ".profile"]; wait(60);
            startEdit(0, true, true); root.take();
            root.check("editAll chooses all: '" + input(0).selectedText + "'", input(0).selectedText === "Untitled folder");
            keyClick(Qt.Key_Return); wait(60);
            root.check("fresh row: Enter unchanged says renamed", root.take() === "renamed 'Untitled folder'");
            win.fresh = false; win.editAll = false;

            // ---- no dot, dotfile: all chosen
            startEdit(2, false, false); root.take();
            root.check("no dot chooses all: '" + input(2).selectedText + "'", input(2).selectedText === "notes");
            keyClick(Qt.Key_Escape); wait(60); root.take();
            startEdit(3, false, false); root.take();
            root.check("dotfile chooses all: '" + input(3).selectedText + "'", input(3).selectedText === ".profile");
            keyClick(Qt.Key_Escape); wait(60); root.take();

            // ---- the keyboard leaving commits, and is not taken back
            startEdit(1, false, false); root.take();
            keyClick("Q"); other.focusIn(); wait(60);
            root.check("keyboard leaving says renamed", root.take() === "renamed 'Q.xlsx'");
            root.check("focus stays where it went", other.input.activeFocus);
            startEdit(1, false, false); root.take();
            other.focusIn(); wait(60);
            root.check("keyboard leaving unchanged says editCancelled", root.take() === "editCancelled");

            // ---- Slab, keyboard
            slab.forceActiveFocus(); wait(30);
            keyClick(Qt.Key_Return); wait(300);
            root.check("first Enter does not act", root.take() === "");
            root.check("words are the question: '" + slab.shownText + "', tone risk, name '" + slab.Accessible.name + "'", slab.shownText === "Delete 12 files for good" && slab.risky && slab.Accessible.name === "Delete 12 files for good");
            root.check("Slab is wider (" + slab.width + ")", slab.width > 200);
            keyClick(Qt.Key_Return); wait(300);
            root.check("second Enter says activated", root.take() === "slab activated");
            root.check("words are back: '" + slab.shownText + "', forward again, width " + slab.width, slab.shownText === "Empty trash" && slab.forward && slab.width < 200);
            keyClick(Qt.Key_Space); wait(100); root.take();
            keyClick(Qt.Key_Escape); wait(100);
            root.check("Esc says confirmCancelled, no activated", root.take() === "slab confirmCancelled");
            root.check("words are back after Esc", slab.shownText === "Empty trash");
            keyClick(Qt.Key_Return); wait(100); root.take();
            wait(4400);
            root.check("untouched 4 s says confirmCancelled", root.take() === "slab confirmCancelled");
            keyClick(Qt.Key_Return); wait(100); root.take();
            other.focusIn(); wait(100);
            root.check("keyboard leaving says confirmCancelled", root.take() === "slab confirmCancelled");

            // ---- Slab, pointer
            mouseMove(slab, 20, 20); mouseClick(slab); wait(300);
            root.check("pointer press asks", root.take() === "" && slab.asking);
            mouseClick(slab); wait(300);
            root.check("second pointer press says activated", root.take() === "slab activated");
            mouseClick(slab); wait(300); root.take();
            mouseMove(win.contentItem, 650, 480); wait(200);
            root.check("pointer leaving says confirmCancelled", root.take() === "slab confirmCancelled");
            mouseClick(plain); wait(100);
            root.check("a Slab without confirm acts at once", root.take() === "plain activated");

            // ---- WordAction
            mouseMove(win.contentItem, 650, 480); wait(50); root.take();
            word.forceActiveFocus(); wait(30);
            keyClick(Qt.Key_Return); wait(300);
            root.check("WordAction: first Enter asks: '" + word.shownText + "', risky " + word.risky, root.take() === "" && word.shownText === "Delete 12 files for good" && word.risky);
            keyClick(Qt.Key_Return); wait(300);
            root.check("WordAction: second Enter says activated", root.take() === "word activated");
            keyClick(Qt.Key_Return); wait(100); root.take();
            keyClick(Qt.Key_Escape); wait(100);
            root.check("WordAction: Esc says confirmCancelled", root.take() === "word confirmCancelled" && word.shownText === "Empty trash");
            keyClick(Qt.Key_Return); wait(100); root.take();
            wait(4400);
            root.check("WordAction: untouched 4 s says confirmCancelled", root.take() === "word confirmCancelled");
            root.say("reduced motion: " + Kit.reducedMotion);
            root.say(root.fails === 0 ? "ALL PASS" : root.fails + " FAILED");
        }
    }
}
