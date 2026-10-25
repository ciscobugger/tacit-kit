// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// Text as every Tacit surface draws it: Tacit Sans on its wght axis (450 for ordinary text, as the shell), native
// rendering without hinting (Tacit's text standard), sizes and inks by role, never dimmed by opacity.
//   size: display, alarm, headline, section, body, row, fileText, meta
//   ink:  main, sec, meta, faint, quiet, past, accent, risk, onAccent, and for text on the overlay (a menu) overlayMeta and
//         overlayRisk, which reach Lc 75 on its lit line as meta and risk do on the page
//   weight: regular, medium, strong
//   cut:  main, display (one-line titles), numbers (tabular figures), code
Text {
    id: words
    property string size: "row"
    property string ink: "main"
    property string weight: "regular"
    property string cut: "main"

    readonly property int axis: Kit.tokens.weight[weight] ?? Kit.tokens.weight.regular
    readonly property var inks: ({ main: Kit.tokens.inkMain, sec: Kit.tokens.inkSec, meta: Kit.tokens.inkMeta,
        faint: Kit.tokens.inkFaint, quiet: Kit.tokens.quiet, past: Kit.tokens.past, accent: Kit.tokens.accent,
        risk: Kit.tokens.risk, onAccent: Kit.tokens.inkOnAccent,
        overlayMeta: Kit.tokens.overlayMeta, overlayRisk: Kit.tokens.overlayRisk })

    color: inks[ink] ?? Kit.tokens.inkMain
    renderType: Text.NativeRendering
    font.family: Kit.tokens.font[cut] ?? Kit.tokens.font.main
    font.pixelSize: Kit.tokens.size[size] ?? Kit.tokens.size.row
    font.weight: axis
    font.variableAxes: ({ "wght": axis, "wdth": 100 })
    font.hintingPreference: Font.PreferNoHinting
    font.features: cut === "numbers" ? ({ "tnum": 1 }) : ({})
}
