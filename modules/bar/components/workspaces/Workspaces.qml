pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.components
import QtQuick
import QtQuick.Layouts

import "context"

StyledRect {
    id: root

    // required property ShellScreen screen

    readonly property int activeWsId: Niri.focusedWorkspaceIndex + 1
    readonly property var occupied: Niri.workspaceHasWindows
    readonly property int groupOffset: Math.floor((Niri.focusedWorkspaceIndex) / Config.bar.workspaces.shown) * Config.bar.workspaces.shown
    readonly property bool onSpecial: (Config.bar.workspaces.perMonitorWorkspaces ? Hypr.monitorFor(screen) : Hypr.focusedMonitor)?.lastIpcObject?.specialWorkspace?.name !== ""
    readonly property int activeWsId: Config.bar.workspaces.perMonitorWorkspaces ? (Hypr.monitorFor(screen).activeWorkspace?.id ?? 1) : Hypr.activeWsId

    readonly property int focusedWindowId: Niri.focusedWindow.id

    implicitHeight: layout.implicitHeight + Appearance.padding.small * 2
    implicitWidth: Config.bar.sizes.innerWidth

    color: Colours.tPalette.m3surfaceContainer
    radius: Appearance.rounding.normal

    signal requestWindowPopout

    Connections {
        target: Niri
        function onWsContextTypeChanged() {
            if (Niri.wsContextType === "workspaces") {
                Niri.wsContextAnchor = root;
            }
        }
        layer.enabled: root.blur > 0
        layer.effect: MultiEffect {
            blurEnabled: true
            blurEnabled: true
            blur: root.blur
            blurMax: 32
        }

        Loader {
            active: Config.bar.workspaces.occupiedBg

            anchors.fill: parent
            anchors.margins: Appearance.padding.small

            sourceComponent: OccupiedBg {
                workspaces: workspaces
                occupied: root.occupied
                groupOffset: root.groupOffset
            }
        }

        ColumnLayout {
            id: layout

            anchors.centerIn: parent
            spacing: Math.floor(Appearance.spacing.small / 2)

            Repeater {
                id: workspaces

                model: Config.bar.workspaces.shown

                Workspace {
                    activeWsId: root.activeWsId
                    occupied: root.occupied
                    groupOffset: root.groupOffset
                }
            }
        }

        Loader {
            anchors.horizontalCenter: parent.horizontalCenter
            active: Config.bar.workspaces.activeIndicator

            sourceComponent: ActiveIndicator {
                activeWsId: root.activeWsId
                workspaces: workspaces
                mask: layout
            }
        }

        MouseArea {
            anchors.fill: layout
            onClicked: event => {
                const ws = layout.childAt(event.x, event.y).ws;
                if (Hypr.activeWsId !== ws)
                    Hypr.dispatch(`workspace ${ws}`);
                else
                    Hypr.dispatch("togglespecialworkspace special");
            }
        }

        Behavior on scale {
            Anim {}
        }

        Behavior on opacity {
            Anim {}
        }
    }

    Loader {
        active: Config.bar.workspaces.occupiedBg
        asynchronous: true

        anchors.fill: parent
        anchors.margins: Appearance.padding.small

        active: opacity > 0

        scale: root.onSpecial ? 1 : 0.5
        opacity: root.onSpecial ? 1 : 0

        sourceComponent: SpecialWorkspaces {
            screen: root.screen
        }

        Behavior on scale {
            Anim {}
        }

        Behavior on opacity {
            Anim {}
        }
    }

    Loader {
        // Right click on window context menu
        active: Config.bar.workspaces.windowRighClickContext && Niri.wsContextType !== "none"
        asynchronous: true

        anchors.left: parent.left
        anchors.leftMargin: Appearance.padding.small

        z: Niri.wsContextType === "workspaces" ? -10 : 0

        sourceComponent: ContextBg {
            groupOffset: root.groupOffset
            wsOffset: root.y
            anchorWs: Niri.wsContextAnchor
        }
    }

    //TODO, For Niri, workspace context menu on right click.
    // Loader {
    //     active: Config.bar.workspaces.windowRighClickContext && Niri.wsContextType !== "none"
    //     asynchronous: true
    //     z: Niri.wsContextType === "item" ? 10 : 1

    //     anchors.right: parent.right
    //     anchors.rightMargin: -Appearance.padding.small

    //     sourceComponent: ContextIndicator {
    //         groupOffset: root.groupOffset
    //         wsOffset: root.y
    //         anchorWs: Niri.wsContextAnchor
    //     }
    // }

    Loader {
        anchors.left: parent.left
        anchors.right: parent.right
        active: Config.bar.workspaces.activeIndicator
        asynchronous: true

        sourceComponent: ActiveIndicator {
            activeWsId: root.activeWsId
            workspaces: workspaces
            mask: layout
            groupOffset: root.groupOffset
        }
    }

    ColumnLayout {
        id: layout

        z: 1

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Appearance.padding.small
        spacing: Math.floor(Appearance.spacing.small)

        Repeater {
            id: workspaces

            model: Config.bar.workspaces.shown > Niri.getWorkspaceCount() ? Niri.getWorkspaceCount() : Config.bar.workspaces.shown

            Workspace {
                activeWsId: root.activeWsId
                occupied: root.occupied
                groupOffset: root.groupOffset
                focusedWindowId: root.focusedWindowId
                windowPopoutSignal: root
            }
        }
    }

    Loader {
        id: pager
        active: Config.bar.workspaces.pagerActive

        anchors.top: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        z: -1

        sourceComponent: Pager {
            groupOffset: root.groupOffset
        }
    }
}
