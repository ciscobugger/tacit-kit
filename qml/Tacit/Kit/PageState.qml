// SPDX-License-Identifier: LGPL-3.0-or-later
import QtQuick

// PageState: what stands where the content would be when there is none, or it failed (not "State", which is
// QtQuick's own type): one sentence that says what happened and
// what to do, at most one action, no picture. A failure carries the warning symbol in the risk ink. Put it where the
// first row would start (40 in from the page, 104 down); it is never centred in the page. Loading is not a state
// screen: rows appear as they are read, and the page header's line shows the reading (PageHeader.loading).
// A screen reader hears a failure as an alert, an empty page as plain text.
Column {
    id: say
    property string text
    property bool failure: false
    property string action: ""
    property real maxWidth: 560      // the sentence wraps here; set it for a narrow column
    signal activated()

    spacing: Kit.tokens.space.l
    Accessible.role: failure ? Accessible.AlertMessage : Accessible.StaticText
    Accessible.name: say.text

    Row {
        spacing: 10
        Symbol { visible: say.failure; anchors.verticalCenter: parent.verticalCenter; text: "warning"; color: Kit.tokens.risk }
        TacitText { text: say.text; size: "body"; wrapMode: Text.WordWrap; width: Math.min(implicitWidth, say.maxWidth) }
    }
    Slab { visible: say.action !== ""; text: say.action; tone: "default"; onActivated: say.activated() }
}
