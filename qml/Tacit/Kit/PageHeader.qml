// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// The top of a page: back and forward, the path as the title (the parents in the secondary ink and pressable, the
// page itself strong, all in Tacit Sans Display at headline size), the page's own tools on the right (put them inside
// the header), one hairline across the window under it. 72 high (`fullHeight`, the line included).
// Each parent is a stop for Tab with the focus ring; Enter or Space goes there (`crumbPicked`).
// previewState: crumbHover, crumbFocus (the first parent in its hover ink / with the ring). While the page is still being read (a slow drive),
// `loading` sends an accent stretch along the line; the rows appear as they are read, with no spinner on the page.
// With `Kit.reducedMotion` the stretch stands still at the line's start. A screen reader hears "Loading" in the
// header's description meanwhile (Qt has no busy state to set).
Item {
    id: header
    property var crumbs: []        // the parents, outermost first
    property string here: ""
    property bool canGoBack: true
    property bool canGoForward: false
    property bool loading: false
    property string previewState: ""
    readonly property real fullHeight: Kit.tokens.height.header + 1
    default property alias tools: toolRow.data
    signal back()
    signal forward()
    signal crumbPicked(int index)

    implicitHeight: fullHeight
    implicitWidth: 600
    Accessible.role: Accessible.ToolBar
    Accessible.description: loading ? "Loading" : ""

    Row {
        x: Kit.tokens.space.l
        height: Kit.tokens.height.header
        spacing: Kit.tokens.space.xs
        IconButton { anchors.verticalCenter: parent.verticalCenter; symbol: "arrow_back"; size: Kit.tokens.icon.nav; label: "Back"; enabled: header.canGoBack; onActivated: header.back() }
        IconButton { anchors.verticalCenter: parent.verticalCenter; symbol: "arrow_forward"; size: Kit.tokens.icon.nav; label: "Forward"; enabled: header.canGoForward; onActivated: header.forward() }
        Item { width: Kit.tokens.space.s; height: 1 }
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: Kit.tokens.space.s
            Repeater {
                model: header.crumbs
                Row {
                    id: crumb
                    required property string modelData
                    required property int index
                    spacing: Kit.tokens.space.s
                    Item {
                        id: link
                        width: linkText.implicitWidth; height: linkText.implicitHeight
                        activeFocusOnTab: true
                        readonly property bool preview: crumb.index === 0
                        Accessible.role: Accessible.Link
                        Accessible.name: crumb.modelData
                        Accessible.onPressAction: header.crumbPicked(crumb.index)
                        TacitText {
                            id: linkText
                            text: crumb.modelData
                            size: "headline"; cut: "display"
                            ink: crumbHover.hovered || (link.preview && header.previewState === "crumbHover") ? "main" : "sec"
                        }
                        FocusRing { shown: (link.activeFocus && Kit.focusVisible) || (link.preview && header.previewState === "crumbFocus"); corner: Kit.tokens.radius.row }
                        HoverHandler { id: crumbHover; cursorShape: Qt.PointingHandCursor }
                        TapHandler { onTapped: { Kit.focusVisible = false; header.crumbPicked(crumb.index); } }
                        Keys.onPressed: event => {
                            Kit.focusVisible = true;
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                                header.crumbPicked(crumb.index);
                                event.accepted = true;
                            }
                        }
                    }
                    TacitText { text: "›"; size: "headline"; cut: "display"; ink: "meta"; Accessible.ignored: true }
                }
            }
            TacitText {
                text: header.here
                size: "headline"; cut: "display"; weight: "strong"
                elide: Text.ElideRight
                Accessible.role: Accessible.Heading
                Accessible.name: header.here
            }
        }
    }
    Row {
        id: toolRow
        anchors.right: parent.right
        anchors.rightMargin: Kit.tokens.space.xl
        height: Kit.tokens.height.header
        spacing: Kit.tokens.space.xl
    }
    Rectangle {
        x: Kit.tokens.space.l
        y: Kit.tokens.height.header
        width: parent.width - Kit.tokens.space.l
        height: 1
        color: Kit.tokens.hairline
    }
    Item {
        x: Kit.tokens.space.l
        y: Kit.tokens.height.header - 1
        width: parent.width - Kit.tokens.space.l
        height: 2
        clip: true
        visible: header.loading
        Rectangle {
            id: stretch
            width: 220; height: 2; radius: 1
            color: Kit.tokens.accent
            NumberAnimation on x {
                running: header.loading && !Kit.reducedMotion
                loops: Animation.Infinite
                from: -stretch.width; to: stretch.parent.width
                duration: Kit.motion("sweep").ms
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Kit.motion("sweep").curve
            }
        }
    }
}
