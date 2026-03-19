pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import Quickshell
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property int index
    required property var occupied
    required property int groupOffset
    required property int focusedWindowId
    required property int activeWsId

    required property Item windowPopoutSignal
    readonly property ShellScreen screen: windowPopoutSignal.screen

    readonly property bool isWorkspace: true
    readonly property int size: isWorkspace ? implicitHeight + (hasWindows ? Appearance.padding.small : 0) : 0
    readonly property int pos: groupOffset + index
    readonly property int ws: Niri.getWsNumForPosition(screen.name, pos)
    readonly property bool isOccupied: occupied[ws] ?? false
    readonly property bool hasWindows: isOccupied && Config.bar.workspaces.showWindows

    // To make the windows repopulate, for Niri.
    // onGroupOffsetChanged: {
    //     windows.active = false;
    //     windows.active = true;
    // }

    // clip: true

    Behavior on scale {
        Anim {}
    // StyledText {
    //     id: indicator
    //
    //     Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
    //     Layout.preferredHeight: Config.bar.sizes.innerWidth - Appearance.padding.small * 2
    //
    //     animate: true
    //     text: {
    //         const ws = Hypr.workspaces.values.find(w => w.id === root.ws);
    //         const wsName = !ws || ws.name == root.ws ? root.ws : ws.name[0];
    //         let displayName = wsName.toString();
    //         if (Config.bar.workspaces.capitalisation.toLowerCase() === "upper") {
    //             displayName = displayName.toUpperCase();
    //         } else if (Config.bar.workspaces.capitalisation.toLowerCase() === "lower") {
    //             displayName = displayName.toLowerCase();
    //         }
    //         const label = Config.bar.workspaces.label || displayName;
    //         const occupiedLabel = Config.bar.workspaces.occupiedLabel || label;
    //         const activeLabel = Config.bar.workspaces.activeLabel || (root.isOccupied ? occupiedLabel : label);
    //         return root.activeWsId === root.ws ? activeLabel : root.isOccupied ? occupiedLabel : label;
    //     }
    //     color: Config.bar.workspaces.occupiedBg || root.isOccupied || root.activeWsId === root.ws ? Colours.palette.m3onSurface : Colours.layer(Colours.palette.m3outlineVariant, 2)
    //     verticalAlignment: Qt.AlignVCenter
    // }
    //
    // Loader {
    //     id: windows
    //
    //     asynchronous: true
    //
    //     Layout.alignment: Qt.AlignHCenter
    //     Layout.fillHeight: true
    //     Layout.topMargin: -Config.bar.sizes.innerWidth / 10
    //
    //     visible: active
    //     active: root.hasWindows
    //
    //     sourceComponent: Column {
    //         spacing: 0
    //
            // add: Transition {
            //     Anim {
            //         properties: "scale"
            //         from: 0
            //         to: 1
            //         easing.bezierCurve: Appearance.anim.curves.standardDecel
            //     }
            // }
            //
            // move: Transition {
            //     Anim {
            //         properties: "scale"
            //         to: 1
            //         easing.bezierCurve: Appearance.anim.curves.standardDecel
            //     }
            //     Anim {
            //         properties: "x,y"
            //     }
            // }
    //
    //         Repeater {
    //             model: ScriptModel {
    //                 values: {
    //                     const windows = Hypr.toplevels.values.filter(c => c.workspace?.id === root.ws);
    //                     const maxIcons = Config.bar.workspaces.maxWindowIcons;
    //                     return maxIcons > 0 ? windows.slice(0, maxIcons) : windows;
    //                 }
    //             }
    //
    //             MaterialIcon {
    //                 required property var modelData
    //
    //                 grade: 0
    //                 text: Icons.getAppCategoryIcon(modelData.lastIpcObject.class, "terminal")
    //                 color: Colours.palette.m3onSurfaceVariant
    //             }
    //         }
    //     }
    }

    Behavior on Layout.preferredHeight {
        Anim {}
    }

    Layout.alignment: Qt.AlignLeft
    Layout.preferredHeight: size

    spacing: 0

    WorkspaceIcon {
        workspace: root
    }

    Loader {
        id: windows

        Layout.alignment: Qt.AlignCenter
        // Layout.fillHeight: true
        Layout.topMargin: -Config.bar.sizes.innerWidth / 10

        visible: active
        active: root.hasWindows

        sourceComponent: DraggableWindowColumn {
            id: dragDropLayout
            spacing: 0

            workspace: root
            focusedWindowId: root.focusedWindowId
            activeWsId: root.activeWsId
            ws: root.ws
            windowPopoutSignal: root.windowPopoutSignal
            idx: root.index
            groupOffset: root.groupOffset
            screen: root.windowPopoutSignal.screen
        }
    }
}
