import QtQuick 2.15
import QtQuick.Controls 2.15
import "../designsystem" as DS

/*
    IconButton
    ----------
    Small square icon-only button (topbar search/bell, sidebar collapse,
    graph zoom controls, remove-row in lists). Uses AppIcon internally.
*/
Button {
    id: root
    property string iconName: "gear"
    property color tint: DS.Colors.textSecondary
    property bool showBadge: false

    implicitWidth: 34
    implicitHeight: 34

    background: Rectangle {
        radius: DS.Layout.radi_m
        color: root.down ? DS.Colors.surfaceRaised : (root.hovered ? DS.Colors.surfaceAlt : "transparent")
        border.width: 1
        border.color: DS.Colors.border
    }

    contentItem: Item {
        AppIcon {
            anchors.centerIn: parent
            name: root.iconName
            color: root.tint
            size: 16
        }
        Rectangle {
            visible: root.showBadge
            width: 7; height: 7; radius: 3.5
            color: DS.Colors.dangerBright
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 6
            anchors.rightMargin: 6
        }
    }
}
