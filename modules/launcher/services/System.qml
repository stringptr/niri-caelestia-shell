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
            name: qsTr("Battery")
            desc: qsTr("Change battery profile or charge limit")
            icon: "battery_android_0"

            function onClicked(list: AppList): void {
                root.autocomplete(list, "battery");
            }
        },
        Action {
            name: qsTr("Performance")
            desc: qsTr("Change performance settings")
            icon: "bolt"

            function onClicked(list: AppList): void {
                root.autocomplete(list, "performance");
            }
        },
        Action {
            name: qsTr("Display")
            desc: qsTr("Change display refresh rate")
            icon: "monitor"

            function onClicked(list: AppList): void {
                root.autocomplete(list, "display");
            }
        }
    ]

    function transformSearch(search: string): string {
        return search.slice(Config.launcher.systemPrefix.length);
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
