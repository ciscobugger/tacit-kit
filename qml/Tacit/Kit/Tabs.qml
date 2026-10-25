// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// A few views of one thing, as words (Praxis's panel tabs): the chosen word in the main ink and strong weight over a
// 2 px accent line as wide as the word, the others in the secondary ink. One tab stop; ← → move between the words and
// choose, Home and End go to the first and the last. Each word is 32 high and as wide as the word and 12 either side. For up to four; more is a menu.
Row {
    id: tabs
    property var labels: []
    property int current: 0
    property int previewHover: -1
    property string previewState: ""   // "focus" rings the current word, for the catalogue and the docs
    property string label: "Views"     // what a screen reader calls the group
    signal picked(int index)

    activeFocusOnTab: true
    Accessible.role: Accessible.PageTabList
    Accessible.name: label

    Keys.onPressed: event => {
        Kit.focusVisible = true;
        const to = event.key === Qt.Key_Left ? tabs.current - 1 : event.key === Qt.Key_Right ? tabs.current + 1
                 : event.key === Qt.Key_Home ? 0 : event.key === Qt.Key_End ? tabs.labels.length - 1 : -1;
        if (to < 0 || to >= tabs.labels.length) return;
        tabs.picked(to);
        event.accepted = true;
    }

    Repeater {
        model: tabs.labels
        Item {
            id: tab
            required property string modelData
            required property int index
            readonly property bool chosen: index === tabs.current
            readonly property bool hovered: tabHover.hovered || tabs.previewHover === index
            width: word.implicitWidth + 2 * Kit.tokens.space.m
            height: 32
            Accessible.role: Accessible.PageTab
            Accessible.name: modelData
            Accessible.selected: chosen
            Accessible.onPressAction: tabs.picked(index)

            FocusRing { shown: tab.chosen && ((tabs.activeFocus && Kit.focusVisible) || tabs.previewState === "focus") }
            TacitText {
                id: word
                anchors.centerIn: parent
                text: tab.modelData
                ink: tab.chosen || tab.hovered ? "main" : "sec"
                weight: tab.chosen ? "strong" : "regular"
            }
            Rectangle {
                visible: tab.chosen
                anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 1 }
                width: word.implicitWidth; height: 2; radius: 1
                color: Kit.tokens.accent
            }
            HoverHandler { id: tabHover; cursorShape: Qt.PointingHandCursor }
            TapHandler { onTapped: { Kit.focusVisible = false; tabs.picked(tab.index); } }
        }
    }
}
