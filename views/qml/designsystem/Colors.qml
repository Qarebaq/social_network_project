pragma Singleton
import QtQuick 2.15

/*
    Colors.qml
    ----------
    This is the single palette for the whole app. Every value here was
    pulled out of the colors that were already hard-coded inside the
    login screen (Main.qml), so the Dashboard (and every future screen)
    stays visually identical to the login page instead of introducing a
    second, competing color scheme.

    Rule going forward: no QML file outside this one should contain a
    literal "#rrggbb" color. Everything reads from Colors.*
*/

QtObject {

    // ---- Base surfaces (from Main.qml background / card / dialog) -----
    readonly property color background   : "#0b1929"   // window background
    readonly property color surface      : "#141f35"   // card / panel background
    readonly property color surfaceAlt   : "#1a2a42"   // input fields, chips, list rows
    readonly property color surfaceRaised: "#253a56"   // hovered rows, secondary buttons

    readonly property color border       : "#1e3557"   // card borders
    readonly property color borderSoft   : "#253a56"   // input borders (default)
    readonly property color borderStrong : "#3a5878"   // input borders (unchecked, emphasis)

    // ---- Text ------------------------------------------------------------
    readonly property color textPrimary  : "#ddeeff"
    readonly property color textSecondary: "#b0cce0"
    readonly property color textMuted    : "#5a7898"
    readonly property color textFaint    : "#4a6a88"
    readonly property color textOnAccent : "#0b1929"

    // ---- Accent / brand (cyan, from logo + "Secure Login" button) -------
    readonly property color accent        : "#3dc8f5"
    readonly property color accentBright  : "#4dd9ff"
    readonly property color accentStrong  : "#00c8f0"
    readonly property color accentSoft    : "#2196c8"
    readonly property color accentGradTop : "#00d4ff"
    readonly property color accentGradBot : "#0090cc"

    // ---- Status colors (from error box / success screen) -----------------
    readonly property color success     : "#2ecc71"
    readonly property color successBg   : "#152e1a"
    readonly property color danger      : "#c0392b"
    readonly property color dangerBright: "#e74c3c"
    readonly property color dangerBg    : "#2d1018"
    readonly property color warning     : "#e0a62b"

    // ---- Graph-specific palette (nodes / edges / connected components) ---
    readonly property color nodeFill      : "#1a2a42"
    readonly property color nodeBorder    : accent
    readonly property color nodeSelected  : success
    readonly property color edgeColor     : "#2c4666"
    readonly property color edgeHighlight : accentBright
    readonly property color pathHighlight : warning

    readonly property var componentPalette: [
        "#3dc8f5", "#2ecc71", "#e0a62b", "#e74c3c",
        "#b15cff", "#4dd9ff", "#ff8a5c", "#2196c8"
    ]

    function colorForComponent(index) {
        if (index < 0) return nodeFill;
        return componentPalette[index % componentPalette.length];
    }
}
