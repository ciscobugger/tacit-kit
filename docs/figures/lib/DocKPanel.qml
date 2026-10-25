// What a docked panel is made of, for figures that need a panel's ground without the panel's motion: the page lifted by
// the action wash (tokens wash.action) in the panel's corner.
import QtQuick
import Tacit.Kit

Rectangle {
    radius: Kit.tokens.radius.panel
    color: Qt.alpha(Kit.tokens.inkMain, Kit.tokens.wash.action)
}
