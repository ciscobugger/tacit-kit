// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A label over a group of the rail's rows (Places, Pinned, Drives): 15 px strong in the secondary ink at 20, a count
// beside it in the meta ink when it helps. Folded, it keeps its room and shows nothing, so the groups stay apart.
Item {
    id: section
    property string text
    property int count: -1
    property Item rail: null

    width: parent?.width ?? Kit.tokens.width.rail
    height: 34
    Accessible.role: Accessible.Heading
    Accessible.name: text
    Component.onCompleted: {
        for (let p = parent; p; p = p.parent)
            if (p.isTacitRail) { section.rail = p; break; }
    }

    Row {
        anchors { left: parent.left; leftMargin: 20; bottom: parent.bottom; bottomMargin: Kit.tokens.space.s }
        spacing: Kit.tokens.space.s
        opacity: section.rail?.folded ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: Kit.ms(Kit.tokens.motion.fadeFast.ms) } }
        TacitText { id: words; text: section.text; ink: "sec"; weight: "strong" }
        TacitText { anchors.baseline: words.baseline; visible: section.count > 0; text: section.count; size: "meta"; ink: "meta"; cut: "numbers" }
    }
}
