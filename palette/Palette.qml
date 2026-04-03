pragma Singleton
import QtQuick

QtObject {
    // Core Backgrounds
    readonly property color background: "#1D282F"
    readonly property color surface: "#1D282F"
    readonly property color surface_dim: "#152128"
    readonly property color surface_bright: "#314654"
    
    // Containers
    readonly property color surface_container_lowest: "#0B1213"
    readonly property color surface_container_low: "#1A2328"
    readonly property color surface_container: "#21313B"
    readonly property color surface_container_high: "#223B49"
    readonly property color surface_container_highest: "#314654"

    // Primary (Blue/Teal)
    readonly property color primary: "#86BFD0"
    readonly property color on_primary: "#1D282F"
    readonly property color primary_container: "#375259"
    readonly property color on_primary_container: "#A7CBEA"

    // Secondary (Green/Sage)
    readonly property color secondary: "#9DC6A9"
    readonly property color on_secondary: "#152326"
    readonly property color secondary_container: "#435B55"
    readonly property color on_secondary_container: "#9EBB9C"

    // Tertiary (Purple/Pink)
    readonly property color tertiary: "#D9ADD4"
    readonly property color on_tertiary: "#504c5a"
    readonly property color tertiary_container: "#504c5a"
    readonly property color on_tertiary_container: "#D59CCE"

    // Typography & Lines
    readonly property color on_background: "#DBD0C6"
    readonly property color on_surface: "#DBD0C6"
    readonly property color on_surface_variant: "#91A4AD"
    readonly property color outline: "#91A4AD"
    readonly property color outline_variant: "#314654"

    // Error (Red)
    readonly property color error: "#D2696C"
    readonly property color on_error: "#0B1213"
    readonly property color error_container: "#704C4E"
    readonly property color on_error_container: "#E89396"

    // Extras
    readonly property color shadow: "#000000"
    readonly property color scrim: "#000000"
    readonly property color inverse_surface: "#DBD0C6"
    readonly property color inverse_on_surface: "#1D282F"
    readonly property color inverse_primary: "#4F8FA1"
}
