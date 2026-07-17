import QtQuick 2.15
import QtQuick.Controls 2.15
import "pages"

/*
    App.qml
    -------
    Login page removed - the app now opens straight into the Dashboard.
    LoginPage.qml is still sitting in pages/ untouched in case you want
    it back later; it's just no longer referenced from here.
*/
ApplicationWindow {
    id: window
    visible: true
    width: 1280
    height: 960
    title: "NetAnalysis Pro"
    color: "#0b1929"

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: dashboardPageComponent

        pushEnter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 220 } }
        pushExit:  Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 220 } }
        popEnter:  Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 220 } }
        popExit:   Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 220 } }
    }

    Component {
        id: dashboardPageComponent
        DashboardPage {
            width: stack.width
            height: stack.height

            // TODO: wire these to the real controller once the Python
            // bridge is connected (see PDF, section "Controller wiring").
            onAddUserRequested: console.log("open Add User dialog")
            onAddFriendshipRequested: console.log("open Add Friendship dialog")
            onNavigateRequested: function(section) { console.log("navigate:", section) }
        }
    }
}
