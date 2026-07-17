import QtQuick 2.15
import "../designsystem" as DS

/*
    EmptyState
    ----------
    Placeholder shown in ResultPanel before any action has been run, or
    in UserPanel when the graph has no users yet.
*/
Column {
    id: root
    property string icon: "network"
    property string message: "Nothing to show yet"

    anchors.centerIn: parent
    spacing: DS.Layout.s_mm

    AppIcon {
        name: root.icon
        size: 28
        color: DS.Colors.textFaint
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
        text: root.message
        font: DS.Typography.body
        color: DS.Colors.textMuted
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
