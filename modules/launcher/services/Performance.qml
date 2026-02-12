pragma Singleton

import qs.modules.launcher
import qs.services
import qs.config
import qs.utils
import Quickshell
import QtQuick

Searcher {
    id: root

    readonly property list<Action> actions: [
        Action {
            name: qsTr("GPU Mode")
            desc: qsTr("Change between Integrated and Hybrid mode.")
            icon: "developer_board"

            function onClicked(list: AppList): void {
                root.autocomplete(list, "performance_gpu");
            }
        },
        Action {
            name: qsTr("NVidia Undervolt & Underclock")
            desc: qsTr("Undervolt and/or underclock to achieve better performance or thermal..")
            icon: "offline_bolt"

            function onClicked(list: AppList): void {
                root.autocomplete(list, "performance_nvidiauv");
            }
        }
    ]

    function transformSearch(search: string): string {
        const prefix = Config.launcher.systemPrefix;
        return search
            .slice(prefix.length)
            .trim()
            .replace(/^performance\s*/, "");
    }

    function autocomplete(list: AppList, text: string): void {
        list.search.text = `${Config.launcher.systemPrefix}${text} `;
    }

    list: actions.filter(a => !a.disabled)
    useFuzzy: Config.launcher.useFuzzy.actions

    component Action: QtObject {
        required property string name
        required property string desc
        required property string icon
        property bool disabled

        function onClicked(list: AppList): void {
        }
    }
}
