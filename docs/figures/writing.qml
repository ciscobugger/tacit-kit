// Writing: an error that says what happened and what to do, against one that does not.
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["do-error", 418, 160], ["dont-error", 418, 160]]
    component F: Item { property string n; visible: app.fig === n; anchors.fill: parent; DocGlass { anchors.fill: parent } }
    F { n: "do-error"
        DocCentre { cw: 214
            PageState { x: 0; y: 34; width: 360; failure: true; text: "Lease.pdf is in use.\nClose it, then try again."; action: "Try again" }
        }
    }
    F { n: "dont-error"
        DocCentre { cw: 275
            PageState { x: 0; y: 34; width: 360; failure: true; text: "Oops! Something went wrong.\nPlease try again later."; action: "OK" }
        }
    }
}
