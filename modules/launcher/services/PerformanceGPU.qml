pragma Singleton

import qs.modules.launcher
import qs.config
import qs.utils
import Quickshell
import QtQuick

Searcher {
    id: root

    function transformSearch(search: string): string {
        return search.slice(`${Config.launcher.systemPrefix}performance_gpu `.length);
    }

    list: [
        Profile {
            profile: "Integrated"
            icon: "developer_board_off"
            name: qsTr("Integrated (AMD)")
            desc: qsTr("Very light power usage, for everyday usage")
        },
        Profile {
            profile: "Hybrid"
            icon: "developer_board"
            name: qsTr("Hybrid (Dedicated NVIDIA)")
            desc: qsTr("VROOM, VROOOOM, FPS GOO BBRRRRRR.")
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
                `supergfxctl -m ${profile} && notify-send -u low -a "System Notification" "${name} mode activated."`]);
        }
    }
}
