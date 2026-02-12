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
            name: qsTr("Profile")
            desc: qsTr("Change battery profile.")
            icon: "battery_android_0"

            function onClicked(list: AppList): void {
                root.autocomplete(list, "battery_profile");
            }
        },
        Action {
            name: qsTr("Charge Limit")
            desc: qsTr("Change battery charge limit.")
            icon: "bolt"

            function onClicked(list: AppList): void {
                root.autocomplete(list, "battery_chargelimit");
            }
        }
    ]

    function transformSearch(search: string): string {
        const prefix = Config.launcher.systemPrefix;
        return search
            .slice(prefix.length)
            .trim()
            .replace(/^battery\s*/, "");
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
