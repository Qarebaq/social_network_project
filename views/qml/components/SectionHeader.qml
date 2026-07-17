import QtQuick 2.15
import "../designsystem" as DS

/*
    SectionHeader
    -------------
    "Title .......... [actions]" row, used above lists/tables inside cards.
*/
Item {
    id: root
    default property alias actions: actionRow.children
    property string title: ""

    implicitHeight: Math.max(titleText.implicitHeight, actionRow.implicitHeight)

    Text {
        id: titleText
        text: root.title
        font: DS.Typography.h3
        color: DS.Colors.textPrimary
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Row {
        id: actionRow
        spacing: DS.Layout.s_mm + 3
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}
