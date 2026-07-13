pragma Singleton
import QtQuick 2.15

/*
    Typography.qml
    ---------------
    Font scale for the app, matching the family/sizes already used by
    hand throughout Main.qml (font.family: "Segoe UI, Arial" everywhere).
    Centralizing it here means the Dashboard and every future screen use
    the exact same type scale as the login page without retyping it.
*/

QtObject {
    readonly property string fontFamily: "Segoe UI, Vazirmatn, Arial"
    readonly property string monoFamily: "Cascadia Code, Consolas, monospace"

    readonly property font display: Qt.font({ family: fontFamily, pixelSize: 28, weight: Font.Bold })
    readonly property font h1     : Qt.font({ family: fontFamily, pixelSize: 22, weight: Font.Bold })
    readonly property font h2     : Qt.font({ family: fontFamily, pixelSize: 18, weight: Font.Bold })
    readonly property font h3     : Qt.font({ family: fontFamily, pixelSize: 15, weight: Font.DemiBold })
    readonly property font label  : Qt.font({ family: fontFamily, pixelSize: 11, weight: Font.DemiBold, letterSpacing: 1 })
    readonly property font body   : Qt.font({ family: fontFamily, pixelSize: 14, weight: Font.Normal })
    readonly property font bodyStrong: Qt.font({ family: fontFamily, pixelSize: 14, weight: Font.Bold })
    readonly property font caption: Qt.font({ family: fontFamily, pixelSize: 12, weight: Font.Normal })
    readonly property font tiny   : Qt.font({ family: fontFamily, pixelSize: 10, weight: Font.Normal, letterSpacing: 1 })
    readonly property font mono   : Qt.font({ family: monoFamily, pixelSize: 13 })
}
