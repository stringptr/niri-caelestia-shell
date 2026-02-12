import qs.utils
import Quickshell.Io

JsonObject {
    property bool enabled: true
    property int dragThreshold: 30
    property bool vimKeybinds: false
    property Commands commands: Commands {}

    property Sizes sizes: Sizes {}

    component Commands: JsonObject {
        property list<string> lock: ["qs", "-c", Paths.config, "ipc", "call", "lock", "lock"]
        property list<string> sleep: ["systemctl", "suspend"]
        property list<string> hibernate: ["systemctl", "hibernate"]
        property list<string> logout: ["loginctl", "terminate-user", ""]
        property list<string> reboot: ["systemctl", "restart"]
        property list<string> shutdown: ["systemctl", "poweroff"]
    }

    component Sizes: JsonObject {
        property int button: 80
    }
}
