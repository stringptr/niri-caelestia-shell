pragma Singleton

import qs.modules.launcher
import qs.config
import qs.utils
import Quickshell
import QtQuick

Searcher {
    id: root

    function transformSearch(search: string): string {
        return search.slice(`${Config.launcher.systemPrefix}battery_profile `.length);
    }

    list: [
        Profile {
            profile: "quiet"
            icon: "blur_short"
            name: qsTr("Quiet")
            desc: qsTr("Quiet, chill, low power usage, recommended for very light work.")
        },
        Profile {
            profile: "balanced"
            icon: "blur_medium"
            name: qsTr("Balanced")
            desc: qsTr("Perfect balance between power usage and performance, recommended for daily usage.")
        },
        Profile {
            profile: "performance"
            icon: "trail_length"
            name: qsTr("Performance")
            desc: qsTr("I BOUGHT THE WHOLE LAPTOP, I WILL USE THE WHOLE LAPTOP")
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
            Quickshell.execDetached([
                "/bin/sh",
                "-c",
                `asusctl profile set ${profile} && notify-send -u low -a "System Notification" "${name} battery profile activated."`
            ]);
        }
    }
}
