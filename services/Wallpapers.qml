pragma Singleton

import qs.services
import qs.config
import qs.utils
import Caelestia.Models
import Quickshell
import Quickshell.Io
import QtQuick

Searcher {
    id: root

    readonly property string currentNamePath: `${Paths.state}/wallpaper/path.txt`
    readonly property list<string> smartArg: Config.services.smartScheme ? [] : ["--no-smart"]

    property bool showPreview: false
    readonly property string current: showPreview ? previewPath : actualCurrent
    property string previewPath
    property string actualCurrent
    property bool previewColourLock

    function setWallpaper(path: string): void {
        actualCurrent = path;
        persistWallpaperProc.wallpaperPath = path;
        persistWallpaperProc.running = true;
        updateFastfetchLogoProc.wallpaperPath = path;
        updateFastfetchLogoProc.running = true;
        updateWallustColorPalettes.wallpaperPath = path;
        updateWallustColorPalettes.running = true;
        updateMatugenColorPalettes.wallpaperPath = path;
        updateMatugenColorPalettes.running = true;
        Quickshell.execDetached(["caelestia", "wallpaper", "-f", path, ...smartArg]);
    }

    function preview(path: string): void {
        previewPath = path;
        showPreview = true;

        if (Colours.scheme === "dynamic")
            getPreviewColoursProc.running = true;
    }

    function stopPreview(): void {
        showPreview = false;
        if (!previewColourLock)
            Colours.showPreview = false;
    }

    list: wallpapers.entries
    key: "relativePath"
    useFuzzy: Config.launcher.useFuzzy.wallpapers
    extraOpts: useFuzzy ? ({}) : ({
            forward: false
        })

    IpcHandler {
        function get(): string {
            return root.actualCurrent;
        }

        function set(path: string): void {
            root.setWallpaper(path);
        }

        function list(): string {
            return root.list.map(w => w.path).join("\n");
        }

        target: "wallpaper"
    }

    FileView {
        path: root.currentNamePath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            root.actualCurrent = text().trim();
            root.previewColourLock = false;
            updateFastfetchLogoProc.wallpaperPath = root.actualCurrent;
            updateFastfetchLogoProc.running = true;
        }
    }

    FileSystemModel {
        id: wallpapers

        recursive: true
        path: Paths.wallsdir
        filter: FileSystemModel.Images
    }

    Process {
        id: getPreviewColoursProc

        command: ["caelestia", "wallpaper", "-p", root.previewPath, ...root.smartArg]
        stdout: StdioCollector {
            onStreamFinished: {
                Colours.load(text, true);
                Colours.showPreview = true;
            }
        }
    }

    Process {
        id: persistWallpaperProc

        property string wallpaperPath: ""
        command: ["bash", "-c", `mkdir -p '${Paths.state}/wallpaper' && echo '${wallpaperPath}' > '${root.currentNamePath}'`]
    }

    Process {
        id: updateFastfetchLogoProc

        property string wallpaperPath: ""
        command: ["bash", "-c", `test -f ~/.config/fastfetch/config.jsonc && new_path='$HOME/Pictures/Wallpapers/'"$(basename '${wallpaperPath}')" && sed -i -E 's|"source"\\s*:\\s*"[^"]*"|"source": "'"$new_path"'"|' ~/.config/fastfetch/config.jsonc`]
    }

    Process {
        id: updateWallustColorPalettes

        property string wallpaperPath: ""
        command: ["bash", "-c", `new_path="$HOME/Pictures/Wallpapers/$(basename '${wallpaperPath}')" && wallust run "$new_path"`]
    }
    Process {

        id: updateMatugenColorPalettes

        property string wallpaperPath: ""
        command: ["bash", "-c", `new_path="$HOME/Pictures/Wallpapers/$(basename '${wallpaperPath}')" && matugen image -t scheme-content --source-color-index 0 "$new_path"`]
    }
}
