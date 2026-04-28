import qs.components
import qs.services
import qs.config
import Caelestia
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property var list
    readonly property string limitText: list.search.text.slice(`${Config.launcher.actionPrefix}battery_chargelimit `.length)

    readonly property int limit: {
        const n = parseInt(limitText);
        return isNaN(n) ? -1 : n;
    }

    readonly property bool valid: (limit >= 60 && limit <= 80 && limit % 5 == 0) || limit == 100

    function onClicked(): void {
        applyLimit();
    }

    function applyLimit(): void {
        if (!valid)
            return;

        Quickshell.execDetached([
            "asusctl",
            "battery",
            "limit",
            limit.toString()
        ]);

        root.list.visibilities.launcher = false;
    }

    implicitHeight: Config.launcher.sizes.itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    StateLayer {
        radius: Appearance.rounding.full

        function onClicked(): void {
            root.applyLimit();
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.small
        spacing: Appearance.spacing.normal

        MaterialIcon {
            text: "battery_charging_full"
            font.pointSize: Appearance.font.size.extraLarge
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            font.pointSize: Appearance.font.size.large
            text: {
                if (!limitText)
                    return qsTr("Battery charge limit (60–80%)");

                if (!valid)
                    return qsTr(`Invalid value: ${limitText}%`);

                return qsTr(`Set battery limit to ${limit}%`);
            }

            color: {
                if (!limitText)
                    return Colours.palette.m3onSurfaceVariant;
                if (!valid)
                    return Colours.palette.m3error;
                return Colours.palette.m3onSurface;
            }

            elide: Text.ElideLeft
        }

        StyledRect {
            color: valid ? Colours.palette.m3tertiary : Colours.palette.m3surfaceVariant
            radius: Appearance.rounding.normal
            clip: true

            implicitWidth: icon.implicitWidth + Appearance.padding.normal * 2
            implicitHeight: icon.implicitHeight + Appearance.padding.small * 2

            Layout.alignment: Qt.AlignVCenter

            StateLayer {
                enabled: valid
                color: Colours.palette.m3onTertiary

                function onClicked(): void {
                    root.applyLimit();
                }
            }

            MaterialIcon {
                id: icon
                anchors.centerIn: parent
                text: "check"
                color: valid
                    ? Colours.palette.m3onTertiary
                    : Colours.palette.m3outline
                font.pointSize: Appearance.font.size.large
            }
        }
    }

    Keys.onEnterPressed: root.applyLimit()
    Keys.onReturnPressed: root.applyLimit()
}
