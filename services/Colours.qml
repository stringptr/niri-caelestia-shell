pragma Singleton
pragma ComponentBehavior: Bound

import qs.config
import qs.utils
import Caelestia
import Quickshell
import Quickshell.Io
import QtQuick
import "../palette/Palette" as Pal

Singleton {
    id: root

    property bool showPreview
    property string scheme
    property string flavour
    readonly property bool light: showPreview ? previewLight : currentLight
    property bool currentLight
    property bool previewLight
    readonly property M3Palette palette: showPreview ? preview : current
    readonly property M3TPalette tPalette: M3TPalette {}
    readonly property M3Palette current: M3Palette {}
    readonly property M3Palette preview: M3Palette {}
    readonly property Transparency transparency: Transparency {}
    readonly property alias wallLuminance: analyser.luminance

    function getLuminance(c: color): real {
        if (c.r == 0 && c.g == 0 && c.b == 0)
            return 0;
        return Math.sqrt(0.299 * (c.r ** 2) + 0.587 * (c.g ** 2) + 0.114 * (c.b ** 2));
    }

    function alterColour(c: color, a: real, layer: int): color {
        const luminance = getLuminance(c);

        const offset = (!light || layer == 1 ? 1 : -layer / 2) * (light ? 0.2 : 0.3) * (1 - transparency.base) * (1 + wallLuminance * (light ? (layer == 1 ? 3 : 1) : 2.5));
        const scale = (luminance + offset) / luminance;
        const r = Math.max(0, Math.min(1, c.r * scale));
        const g = Math.max(0, Math.min(1, c.g * scale));
        const b = Math.max(0, Math.min(1, c.b * scale));

        return Qt.rgba(r, g, b, a);
    }

    function layer(c: color, layer: var): color {
        if (!transparency.enabled)
            return c;

        return layer === 0 ? Qt.alpha(c, transparency.base) : alterColour(c, transparency.layers, layer ?? 1);
    }

    function on(c: color): color {
        if (c.hslLightness < 0.5)
            return Qt.hsla(c.hslHue, c.hslSaturation, 0.9, 1);
        return Qt.hsla(c.hslHue, c.hslSaturation, 0.1, 1);
    }

    function load(data: string, isPreview: bool): void {
        const colours = isPreview ? preview : current;
        const scheme = JSON.parse(data);

        if (!isPreview) {
            root.scheme = scheme.name;
            flavour = scheme.flavour;
            currentLight = scheme.mode === "light";
        } else {
            previewLight = scheme.mode === "light";
        }

        for (const [name, colour] of Object.entries(scheme.colours)) {
            const propName = name.startsWith("term") ? name : `m3${name}`;
            if (colours.hasOwnProperty(propName))
                colours[propName] = `#${colour}`;
        }
    }

    function setMode(mode: string): void {
        Quickshell.execDetached(["caelestia", "scheme", "set", "--notify", "-m", mode]);
    }

    FileView {
        path: `${Paths.state}/scheme.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.load(text(), false)
    }

    ImageAnalyser {
        id: analyser

        source: Wallpapers.current
    }

    component Transparency: QtObject {
        readonly property bool enabled: Appearance.transparency.enabled
        readonly property real base: Appearance.transparency.base - (root.light ? 0.1 : 0)
        readonly property real layers: Appearance.transparency.layers
    }

    component M3TPalette: QtObject {
        readonly property color m3primary_paletteKeyColor: root.layer(root.palette.m3primary_paletteKeyColor)
        readonly property color m3secondary_paletteKeyColor: root.layer(root.palette.m3secondary_paletteKeyColor)
        readonly property color m3tertiary_paletteKeyColor: root.layer(root.palette.m3tertiary_paletteKeyColor)
        readonly property color m3neutral_paletteKeyColor: root.layer(root.palette.m3neutral_paletteKeyColor)
        readonly property color m3neutral_variant_paletteKeyColor: root.layer(root.palette.m3neutral_variant_paletteKeyColor)
        readonly property color m3background: root.layer(root.palette.m3background, 0)
        readonly property color m3onBackground: root.layer(root.palette.m3onBackground)
        readonly property color m3surface: root.layer(root.palette.m3surface, 0)
        readonly property color m3surfaceDim: root.layer(root.palette.m3surfaceDim, 0)
        readonly property color m3surfaceBright: root.layer(root.palette.m3surfaceBright, 0)
        readonly property color m3surfaceContainerLowest: root.layer(root.palette.m3surfaceContainerLowest)
        readonly property color m3surfaceContainerLow: root.layer(root.palette.m3surfaceContainerLow)
        readonly property color m3surfaceContainer: root.layer(root.palette.m3surfaceContainer)
        readonly property color m3surfaceContainerHigh: root.layer(root.palette.m3surfaceContainerHigh)
        readonly property color m3surfaceContainerHighest: root.layer(root.palette.m3surfaceContainerHighest)
        readonly property color m3onSurface: root.layer(root.palette.m3onSurface)
        readonly property color m3surfaceVariant: root.layer(root.palette.m3surfaceVariant, 0)
        readonly property color m3onSurfaceVariant: root.layer(root.palette.m3onSurfaceVariant)
        readonly property color m3inverseSurface: root.layer(root.palette.m3inverseSurface, 0)
        readonly property color m3inverseOnSurface: root.layer(root.palette.m3inverseOnSurface)
        readonly property color m3outline: root.layer(root.palette.m3outline)
        readonly property color m3outlineVariant: root.layer(root.palette.m3outlineVariant)
        readonly property color m3shadow: root.layer(root.palette.m3shadow)
        readonly property color m3scrim: root.layer(root.palette.m3scrim)
        readonly property color m3surfaceTint: root.layer(root.palette.m3surfaceTint)
        readonly property color m3primary: root.layer(root.palette.m3primary)
        readonly property color m3onPrimary: root.layer(root.palette.m3onPrimary)
        readonly property color m3primaryContainer: root.layer(root.palette.m3primaryContainer)
        readonly property color m3onPrimaryContainer: root.layer(root.palette.m3onPrimaryContainer)
        readonly property color m3inversePrimary: root.layer(root.palette.m3inversePrimary)
        readonly property color m3secondary: root.layer(root.palette.m3secondary)
        readonly property color m3onSecondary: root.layer(root.palette.m3onSecondary)
        readonly property color m3secondaryContainer: root.layer(root.palette.m3secondaryContainer)
        readonly property color m3onSecondaryContainer: root.layer(root.palette.m3onSecondaryContainer)
        readonly property color m3tertiary: root.layer(root.palette.m3tertiary)
        readonly property color m3onTertiary: root.layer(root.palette.m3onTertiary)
        readonly property color m3tertiaryContainer: root.layer(root.palette.m3tertiaryContainer)
        readonly property color m3onTertiaryContainer: root.layer(root.palette.m3onTertiaryContainer)
        readonly property color m3error: root.layer(root.palette.m3error)
        readonly property color m3onError: root.layer(root.palette.m3onError)
        readonly property color m3errorContainer: root.layer(root.palette.m3errorContainer)
        readonly property color m3onErrorContainer: root.layer(root.palette.m3onErrorContainer)
        readonly property color m3success: root.layer(root.palette.m3success)
        readonly property color m3onSuccess: root.layer(root.palette.m3onSuccess)
        readonly property color m3successContainer: root.layer(root.palette.m3successContainer)
        readonly property color m3onSuccessContainer: root.layer(root.palette.m3onSuccessContainer)
        readonly property color m3primaryFixed: root.layer(root.palette.m3primaryFixed)
        readonly property color m3primaryFixedDim: root.layer(root.palette.m3primaryFixedDim)
        readonly property color m3onPrimaryFixed: root.layer(root.palette.m3onPrimaryFixed)
        readonly property color m3onPrimaryFixedVariant: root.layer(root.palette.m3onPrimaryFixedVariant)
        readonly property color m3secondaryFixed: root.layer(root.palette.m3secondaryFixed)
        readonly property color m3secondaryFixedDim: root.layer(root.palette.m3secondaryFixedDim)
        readonly property color m3onSecondaryFixed: root.layer(root.palette.m3onSecondaryFixed)
        readonly property color m3onSecondaryFixedVariant: root.layer(root.palette.m3onSecondaryFixedVariant)
        readonly property color m3tertiaryFixed: root.layer(root.palette.m3tertiaryFixed)
        readonly property color m3tertiaryFixedDim: root.layer(root.palette.m3tertiaryFixedDim)
        readonly property color m3onTertiaryFixed: root.layer(root.palette.m3onTertiaryFixed)
        readonly property color m3onTertiaryFixedVariant: root.layer(root.palette.m3onTertiaryFixedVariant)
    }

    component M3Palette: QtObject {
        property color m3primary_paletteKeyColor: Pal.Palette.primary
        property color m3secondary_paletteKeyColor: Pal.Palette.secondary
        property color m3tertiary_paletteKeyColor: Pal.Palette.tertiary
        property color m3neutral_paletteKeyColor: Pal.Palette.surface
        property color m3neutral_variant_paletteKeyColor: Pal.Palette.surface_variant

        property color m3background: Pal.Palette.background
        property color m3onBackground: Pal.Palette.on_background

        property color m3surface: Pal.Palette.surface
        property color m3surfaceDim: Pal.Palette.surface_dim
        property color m3surfaceBright: Pal.Palette.surface_bright
        property color m3surfaceContainerLowest: Pal.Palette.surface_container_lowest
        property color m3surfaceContainerLow: Pal.Palette.surface_container_low
        property color m3surfaceContainer: Pal.Palette.surface_container
        property color m3surfaceContainerHigh: Pal.Palette.surface_container_high
        property color m3surfaceContainerHighest: Pal.Palette.surface_container_highest

        property color m3onSurface: Pal.Palette.on_surface
        property color m3surfaceVariant: Pal.Palette.surface_variant
        property color m3onSurfaceVariant: Pal.Palette.on_surface_variant

        property color m3inverseSurface: Pal.Palette.inverse_surface
        property color m3inverseOnSurface: Pal.Palette.inverse_on_surface

        property color m3outline: Pal.Palette.outline
        property color m3outlineVariant: Pal.Palette.outline_variant

        property color m3shadow: Pal.Palette.shadow
        property color m3scrim: Pal.Palette.scrim

        property color m3surfaceTint: Pal.Palette.surface_tint

        property color m3primary: Pal.Palette.primary
        property color m3onPrimary: Pal.Palette.on_primary
        property color m3primaryContainer: Pal.Palette.primary_container
        property color m3onPrimaryContainer: Pal.Palette.on_primary_container
        property color m3inversePrimary: Pal.Palette.inverse_primary

        property color m3secondary: Pal.Palette.secondary
        property color m3onSecondary: Pal.Palette.on_secondary
        property color m3secondaryContainer: Pal.Palette.secondary_container
        property color m3onSecondaryContainer: Pal.Palette.on_secondary_container

        property color m3tertiary: Pal.Palette.tertiary
        property color m3onTertiary: Pal.Palette.on_tertiary
        property color m3tertiaryContainer: Pal.Palette.tertiary_container
        property color m3onTertiaryContainer: Pal.Palette.on_tertiary_container

        property color m3error: Pal.Palette.error
        property color m3onError: Pal.Palette.on_error
        property color m3errorContainer: Pal.Palette.error_container
        property color m3onErrorContainer: Pal.Palette.on_error_container

        property color m3success: Pal.Palette.success
        property color m3onSuccess: Pal.Palette.on_success
        property color m3successContainer: Pal.Palette.success_container
        property color m3onSuccessContainer: Pal.Palette.on_success_container

        property color m3primaryFixed: Pal.Palette.primary_fixed
        property color m3primaryFixedDim: Pal.Palette.primary_fixed_dim
        property color m3onPrimaryFixed: Pal.Palette.on_primary_fixed
        property color m3onPrimaryFixedVariant: Pal.Palette.on_primary_fixed_variant

        property color m3secondaryFixed: Pal.Palette.secondary_fixed
        property color m3secondaryFixedDim: Pal.Palette.secondary_fixed_dim
        property color m3onSecondaryFixed: Pal.Palette.on_secondary_fixed
        property color m3onSecondaryFixedVariant: Pal.Palette.on_secondary_fixed_variant

        property color m3tertiaryFixed: Pal.Palette.tertiary_fixed
        property color m3tertiaryFixedDim: Pal.Palette.tertiary_fixed_dim
        property color m3onTertiaryFixed: Pal.Palette.on_tertiary_fixed
        property color m3onTertiaryFixedVariant: Pal.Palette.on_tertiary_fixed_variant
        property color term0: "#353434"
        property color term1: "#fe45a7"
        property color term2: "#ffbac0"
        property color term3: "#ffdee3"
        property color term4: "#b3a2d5"
        property color term5: "#e491bd"
        property color term6: "#ffba93"
        property color term7: "#edd2d5"
        property color term8: "#b29ea1"
        property color term9: "#ff7db7"
        property color term10: "#ffd2d5"
        property color term11: "#fff1f2"
        property color term12: "#babfdd"
        property color term13: "#f3a9cd"
        property color term14: "#ffd1c0"
        property color term15: "#ffffff"

        property color archBlue: "#1793D1"
        property color success: "#4CAF50"
        property color warning: "#FF9800"
        property color info: "#2196F3"
        property color error: "#F2B8B5"

        property color rosewater: "#B8C4FF"
        property color flamingo: "#DBB9F8"
        property color pink: "#F3B3E3"
        property color mauve: "#D0BDFE"
        property color red: "#F8B3D1"
        property color maroon: "#F6B2DA"
        property color peach: "#E4B7F4"
        property color yellow: "#C3C0FF"
        property color green: "#ADC6FF"
        property color teal: "#D4BBFC"
        property color sky: "#CBBEFF"
        property color sapphire: "#BDC2FF"
        property color blue: "#C7BFFF"
        property color lavender: "#EAB5ED"
    }
}
