import QtQuick 2.15
import QtQuick.Controls 2.15
import "pages"

ApplicationWindow {
    id: window
    visible: true
    width: 1280
    height: 960
    title: "NetAnalysis Pro"
    color: "#0b1929"
    visibility: Window.Maximized

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: landingPageComponent

        pushEnter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 220 } }
        pushExit:  Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 220 } }
        popEnter:  Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 220 } }
        popExit:   Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 220 } }
    }

    Component {
        id: landingPageComponent
        LandingPage {
            width: stack.width
            height: stack.height
            onEnterDashboardRequested: stack.push(dashboardPageComponent)
        }
    }

    Component {
        id: dashboardPageComponent
        DashboardPage {
            width: stack.width
            height: stack.height

            onAddUserRequested: console.log("Add User dialog opened")
            onAddFriendshipRequested: console.log("Add Friendship dialog opened")
            onLogoutRequested: stack.pop(null)
            onNavigateRequested: function(section) {
                if (section === "users") {
                    stack.push(usersPageComponent, { initialUsers: liveUsers });
                }
            }
        }
    }

    Component {
        id: usersPageComponent
        UsersPage {
            width: stack.width
            height: stack.height
            onBackRequested: stack.pop()
        }
    }
}
