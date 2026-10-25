import QtQuick
import Quickshell
import qs.modules.common
import qs.services

// Kit P2 parity: every Tacit token as the shell resolves it, one per line (colours as 8-bit hex and 16-bit channels).
// Not committed. Run with qs -p offscreen; XDG_STATE_HOME picks the palette.
ShellRoot {
    Component.onCompleted: MaterialThemeLoader.reapplyTheme()
    Timer {
        interval: 1500; running: true
        onTriggered: {
            const colours = ["inkMain", "inkSec", "inkMeta", "inkFaint", "hairline", "accent", "inkOnAccent", "risk", "ground",
                "raised", "raisedHot", "windowGround", "container", "quiet", "past"];
            for (const k of colours) {
                const c = Tacit[k];
                if (c === undefined) continue;
                const u = v => Math.round(v * 65535);
                console.log("DUMP colour", k, c.toString(), u(c.r), u(c.g), u(c.b), u(c.a));
            }
            console.log("DUMP real windowSeeThrough", Tacit.windowSeeThrough);
            {
                const u = v => Math.round(v * 65535);
                const fresh = Appearance.inkFor(92), bound = Appearance.colors.colInkMain;
                console.log("DUMP check inkFor92-now", fresh.toString(), u(fresh.r), u(fresh.g), u(fresh.b));
                console.log("DUMP check colInkMain-bound", bound.toString(), u(bound.r), u(bound.g), u(bound.b));
                console.log("DUMP check onAccent-type", typeof Tacit.onAccent, String(Tacit.onAccent));
            }
            for (const k of ["m3onBackground", "m3surfaceContainerLow", "m3surfaceContainer", "m3primary", "m3onPrimary", "m3error", "m3background"]) {
                const c = Appearance.m3colors[k];
                const u = v => Math.round(v * 65535);
                console.log("DUMP palette", k, c.toString(), u(c.r), u(c.g), u(c.b), u(c.a));
            }
            for (const g of ["size", "radius", "wash", "space", "height", "width", "icon", "state"]) {
                const o = Tacit[g];
                if (!o) continue;
                for (const k of Object.keys(o).sort())
                    if (typeof o[k] === "number") console.log("DUMP", g, k, o[k]);
            }
            if (Tacit.motion)
                for (const k of Object.keys(Tacit.motion).sort())
                    if (Tacit.motion[k] && Tacit.motion[k].ms !== undefined) console.log("DUMP motion", k, Tacit.motion[k].ms, JSON.stringify(Tacit.motion[k].curve));
            Qt.quit();
        }
    }
}
