// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick
import QtQuick.Controls

// The name of a symbol-only thing, shown when the pointer rests on it: after 600 ms, under it, 8 px away; it fades in
// fast and goes as the pointer leaves. Put it inside the thing it names: Tooltip { text: "Fold the places"; shown: hovered }
ToolTip {
    id: tip
    property bool shown: false
    visible: shown
    delay: 600
    y: parent ? parent.height + 8 : 0
    x: parent ? (parent.width - width) / 2 : 0
    padding: 0
    background: null
    contentItem: TooltipSurface { text: tip.text }
    enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Kit.ms(Kit.tokens.motion.fadeFast.ms) } }
    exit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Kit.ms(Kit.tokens.motion.hover.ms) } }
}
