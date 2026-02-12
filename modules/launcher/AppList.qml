pragma ComponentBehavior: Bound

import "items"
import "services"
import qs.components
import qs.components.controls
import qs.components.containers
import qs.services
import qs.config
import Quickshell
import QtQuick

StyledListView {
    id: root

    required property StyledTextField search
    required property PersistentProperties visibilities

    model: ScriptModel {
        id: model

        onValuesChanged: root.currentIndex = 0
    }

    spacing: Appearance.spacing.small
    orientation: Qt.Vertical
    implicitHeight: (Config.launcher.sizes.itemHeight + spacing) * Math.min(Config.launcher.maxShown, count) - spacing

    preferredHighlightBegin: 0
    preferredHighlightEnd: height
    highlightRangeMode: ListView.ApplyRange

    highlightFollowsCurrentItem: false
    highlight: StyledRect {
        radius: Appearance.rounding.normal
        color: Colours.palette.m3onSurface
        opacity: 0.08

        y: root.currentItem?.y ?? 0
        implicitWidth: root.width
        implicitHeight: root.currentItem?.implicitHeight ?? 0

        Behavior on y {
            Anim {
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }
        }
    }

    state: {
        const text = search.text;
        const actionPrefix = Config.launcher.actionPrefix;
        const systemPrefix = Config.launcher.systemPrefix;
        if (text.startsWith(actionPrefix)) {
            for (const action of ["calc", "scheme", "variant"])
                if (text.startsWith(`${actionPrefix}${action} `))
                    return action;

            return "actions";
        } else if (text.startsWith(systemPrefix)) {
            for (const action of ["battery", "performance", "display", "battery_profile", "battery_chargelimit", "performance", "performance_gpu", "display"])
                if (text.startsWith(`${systemPrefix}${action} `))
                    return action;

            return "system";
        }

        return "apps";
    }

    onStateChanged: {
        if (state === "scheme" || state === "variant")
            Schemes.reload();
    }

    states: [
        State {
            name: "apps"

            PropertyChanges {
                model.values: Apps.search(search.text)
                root.delegate: appItem
            }
        },
        State {
            name: "actions"

            PropertyChanges {
                model.values: Actions.query(search.text)
                root.delegate: actionItem
            }
        },
        State {
            name: "calc"

            PropertyChanges {
                model.values: [0]
                root.delegate: calcItem
            }
        },
        State {
            name: "scheme"

            PropertyChanges {
                model.values: Schemes.query(search.text)
                root.delegate: schemeItem
            }
        },
        State {
            name: "variant"

            PropertyChanges {
                model.values: M3Variants.query(search.text)
                root.delegate: variantItem
            }
        },
        State {
            name: "system"

            PropertyChanges {
                model.values: System.query(search.text)
                root.delegate: systemItem
            }
        },
        State {
            name: "battery"

            PropertyChanges {
                model.values: Battery.query(search.text)
                root.delegate: batteryItem
            }
        },
        State {
            name: "battery_profile"

            PropertyChanges {
                model.values: BatteryProfile.query(search.text)
                root.delegate: batteryProfileItem
            }
        },
        State {
            name: "battery_chargelimit"

            PropertyChanges {
                model.values: [80]
                root.delegate: batteryChargeLimitItem
            }
        },
        State {
            name: "performance"

            PropertyChanges {
                model.values: Performance.query(search.text)
                root.delegate: performanceItem
            }
        },
        State {
            name: "performance_gpu"

            PropertyChanges {
                model.values: PerformanceGPU.query(search.text)
                root.delegate: performanceGpuItem
            }
        },
        State {
            name: "display"

            PropertyChanges {
                model.values: Display.query(search.text)
                root.delegate: displayItem
            }
        },
    ]

    transitions: Transition {
        SequentialAnimation {
            ParallelAnimation {
                Anim {
                    target: root
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardAccel
                }
                Anim {
                    target: root
                    property: "scale"
                    from: 1
                    to: 0.9
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardAccel
                }
            }
            PropertyAction {
                targets: [model, root]
                properties: "values,delegate"
            }
            ParallelAnimation {
                Anim {
                    target: root
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
                Anim {
                    target: root
                    property: "scale"
                    from: 0.9
                    to: 1
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
            }
            PropertyAction {
                targets: [root.add, root.remove]
                property: "enabled"
                value: true
            }
        }
    }

    StyledScrollBar.vertical: StyledScrollBar {
        flickable: root
    }

    add: Transition {
        enabled: !root.state

        Anim {
            properties: "opacity,scale"
            from: 0
            to: 1
        }
    }

    remove: Transition {
        enabled: !root.state

        Anim {
            properties: "opacity,scale"
            from: 1
            to: 0
        }
    }

    move: Transition {
        Anim {
            property: "y"
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    addDisplaced: Transition {
        Anim {
            property: "y"
            duration: Appearance.anim.durations.small
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    displaced: Transition {
        Anim {
            property: "y"
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    Component {
        id: appItem

        AppItem {
            visibilities: root.visibilities
        }
    }

    Component {
        id: actionItem

        ActionItem {
            list: root
        }
    }

    Component {
        id: calcItem

        CalcItem {
            list: root
        }
    }

    Component {
        id: schemeItem

        SchemeItem {
            list: root
        }
    }

    Component {
        id: variantItem

        VariantItem {
            list: root
        }
    }

    Component {
        id: systemItem

        SystemItem {
            list: root
        }
    }

    Component {
        id: batteryItem

        BatteryItem {
            list: root
        }
    }

    Component {
        id: batteryProfileItem

        BatteryProfileItem {
            list: root
        }
    }

    Component {
        id: batteryChargeLimitItem

        BatteryChargeLimitItem {
            list: root
        }
    }

    Component {
        id: performanceItem

        PerformanceItem {
            list: root
        }
    }

    Component {
        id: performanceGpuItem

        PerformanceGPUItem {
            list: root
        }
    }

    Component {
        id: displayItem

        DisplayItem {
            list: root
        }
    }
}
