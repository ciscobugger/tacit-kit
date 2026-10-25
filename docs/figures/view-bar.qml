// View bar page's figures: the bar under a header in a window (hero), anatomy, states (rest, Filter on, a filter on and
// wrapped), the two menus drawn in place, sizes, two judged examples. The approved look: ~/Pictures/tacit-kit-v0/proposal/view-*.png.
import QtQuick
import Quickshell
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 200], ["states", 760, 300], ["menu-kind", 760, 400], ["menu-order", 760, 580],
              ["sizes", 760, 200], ["do-fields", 418, 160], ["dont-tokens", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens
    readonly property var orderItems: [{ label: "Newest first", checked: true }, { label: "Oldest first" }, { label: "Name" }]

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        PageHeader {
            width: hw.shown; crumbs: ["Home"]; here: "Downloads"
            SearchField { anchors.verticalCenter: parent.verticalCenter; scope: "Downloads"; fieldWidth: 240 }
        }
        ViewBar { y: 73; width: hw.shown; count: "9 items"; order: "Newest first"; views: ["List", "Grid", "Gallery"]; orderItems: app.orderItems }
        Column {
            x: 12; y: 73 + 44; width: hw.shown - 36
            SectionHeading { text: "Today" }
            ListRow { width: parent.width; focusable: false; picture: app.pics + "p11.jpg"; name: "ov02c10-capture.png"; facts: ["640 kB", "11:20"] }
            ListRow { width: parent.width; focusable: false; glyph: "picture_as_pdf"; name: "Lease agreement.pdf"; aside: "docs.google.com"; facts: ["2.2 MB", "14:40"] }
        }
    }

    F { n: "anatomy"
        // the bar's right side as ViewBar lays it out: Filter, the order and the views in a Row, 16 apart, 16 from the end
        MenuButton { id: mFilter; visible: false; text: "Filter" }
        MenuButton { id: mOrder; visible: false; text: "Newest first" }
        Tabs { id: mViews; visible: false; labels: ["List", "Grid", "Gallery", "Columns"]; current: 0 }
        TacitText { id: mCount; visible: false; text: "9 items"; ink: "meta"; cut: "numbers" }
        Item {
            id: anat
            readonly property real topLine: -26
            readonly property real l: Kit.tokens.space.l
            readonly property real fx: 700 - l - (mFilter.implicitWidth + mOrder.implicitWidth + mViews.implicitWidth + 2 * l)
            readonly property real ox: fx + mFilter.implicitWidth + l
            readonly property real vx: ox + mOrder.implicitWidth + l
            x: 24; y: 96; width: 700; height: 44
            ViewBar { width: 700; count: "9 items"; order: "Newest first"; views: ["List", "Grid", "Gallery", "Columns"]; orderItems: app.orderItems }
            DocCallout { n: 1; side: "top"; line: anat.topLine
                         rect: Qt.rect(28, (44 - mCount.implicitHeight) / 2, mCount.implicitWidth, mCount.implicitHeight) }
            DocCallout { n: 2; side: "top"; line: anat.topLine
                         rect: Qt.rect(anat.fx, (44 - mFilter.implicitHeight) / 2, mFilter.implicitWidth, mFilter.implicitHeight) }
            DocCallout { n: 3; side: "top"; line: anat.topLine
                         rect: Qt.rect(anat.ox, (44 - mOrder.implicitHeight) / 2, mOrder.implicitWidth, mOrder.implicitHeight) }
            DocCallout { n: 4; side: "top"; line: anat.topLine
                         rect: Qt.rect(anat.vx, (44 - mViews.height) / 2, mViews.implicitWidth, mViews.height) }
        }
    }
    // states: a bar at rest, with Filter on, and with a filter on and the fields on their own line
    F { n: "states"
        Column {
            x: 0; y: 40; width: 760; spacing: 22
            Item { width: 760; height: 44
                DocMarker { n: 1; x: 38; y: 11 }
                ViewBar { x: 74; width: 660; count: "9 items"; order: "Newest first"; views: ["List", "Grid"]; orderItems: app.orderItems } }
            Item { width: 760; height: 44
                DocMarker { n: 2; x: 38; y: 11 }
                ViewBar { x: 74; width: 660; filtering: true; order: "Newest first"; views: ["List", "Grid"]; orderItems: app.orderItems
                    FilterField { label: "Kind"; value: "Any" }
                    FilterField { label: "Size"; value: "Any" } } }
            Item { width: 760; height: 88
                DocMarker { n: 3; x: 38; y: 11 }
                ViewBar { x: 74; width: 660; filtering: true; active: true; shown: "3 of 9"; order: "Newest first"; views: ["List", "Grid"]; orderItems: app.orderItems
                    FilterField { label: "Kind"; value: "Pictures"; on: true }
                    FilterField { label: "Modified"; value: "Last 7 days"; on: true }
                    FilterField { label: "Size"; value: "Any" } } }
        }
    }

    F { n: "menu-kind"
        Item { x: 6; y: 54; width: 760; height: 260
            ViewBar { id: kb; x: 10; width: 740; filtering: true; order: "Newest first"; views: ["List", "Grid"]; orderItems: app.orderItems
                FilterField { label: "Kind"; value: "Pictures"; on: true }
                FilterField { label: "Size"; value: "Any" } }
            MenuSurface { x: 10 + 16 + 34; y: 40
                items: [{ heading: true, label: "Kind" },
                        { label: "Folders", detail: 0 }, { label: "Pictures", checked: true, detail: 3, keepOpen: true },
                        { label: "Documents", detail: 3, keepOpen: true }, { label: "Music", detail: 1, keepOpen: true },
                        { label: "Archives", detail: 1, keepOpen: true }, { rule: true }, { label: "Any kind" }]
                cursor: 4 }
        }
    }
    F { n: "menu-order"
        Item { x: 0; y: 41; width: 760; height: 400
            ViewBar { x: 30; width: 700; count: "9 items"; order: "Newest first"; views: ["List", "Grid", "Gallery", "Columns"]; orderItems: app.orderItems }
            MenuSurface { id: om; x: 173; y: 40
                items: [{ heading: true, label: "Sort by" }, { label: "Name" }, { label: "Kind" }, { label: "Date modified", checked: true },
                        { label: "Size" }, { rule: true },
                        { heading: true, label: "Order" }, { label: "Newest first", checked: true }, { label: "Oldest first" }, { rule: true },
                        { heading: true, label: "Group by" }, { label: "None" }, { label: "Date", checked: true }, { label: "Kind" }, { rule: true },
                        { label: "Show hidden files", detail: "Ctrl+H" }]
                cursor: 13 }
        }
    }

    F { n: "sizes"
        Item { id: m
            readonly property real k: 1.5
            // 49 px of dimension line to the left, 39 below
            x: (parent.width - 430 * k - 49) / 2 + 49; y: (parent.height - 44 * k - 39) / 2
            Item { scale: m.k; transformOrigin: Item.TopLeft; width: 430; height: 44
                ViewBar { width: 430; count: "9 items"; order: "Name"; views: ["List", "Grid"]; orderItems: app.orderItems } }
            DocDim { vertical: true; from: 0; to: 44 * m.k; at: -24; n: "44" }
            DocDim { from: 0; to: 28 * m.k; at: 44 * m.k + 16; n: "28" }
            DocDim { from: (430 - 16) * m.k; to: 430 * m.k; at: 44 * m.k + 16; n: "16" }
        }
    }

    F { n: "do-fields"
        DocCentre { cw: 380
            ViewBar { x: 6; y: 56; width: 380; filtering: true; order: "Name"; views: ["List", "Grid"]; orderItems: app.orderItems
                FilterField { label: "Genre"; value: "Any" }
                FilterField { label: "Year"; value: "Any" } }
        }
    }
    // drawn by hand: a filter of tokens in the search field (rejected)
    F { n: "dont-tokens"
        Item { x: 24; y: 62; width: 370; height: 36
            Rectangle { anchors.fill: parent; radius: app.t.radius.slab; color: app.t.container; opacity: 1 - app.t.windowSeeThrough }
            Symbol { x: 10; anchors.verticalCenter: parent.verticalCenter; text: "search"; color: app.t.inkMain }
            Row { x: 40; anchors.verticalCenter: parent.verticalCenter; spacing: 6
                Repeater { model: ["Kind: Pictures", "Modified: 7 days"]
                    Rectangle { required property string modelData; height: 24; width: tl.implicitWidth + 16; radius: 12; color: Qt.alpha(app.t.inkMain, 0.12)
                        anchors.verticalCenter: parent.verticalCenter
                        TacitText { id: tl; anchors.centerIn: parent; text: parent.modelData; size: "meta"; ink: "main" } } }
            }
        }
    }
}
