import QtQuick 2.15
import "../designsystem" as DS

/*
    Card
    ----
    Generic elevated container, same look as the login card (#141f35
    surface, #1e3557 border, rounded corners). Dashboard stat cards,
    the graph preview panel, and the activity feed all sit inside one
    of these so the whole app shares one consistent "panel" look.

    Usage:
        Card { title: "Users"; Column { ... } }
*/
Rectangle {
    id: root
    default property alias content: body.children
    property string title: ""
    property string subtitle: ""

    color: DS.Colors.surface
    radius: DS.Layout.radi_xl
    border.width: 1
    border.color: DS.Colors.border

    Column {
        id: headerCol
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: DS.Layout.s_sm + 6
        spacing: 2
        visible: root.title.length > 0

        Text {
            text: root.title
            font: DS.Typography.h2
            color: DS.Colors.textPrimary
        }
        Text {
            text: root.subtitle
            font: DS.Typography.caption
            color: DS.Colors.textMuted
            visible: root.subtitle.length > 0
        }
    }

    Item {
        id: body
        anchors.top: headerCol.visible ? headerCol.bottom : parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: DS.Layout.s_sm + 6
        anchors.topMargin: headerCol.visible ? DS.Layout.s_mm + 3 : DS.Layout.s_sm + 6
    }
}
