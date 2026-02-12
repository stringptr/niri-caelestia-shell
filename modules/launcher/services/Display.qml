pragma Singleton

import qs.modules.launcher
import qs.config
import qs.utils
import Quickshell
import QtQuick

Searcher {
    id: root

    function transformSearch(search: string): string {
        return search.slice(`${Config.launcher.systemPrefix}display `.length);
    }

    list: [
        Profile {
            profile: "60.002"
            icon: "density_large"
            name: qsTr("60 Hz")
            desc: qsTr("Variable Refresh-Rate Isn't Guaranteed.Lighter power usage, for everyday usage")
        },
        Profile {
            profile: "144.000"
            icon: "format_align_justify"
            name: qsTr("144 Hz")
            desc: qsTr("Variable Refresh-Rate Guaranteed.")
        }
    ]
    useFuzzy: Config.launcher.useFuzzy.system

    component Profile: QtObject {
        required property string profile
        required property string icon
        required property string name
        required property string desc

        function onClicked(list: AppList): void {
            list.visibilities.launcher = false;

            const mode = `1920x1080@${profile}`;

            Quickshell.execDetached([
                "/bin/sh",
                "-c",
                `sed -i 's|mode "1920x1080@[0-9.]*"|mode "${mode}"|g' "$HOME/.config/niri/config.kdl" \
                && notify-send -u low -a "System Notification" "${name} refresh rate activated."`
            ]);
        }
    }
}
