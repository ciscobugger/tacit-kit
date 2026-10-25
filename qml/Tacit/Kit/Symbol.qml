// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// One of Tacit's symbols, by name. Sizes: Kit.tokens.icon (rail 17, rows and tools 20, back and forward 22).
Text {
    id: symbol
    property bool filled: false
    property int size: Kit.tokens.icon.row

    color: Kit.tokens.inkSec
    font.family: filled ? Kit.symbolFill.name : Kit.symbolLine.name
    font.pixelSize: size
    font.hintingPreference: Font.PreferNoHinting
    renderType: Text.NativeRendering
    width: size
    height: size
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    Accessible.ignored: true
}
