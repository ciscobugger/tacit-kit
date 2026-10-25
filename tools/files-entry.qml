//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
// Files alone, for the hidden test display (tools/files-run.sh): the shell's Files windows and nothing else,
// driven over IPC target "pt".
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.ii.files

ShellRoot {
    // the palette: the loader is a lazy singleton that only the shell's own shell.qml starts; without this Files is
    // drawn in Appearance's built-in colours whatever PAL says
    Component.onCompleted: MaterialThemeLoader.reapplyTheme()
    FilesPanel { id: panel }
    IpcHandler {
        target: "pt"
        function open(folder: string): void { Files.open(folder, ""); }
        function shot(path: string): string {
            const w = panel.newest();
            if (!w) return "no window";
            let best = null;
            const kids = w.contentItem.children;
            for (let i = 0; i < kids.length; i++) { const c = kids[i]; if (!best || c.width * c.height > best.width * best.height) best = c; }
            if (!best) return "no child";
            const ok = best.grabToImage(r => r.saveToFile(path));
            return `grab ${ok} ${best.width}x${best.height} of ${kids.length}`;
        }
        function count(): int { return panel.windows.length; }
        function view(v: string): void { panel.newest().setView(v); }
        function zoom(step: int): string { const w = panel.newest(); w.zoomGrid(step); return `${w.view} ${w.gridSize}`; }
        function selectAll(): void { panel.newest().selectAll(); }
        function newFile(): void { panel.newest().newFile(); }
        function compress(): void { panel.newest().compressSelection(); }
        function renameMany(m: string, a: string, b: string): string { const w = panel.newest(); w.renameMany(); w.presetRename(m, a, b); return w.renamePlan(); }
        function applyRename(): void { panel.newest().applyRenameSheet(); }
        function status(): string { const w = panel.newest(); return w.statusLine + " | " + w.freeLine; }
    }
}
