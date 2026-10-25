// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// The menu as it looks: the overlay colour, a faint edge, the slab corner, lines of words 34 high (a check on the
// choice in force, the warning symbol on a risk, a rule between groups). Menu shows it in a popup; the catalogue and
// the docs draw it in place. An item is { label, checked, risk, detail, rule, heading, keepOpen }: `heading` is a
// group's name in the meta ink (not pressable), `detail` a quiet word or number at the line's end (a count, a key),
// `keepOpen` a choice that leaves the menu open (ticking several kinds in a filter). With `keyboard` the cursor's line
// has the focus ring as well as the wash. Headings, details and the risk line use the overlay inks (Lc 75 or more on
// the lit line, in every palette).
Rectangle {
    id: menu
    property var items: []
    property int cursor: -1
    property bool keyboard: false      // the cursor is the keyboard's: its line has the focus ring
    signal picked(int index)

    readonly property var t: Kit.tokens
    readonly property real lineWidth: Math.max(180, measure.width + 2 * 12 + 28 + (detailMeasure.width > 0 ? detailMeasure.width + 24 : 0))

    implicitWidth: lineWidth + 8
    implicitHeight: lines.implicitHeight + 8
    radius: t.radius.slab
    color: t.overlay
    border.width: 1
    border.color: Qt.alpha(t.inkMain, 0.10)

    function pick(i) {
        if (i >= 0 && !menu.items[i].rule && !menu.items[i].heading) menu.picked(i);
    }

    // the widest label decides the menu's width
    TextMetrics {
        id: measure
        font.family: menu.t.font.main
        font.pixelSize: menu.t.size.row
        text: menu.items.reduce((w, it) => (it.label ?? "").length > w.length ? it.label : w, "")
    }
    TextMetrics {
        id: detailMeasure
        font.family: menu.t.font.main
        font.pixelSize: menu.t.size.meta
        text: menu.items.reduce((w, it) => String(it.detail ?? "").length > w.length ? String(it.detail) : w, "")
    }

    Column {
        id: lines
        x: 4
        y: 4
        Repeater {
            model: menu.items
            Item {
                id: line
                required property var modelData
                required property int index
                readonly property bool rule: modelData.rule === true
                readonly property bool heading: modelData.heading === true
                readonly property bool lit: !heading && (index === menu.cursor || lineHover.hovered)
                width: menu.lineWidth
                height: rule ? 9 : heading ? 28 : menu.t.height.menuRow
                Accessible.role: rule ? Accessible.Separator : heading ? Accessible.Heading : Accessible.MenuItem
                Accessible.name: (modelData.label ?? "") + (modelData.risk === true ? ", warning" : "")
                Accessible.description: String(modelData.detail ?? "")
                Accessible.checkable: modelData.checked !== undefined
                Accessible.checked: modelData.checked === true
                Accessible.onPressAction: menu.pick(line.index)

                Rectangle {
                    visible: line.rule
                    anchors.verticalCenter: parent.verticalCenter
                    x: 12; width: parent.width - 24; height: 1
                    color: Qt.alpha(menu.t.inkMain, 0.10)
                }
                Rectangle {
                    visible: !line.rule && !line.heading
                    anchors.fill: parent
                    radius: menu.t.radius.row
                    color: menu.t.inkMain
                    opacity: line.lit ? menu.t.wash.current : 0
                    Behavior on opacity { NumberAnimation { duration: Kit.ms(menu.t.motion.hover.ms) } }
                }
                FocusRing {
                    shown: !line.rule && !line.heading && menu.keyboard && line.index === menu.cursor
                    corner: menu.t.radius.row
                    z: 1
                }
                Symbol {
                    visible: !line.rule && (line.modelData.checked === true || line.modelData.risk === true)
                    x: 10
                    anchors.verticalCenter: parent.verticalCenter
                    size: 16
                    text: line.modelData.risk === true ? "warning" : "check"
                    color: line.modelData.risk === true ? (menu.t.overlayRisk ?? menu.t.risk) : menu.t.accent
                }
                TacitText {
                    visible: !line.rule
                    x: line.heading ? 12 : 34
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: line.heading ? 2 : 0
                    text: line.modelData.label ?? ""
                    size: line.heading ? "meta" : "row"
                    weight: line.heading ? "medium" : "regular"
                    ink: line.heading ? "overlayMeta" : line.modelData.risk === true ? "overlayRisk" : line.lit ? "main" : "sec"
                }
                TacitText {
                    visible: !line.rule && !line.heading && String(line.modelData.detail ?? "") !== ""
                    anchors.right: parent.right; anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    text: String(line.modelData.detail ?? "")
                    size: "meta"; ink: "overlayMeta"; cut: "numbers"
                }
                HoverHandler { id: lineHover; enabled: !line.rule && !line.heading; cursorShape: Qt.PointingHandCursor }
                TapHandler { enabled: !line.rule && !line.heading; onTapped: menu.pick(line.index) }
            }
        }
    }

}
