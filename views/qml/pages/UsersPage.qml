import QtQuick 2.15
import QtQuick.Controls 2.15
import "../designsystem" as DS
import "../components"

Item {
    id: root
    width: 1280
    height: 960

    signal backRequested()

    readonly property bool hasBridge: typeof bridge !== "undefined" && bridge !== null
    readonly property var pyBridge: hasBridge ? bridge : null

    // Passed in by App.qml when this page is pushed, so the list is
    // populated immediately instead of waiting for the next usersChanged
    // signal (Connections only reacts to *future* emissions).
    property var initialUsers: []
    property var liveUsers: initialUsers

    Connections {
        target: root.pyBridge
        function onUsersChanged(users) { root.liveUsers = users; }
    }

    Rectangle { anchors.fill: parent; color: DS.Colors.background }

    Column {
        id: mainCol
        anchors.fill: parent
        anchors.margins: DS.Layout.s_s
        spacing: DS.Layout.s_s

        // ---- Topbar ---------------------------------------------------
        Row {
            width: parent.width
            height: 44
            spacing: DS.Layout.s_sm

            Btn {
                text: "← Back to Dashboard"
                variant: "ghost"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.backRequested()
            }

            Column {
                spacing: 2
                anchors.verticalCenter: parent.verticalCenter
                Text { text: "Users"; font: DS.Typography.h1; color: DS.Colors.accent }
                Text { text: root.liveUsers.length + " total"; font: DS.Typography.tiny; color: DS.Colors.textMuted }
            }
        }

        // ---- User list --------------------------------------------------
        Card {
            width: parent.width
            height: parent.height - 44 - DS.Layout.s_s
            title: "All Users"
            subtitle: "Everyone currently in the graph"

            Text {
                anchors.centerIn: parent
                visible: root.liveUsers.length === 0
                text: root.hasBridge ? "No users yet — add one from the Dashboard" : "Preview mode — no live data (open via main.py)"
                font: DS.Typography.caption
                color: DS.Colors.textFaint
            }

            ListView {
                anchors.fill: parent
                clip: true
                spacing: DS.Layout.s_mm
                model: root.liveUsers
                delegate: Rectangle {
                    width: ListView.view.width
                    height: 56
                    radius: DS.Layout.radi_m
                    color: DS.Colors.surfaceAlt
                    border.width: 1
                    border.color: DS.Colors.border

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: DS.Layout.s_sm
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: DS.Layout.s_mm

                        Rectangle {
                            width: 34; height: 34; radius: 17
                            color: DS.Colors.surface
                            border.width: 1; border.color: DS.Colors.accent
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                anchors.centerIn: parent
                                text: (modelData.name || modelData.id || "?").charAt(0).toUpperCase()
                                color: DS.Colors.accent
                                font: DS.Typography.bodyStrong
                            }
                        }

                        Column {
                            spacing: 0
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: modelData.name; font: DS.Typography.bodyStrong; color: DS.Colors.textPrimary }
                            Text { text: "ID: " + modelData.id; font: DS.Typography.caption; color: DS.Colors.textMuted }
                        }
                    }
                }
            }
        }
    }
}
