import QtQuick 2.15
import QtQuick.Controls 2.15
import "pages"

/*
    App.qml
    -------
    The actual top-level window. Previously Main.qml itself was the
    ApplicationWindow AND the whole login screen in one 870-line file,
    which made it impossible to ever show a second screen. Now:

        App.qml            -> the ApplicationWindow + StackView (this file)
        pages/LoginPage.qml -> exactly the old Main.qml content, unchanged,
                               just turned into an embeddable Item that
                               emits loginSucceeded() instead of directly
                               owning the window
        pages/DashboardPage.qml -> the new screen

    Point main.py (or whatever loads QML today) at THIS file instead of
    the old Main.qml. See the PDF for the one-line change needed there.
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
        initialItem: loginPageComponent

        // Simple fade between screens instead of the default slide,
        // since both screens are full-bleed dark backgrounds already.
        pushEnter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 220 } }
        pushExit:  Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 220 } }
        popEnter:  Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 220 } }
        popExit:   Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 220 } }
    }

    Component {
        id: loginPageComponent
        LoginPage {
            width: stack.width
            height: stack.height
            onLoginSucceeded: stack.replace(dashboardPageComponent)
        }
    }

    Component {
        id: dashboardPageComponent
        DashboardPage {
            width: stack.width
            height: stack.height
            onLogoutRequested: stack.replace(loginPageComponent)

            // TODO: wire these to the real controller once the Python
            // bridge is connected (see PDF, section "Controller wiring").
            onAddUserRequested: console.log("open Add User dialog")
            onAddFriendshipRequested: console.log("open Add Friendship dialog")
            onNavigateRequested: function(section) { console.log("navigate:", section) }
        }
    }
}
