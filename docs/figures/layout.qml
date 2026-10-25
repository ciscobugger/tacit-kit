// Layout: the steps of the 4 grid, the window at full and at half width (drawn from the tokens, outlines of the
// parts), and the heights.
import QtQuick
import QtQuick.Effects
import Tacit.Kit

DocFigures {
    id: app
    figures: [["steps", 760, 200], ["full", 760, 400], ["half", 760, 400]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens

    F { n: "steps"
        Row { x: 44; y: 35; spacing: 0
            Repeater {
                model: [["xs", 4], ["s", 8], ["m", 12], ["l", 16], ["xl", 24], ["xxl", 32], ["page", 48]]
                Item {
                    id: step
                    required property var modelData
                    width: 100; height: 130
                    Rectangle { x: 0; y: 0; width: step.modelData[1] * 1.5; height: step.modelData[1] * 1.5; radius: 2
                        color: Qt.alpha(app.t.accent, 0.85) }
                    TacitText { y: 86; text: String(step.modelData[1]); size: "body"; weight: "medium"; cut: "numbers" }
                    TacitText { y: 110; text: step.modelData[0]; ink: "meta" }
                }
            }
        }
    }

    // a window as the real parts at 0.65, so the plan reads as the layout it is: the rail, the header, the list and the panel
    component Plan: Item {
        id: plan
        readonly property real k: 0.65
        property real w: 1000
        property bool folded: false
        readonly property real h: 420
        readonly property real railW: folded ? app.t.width.railFolded : app.t.width.rail
        // 49 px of dimension line to the left, 41 above; the plan is centred with them
        x: (parent.width - w * k - 49) / 2 + 49; y: (parent.height - h * k - 41) / 2 + 41
        Item {
            scale: plan.k; transformOrigin: Item.TopLeft; width: plan.w; height: plan.h
            Item {
                id: win
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect { maskEnabled: true; maskSource: mask }
                Rectangle { anchors.fill: parent; color: Qt.alpha(app.t.windowGround, 0.5) }
                Rail { id: rl; height: plan.h; folded: plan.folded; action: "New folder"; actionSymbol: "add"
                    RailRow { glyph: "home"; label: "Home" }
                    RailRow { glyph: "description"; label: "Documents" }
                    RailRow { glyph: "download"; label: "Downloads"; current: true }
                    RailRow { glyph: "image"; label: "Pictures" }
                }
                PageHeader { x: plan.railW; width: plan.w - plan.railW; crumbs: ["Files"]; here: "Downloads" }
                // the page clips its content at the panel's edge
                Item { x: plan.railW; y: app.t.height.header + 1; width: plan.w - 400 - plan.railW; height: plan.h; clip: true
                Column {
                    x: 12; y: 3; width: (plan.folded ? plan.w - plan.railW : plan.w - 400 - plan.railW) - 24
                    ListRow { width: parent.width; glyph: "music_note"; name: "Undertow - Mara Velde.mp3"; facts: ["18:02"]; factWidths: [56] }
                    ListRow { width: parent.width; glyph: "deployed_code"; name: "tacit-1.1.7-x86_64.iso"; facts: ["16:15"]; factWidths: [56]; selected: true }
                    ListRow { width: parent.width; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; facts: ["14:40"]; factWidths: [56] }
                    ListRow { width: parent.width; glyph: "folder"; name: "Taxes 2026"; facts: ["12 items"]; factWidths: [56] }
                }
                }
                DockedPanel { x: plan.w - 400; y: app.t.height.header + 1; height: plan.h - app.t.height.header - 1; open: true
                    Column { x: 24; y: 22; width: 352; spacing: 2
                        TacitText { text: "Lease agreement.pdf"; size: "body"; weight: "medium" }
                        TacitText { text: "PDF document, 2.2 MB"; ink: "sec" } } }
            }
            Rectangle { id: mask; visible: false; layer.enabled: true; width: plan.w; height: plan.h; radius: 18 }
            Rectangle { x: -1; y: -1; width: plan.w + 2; height: plan.h + 2; radius: 19; color: "transparent"; border.width: 1; border.color: Qt.rgba(1, 1, 1, 0.10) }
        }
        // the header's height on the left; across the top, the rail, the page between and the panel
        DocDim { vertical: true; from: 0; to: app.t.height.header * plan.k; at: -24; n: String(app.t.height.header) }
        DocDim { from: 0; to: plan.railW * plan.k; at: -16; flip: true; n: String(plan.railW) }
        DocDim { from: plan.railW * plan.k; to: (plan.w - 400) * plan.k; at: -16; flip: true; n: String(plan.w - 400 - plan.railW) }
        DocDim { from: (plan.w - 400) * plan.k; to: plan.w * plan.k; at: -16; flip: true; n: "400" }
    }
    F { n: "full"; Plan { w: 1000 } }
    F { n: "half"; Plan { w: 560; folded: true } }
}
