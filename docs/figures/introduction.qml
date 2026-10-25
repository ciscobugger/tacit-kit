// Introduction's opening: a Tacit app on the wallpaper, made only of kit parts (a page header and a row list).
import QtQuick
import Tacit.Kit

DocFigures {
    id: app
    figures: [["hero", 760, 330]]
    DocWindow {
        visible: app.fig === "hero"
        anchors.fill: parent
        wx: 56; wy: 36; wallX: -400; wallY: -600
        PageHeader { width: 704; canGoBack: false; crumbs: ["Music"]; here: "Low Tide" }
        Column {
            x: 12; y: 90; width: 656
            ListRow { width: parent.width; glyph: "music_note"; name: "Undertow"; aside: "Mara Velde"; facts: ["5:01"]; factWidths: [64]; selected: true }
            ListRow { width: parent.width; glyph: "music_note"; name: "Salt and Lamp"; aside: "Mara Velde"; facts: ["3:48"]; factWidths: [64] }
            ListRow { width: parent.width; glyph: "music_note"; name: "Harbour Clock"; aside: "Mara Velde"; facts: ["4:12"]; factWidths: [64]; previewState: "hover" }
            ListRow { width: parent.width; glyph: "music_note"; name: "Lease"; aside: "Mara Velde, Ines Okoro"; facts: ["6:30"]; factWidths: [64] }
        }
    }
}
