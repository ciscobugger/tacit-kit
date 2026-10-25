// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// The index at a long list's right edge: letters, or months and years, 13 px, 28 a step. Marks the list has in the
// secondary ink, the others faint and inert. Press a mark to jump; press and slide along the index to keep jumping.
// Not a tab stop: with the keyboard, typing a name in the list does the same (RowList).
// Given less height than every mark at 28 (anchor its top and bottom), the step shrinks to 18; below that the marks
// fold: every other place shows a dot standing for the marks between its neighbours (A • D • G ... Z), and a press on
// the dot jumps to the first of them the list has. Folded, a mark takes 24 px around its middle for a press and the dot between two marks the
// 12 that are left (the drawing is the same); unfolded every mark has 28.
Item {
    id: jumps
    property var marks: "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    property var present: marks          // the marks the list has
    property string previewHover: ""     // a mark shown under the pointer, for the catalogue and the docs
    signal jump(string mark)

    property string under: ""            // the place under a pressed pointer (its label and first mark)
    width: 44
    implicitHeight: marks.length * 28
    Accessible.role: Accessible.List
    Accessible.name: "Jump to"

    readonly property bool folded: marks.length * 18 > height
    // one place per mark, or when folded an odd number of places that start and end on a mark
    readonly property var places: {
        const n = jumps.marks.length;
        if (!jumps.folded)
            return jumps.marks.map((m, i) => ({ label: m, from: i, to: i }));
        let count = Math.max(3, Math.floor(jumps.height / 18));
        if (count % 2 === 0) count--;
        const out = [];
        for (let i = 0; i < count; i++) {
            const from = Math.floor(i * n / count), to = Math.max(from, Math.floor((i + 1) * n / count) - 1);
            const label = i % 2 === 1 ? "•" : i === count - 1 ? jumps.marks[n - 1] : jumps.marks[from];
            out.push({ label: label, from: from, to: to });
        }
        return out;
    }
    readonly property real step: Math.min(28, jumps.height / Math.max(1, jumps.places.length))

    function has(m) { return jumps.present.indexOf(m) >= 0; }
    // where a press on a place goes: its own mark when the list has it, else the first mark of its stretch it has
    function target(p) {
        if (p.label !== "•" && jumps.has(p.label)) return p.label;
        for (let i = p.from; i <= p.to; i++) if (jumps.has(jumps.marks[i])) return jumps.marks[i];
        return "";
    }
    // The place under y. Folded, the places stand 18 apart, too close for a 24 px target: a mark takes 24 around its
    // middle, which is six px of each dot beside it, so the dot keeps 12 (the drawing does not change)
    function placeAt(y) {
        if (y < 0 || y >= jumps.places.length * jumps.step) return null;
        const i = Math.floor(y / jumps.step), p = jumps.places[i];
        if (jumps.folded && p.label === "•") {
            for (const j of [i - 1, i + 1]) {
                const q = jumps.places[j];
                if (q && q.label !== "•" && Math.abs(y - (j + 0.5) * jumps.step) <= 12) return q;
            }
        }
        return p;
    }
    function slideTo(y) {
        const p = jumps.placeAt(y);
        if (!p) return;
        const m = jumps.target(p);
        if (p.label + p.from !== jumps.under && m !== "") jumps.jump(m);
        jumps.under = p.label + p.from;
    }

    Column {
        Repeater {
            model: jumps.places
            TacitText {
                id: place
                required property var modelData
                readonly property string to: jumps.target(modelData)
                readonly property bool lit: markHover.hovered || jumps.under === modelData.label + modelData.from
                                            || jumps.previewHover === modelData.label
                width: jumps.width; height: jumps.step
                horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                text: modelData.label
                size: "meta"
                ink: place.to === "" ? "faint" : lit ? "main" : "sec"
                Accessible.role: Accessible.Button
                Accessible.name: modelData.label === "•" ? jumps.marks[modelData.from] + " to " + jumps.marks[modelData.to] : modelData.label
                Accessible.ignored: place.to === ""
                Accessible.onPressAction: jumps.jump(place.to)
                HoverHandler { id: markHover; enabled: place.to !== ""; cursorShape: Qt.PointingHandCursor }
            }
        }
    }
    // one handler over the whole index, so a slide passes from mark to mark
    DragHandler {
        target: null
        xAxis.enabled: false
        onActiveChanged: if (!active) jumps.under = ""
        onCentroidChanged: if (active) jumps.slideTo(centroid.position.y)
    }
    TapHandler {
        onTapped: (point) => {
            jumps.under = "";
            const p = jumps.placeAt(point.position.y);
            const m = p ? jumps.target(p) : "";
            if (m !== "") jumps.jump(m);
        }
    }
}
