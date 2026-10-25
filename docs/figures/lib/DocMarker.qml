// A numbered ring, as the callouts draw theirs (DocCallout.qml) and the page draws its legend: an outline in the secondary
// ink, the number in the main ink centred by its ink. States strips number their columns with it.
import QtQuick
import Tacit.Kit

Rectangle {
    property int n
    width: 22; height: 22; radius: 11
    color: "transparent"; border.width: 1; border.color: Kit.tokens.inkSec
    TacitText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 11 + 0.354 * font.pixelSize - baselineOffset
        text: String(parent.n); size: "meta"; weight: "medium"; cut: "numbers"
    }
}
