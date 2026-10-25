// Rail page's figures: Files' rail in a window (hero), anatomy (Music's rail, with its action), the states of a rail
// row, open and folded, sizes, two judged examples.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330], ["anatomy", 760, 400], ["states", 760, 300], ["folded", 760, 300], ["sizes", 760, 200], ["do-groups", 418, 300], ["dont-flat", 418, 300]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    readonly property var t: Kit.tokens

    DocWindow {
        id: hw
        visible: app.fig === "hero"
        anchors.fill: parent
        Rail {
            height: parent.height
            RailRow { glyph: "schedule"; label: "Recent"; fresh: true }
            RailSection { text: "Places" }
            RailRow { glyph: "home"; label: "Home" }
            RailRow { glyph: "desktop_windows"; label: "Desktop" }
            RailRow { glyph: "description"; label: "Documents"; previewState: "hover" }
            RailRow { glyph: "download"; label: "Downloads"; current: true }
            RailRow { glyph: "image"; label: "Pictures" }
            RailSection { text: "Drives" }
            RailRow { glyph: "usb"; label: "TRANSFER"; context: "41 GB free" }
        }
        PageHeader { x: 300; width: hw.shown - 300; crumbs: ["Home"]; here: "Downloads"; canGoBack: true }
    }

    F { n: "anatomy"
        // the pieces' sizes, measured as the rail sets them
        TacitText { id: mWords; visible: false; text: "Library"; ink: "sec"; weight: "strong" }
        TacitText { id: mCount; visible: false; text: "3"; size: "meta"; cut: "numbers" }
        TacitText { id: mHeld; visible: false; text: "15"; size: "meta"; cut: "numbers" }
        Item {
            id: anat
            // rows start at 104 (the action's foot and 16); the section is 34 high, each row 32
            readonly property real rowY: 104 + 34
            x: (parent.width - 300) / 2; y: (parent.height - 290) / 2; width: 300; height: 290
            Rail { height: 290; action: "Shuffle all"; actionSymbol: "shuffle"
                RailSection { text: "Library"; count: 3 }
                RailRow { glyph: "graphic_eq"; label: "Playing"; current: true }
                RailRow { glyph: "artist"; label: "Artists"; context: "15" }
                RailRow { glyph: "note_stack"; label: "Albums"; fresh: true }
                RailRow { glyph: "music_note"; label: "Songs"; context: "177" }
            }
            DocCallout { n: 1; side: "left"; line: -44; rect: Qt.rect(12, 8, 36, 36) }
            DocCallout { n: 2; side: "left"; line: -44; rect: Qt.rect(12, 52, 276, 36) }
            DocCallout { n: 3; side: "left"; line: -44
                         rect: Qt.rect(20, 104 + 26 - mWords.implicitHeight, mWords.implicitWidth + 8 + mCount.implicitWidth, mWords.implicitHeight) }
            DocCallout { n: 4; side: "right"; line: anat.width + 44; surface: true; rect: Qt.rect(8, anat.rowY + 1, 284, 30) }
            DocCallout { n: 5; side: "right"; line: anat.width + 44
                         rect: Qt.rect(280 - mHeld.implicitWidth, anat.rowY + 32 + 16 - mHeld.implicitHeight / 2, mHeld.implicitWidth, mHeld.implicitHeight) }
            DocCallout { n: 6; side: "right"; line: anat.width + 44; rect: Qt.rect(274, anat.rowY + 64 + 13, 6, 6) }
        }
    }

    // states: seven rows in two columns, a number beside each
    F { n: "states"
        Row {
            anchors.centerIn: parent; spacing: 40
            Column { spacing: 12
                Repeater { model: [{ n: 1 }, { n: 2, s: "hover" }, { n: 3, s: "pressed" }, { n: 4, c: true }]
                    Item { required property var modelData; width: 330; height: 40
                        DocMarker { n: parent.modelData.n; y: 9 }
                        RailRow { x: 30; y: 4; glyph: "download"; label: "Name"; context: "Fact"; current: parent.modelData.c === true; previewState: parent.modelData.s ?? "" } } }
            }
            Column { spacing: 12
                Repeater { model: [{ n: 5, c: true, s: "hover" }, { n: 6, s: "focus" }, { n: 7, f: true }]
                    Item { required property var modelData; width: 330; height: 40
                        DocMarker { n: parent.modelData.n; y: 9 }
                        RailRow { x: 30; y: 4; glyph: "download"; label: "Name"; context: parent.modelData.f ? "" : "Fact"; fresh: parent.modelData.f === true
                            current: parent.modelData.c === true; previewState: parent.modelData.s ?? "" } } }
            }
        }
    }

    F { n: "folded"
        Item { x: 60; y: 24; width: 300; height: 252
            Rail { height: 252; action: "Shuffle all"; actionSymbol: "shuffle"
                RailRow { glyph: "graphic_eq"; label: "Playing"; current: true }
                RailSection { text: "Library" }
                RailRow { glyph: "artist"; label: "Artists"; context: "15" }
                RailRow { glyph: "music_note"; label: "Songs"; context: "177" } }
        }
        Item { x: 440; y: 24; width: 56; height: 252
            Rail { height: 252; folded: true; action: "Shuffle all"; actionSymbol: "shuffle"
                RailRow { glyph: "graphic_eq"; label: "Playing"; current: true }
                RailSection { text: "Library" }
                RailRow { glyph: "artist"; label: "Artists"; context: "15" }
                RailRow { glyph: "music_note"; label: "Songs"; context: "177" } }
        }
        TacitText { x: 520; y: 120; text: "56 wide, symbols only"; ink: "meta"; size: "meta"; cut: "numbers" }
    }

    F { n: "sizes"
        Item {
            id: m
            readonly property real k: 1.5
            x: (parent.width - 450 - 49) / 2 + 49; y: (parent.height - 48 - 87) / 2 + 48; width: 450; height: 150
            Item { scale: m.k; transformOrigin: Item.TopLeft; width: 300; height: 120
                RailRow { y: -32; opacity: 0.4; glyph: "home"; label: "Name" }
                RailRow { glyph: "download"; label: "Name"; context: "Fact"; current: true }
            }
            // 20 | 24 from the edge to the name, 20 at the end; the height on the left
            DocDim { from: 0; to: 20 * m.k; at: 32 * m.k + 16; n: "20" }
            DocDim { from: 20 * m.k; to: 44 * m.k; at: 32 * m.k + 16; n: "24" }
            DocDim { from: 280 * m.k; to: 300 * m.k; at: 32 * m.k + 16; n: "20" }
            DocDim { vertical: true; from: 0; to: 32 * m.k; at: -24; n: "32" }
        }
    }

    // do: places in groups under labels
    F { n: "do-groups"
        DocCentre {
            Item { x: 60; y: 6; width: 300; height: 248
                Rail { height: 248
                    RailSection { text: "Places" }
                    RailRow { glyph: "home"; label: "Home" }
                    RailRow { glyph: "download"; label: "Downloads"; current: true }
                    RailRow { glyph: "image"; label: "Pictures" }
                    RailSection { text: "Drives" }
                    RailRow { glyph: "usb"; label: "TRANSFER"; context: "41 GB free" }
                } }
        }
    }
    F { n: "dont-flat"
        DocCentre {
            Item { x: 60; y: 6; width: 300; height: 248
                Rail { height: 248
                    RailRow { glyph: "home"; label: "Home" }
                    RailRow { glyph: "download"; label: "Downloads"; current: true }
                    RailRow { glyph: "image"; label: "Pictures" }
                    RailRow { glyph: "description"; label: "Documents" }
                    RailRow { glyph: "usb"; label: "TRANSFER"; context: "41 GB free" }
                } }
        }
    }
}
