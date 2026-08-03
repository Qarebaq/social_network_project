pragma Singleton
import QtQuick 2.15

/*
    Icons.qml
    ---------
    This file does NOT draw anything (drawing lives in components/AppIcon.qml,
    which is the reusable renderer). This file just holds the registry of
    valid icon names and a plain-text glyph fallback for each one, so:

      1. designsystem/ stays "data only" (colors, type, spacing, icon names)
      2. components/   stays "rendering only" (how a token becomes pixels)

    Usage:
        AppIcon { name: "dashboard" }   // see components/AppIcon.qml
*/
QtObject {
    readonly property url logalanding:  "views/qml/designsystem/images/74d07667-77dd-4b5f-95b6-2dd1f29087ab.png"

    readonly property var names: ([
        "dashboard", "network", "people", "communities", "shield",
        "search", "bell", "plus", "chevronRight", "gear",
        "help", "export", "check", "person", "lock", "eye"
    ])
    readonly property var glyphs: ({
        "dashboard"   : "▦",
        "network"     : "◇",
        "people"      : "◔",
        "communities" : "◫",
        "shield"      : "◈",
        "search"      : "🔍",
        "bell"        : "🔔",
        "plus"        : "+",
        "chevronRight": "›",
        "gear"        : "⚙",
        "help"        : "?",
        "export"      : "⇩",
        "check"       : "✓",
        "person"      : "◔",
        "lock"        : "🔒",
        "eye"         : "◎"
    })

    function glyphFor(name) {
        return glyphs[name] !== undefined ? glyphs[name] : "•";
    }
}
