pragma Singleton

import qs.config
import Caelestia
import Quickshell

Singleton {
    id: root

    readonly property string home: Quickshell.env("HOME")
    readonly property string documents: Quickshell.env("XDG_DOCUMENTS_DIR") || `${home}/Documents`
    readonly property string pictures: Quickshell.env("XDG_PICTURES_DIR") || `${home}/Pictures`
    readonly property string videos: Quickshell.env("XDG_VIDEOS_DIR") || `${home}/Videos`

    readonly property string data: `${Quickshell.env("XDG_DATA_HOME") || `${home}/.local/share`}/quickshell/caelestia_experimental`
    readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`}/quickshell/caelestia_experimental`
    readonly property string cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}/quickshell/caelestia_experimental`
    readonly property string config: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}/quickshell/caelestia_experimental`

    readonly property string imagecache: `${cache}/imagecache`
    readonly property string notifimagecache: `${imagecache}/notifs`
    readonly property string wallsdir: Quickshell.env("CAELESTIA_WALLPAPERS_DIR") || absolutePath(Config.paths.wallpaperDir)
    readonly property string libdir: `${config}/build/qml/Caelestia` || "/usr/lib/caelestia"
    // readonly property string notifhistorydir: `${documents}/NotifHistory`
    readonly property string notifhistorydir: `${documents}`
    readonly property string globalricedir: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}/rice`
    readonly property string recsdir: Quickshell.env("CAELESTIA_RECORDINGS_DIR") || `${videos}/Recordings`

    function toLocalFile(path: url): string {
        path = Qt.resolvedUrl(path);
        return path.toString() ? CUtils.toLocalFile(path) : "";
    }

    function absolutePath(path: string): string {
        return toLocalFile(path.replace("~", home));
    }

    function shortenHome(path: string): string {
        return path.replace(home, "~");
    }
}
