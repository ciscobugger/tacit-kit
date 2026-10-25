// Principles: three do and don't pairs on the calm stage (418 by 196), neutral content.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["do-path", 418, 300], ["dont-subtitle", 418, 300], ["do-words", 418, 300], ["dont-icons", 418, 300],
              ["do-once", 418, 300], ["dont-twice", 418, 300]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }

    F { n: "do-path"
      Item { y: 58; width: parent.width; height: parent.height
        PageHeader { width: parent.width; canGoBack: true; crumbs: ["Files"]; here: "Photos" }
        ListRow { y: 96; x: 12; width: parent.width - 24; glyph: "image"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
        ListRow { y: 140; x: 12; width: parent.width - 24; glyph: "image"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
      }
    }
    F { n: "dont-subtitle"
      Item { y: 54; width: parent.width; height: parent.height
        Item { x: 0; y: 0; width: parent.width; height: 96
            IconButton { x: 16; y: 18; symbol: "arrow_back"; size: 22; label: "Back" }
            IconButton { x: 56; y: 18; symbol: "arrow_forward"; size: 22; label: "Forward"; enabled: false }
            TacitText { x: 108; y: 14; text: "Photos"; size: "headline"; cut: "display"; weight: "strong" }
            TacitText { x: 108; y: 54; text: "Folder, 3 files, 2.9 GB"; ink: "meta" }
            Rectangle { x: 16; y: 96; width: parent.width - 16; height: 1; color: Kit.tokens.hairline }
        }
        ListRow { y: 104; x: 12; width: parent.width - 24; glyph: "image"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
        ListRow { y: 148; x: 12; width: parent.width - 24; glyph: "image"; name: "Name"; facts: ["Fact"]; factWidths: [64] }
      }
    }
    F { n: "do-words"
        DocCentre {
            Column { x: 36; y: 22; width: 300
                WordAction { text: "Open with…"; width: 300 }
                WordAction { text: "Park on the shelf"; width: 300 }
                WordAction { text: "Move to the trash"; risk: true; width: 300 }
            }
        }
    }
    F { n: "dont-icons"
        DocCentre {
            Row { x: 36; y: 70; spacing: 10
                IconButton { symbol: "open_in_new"; label: "Open with" }
                IconButton { symbol: "keep"; label: "Park" }
                IconButton { symbol: "archive"; label: "Archive" }
                IconButton { symbol: "edit"; label: "Rename" }
                IconButton { symbol: "trash"; label: "Move to the trash" }
            }
        }
    }
    F { n: "do-once"
        DocCentre { cw: 370
            SectionHeading { y: 12; text: "Today" }
            ListRow { y: 62; x: 12; width: parent.width; glyph: "picture_as_pdf"; name: "Lease.pdf"; facts: ["2.2 MB", "14:40"]; factWidths: [72, 56] }
            ListRow { y: 106; x: 12; width: parent.width; glyph: "description"; name: "Budget.xlsx"; facts: ["84 kB", "09:12"]; factWidths: [72, 56] }
        }
    }
    F { n: "dont-twice"
        DocCentre { cw: 370
            SectionHeading { y: 12; text: "Today" }
            ListRow { y: 62; x: 12; width: parent.width; glyph: "picture_as_pdf"; name: "Lease.pdf"; facts: ["2.2 MB", "Today 14:40"]; factWidths: [72, 100] }
            ListRow { y: 106; x: 12; width: parent.width; glyph: "description"; name: "Budget.xlsx"; facts: ["84 kB", "Today 09:12"]; factWidths: [72, 100] }
        }
    }
}
