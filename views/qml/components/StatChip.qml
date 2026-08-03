import QtQuick 2.15
import "../designsystem" as DS

Rectangle {
    id: root
    property string label: ""
    property string value: ""
    property color accent: DS.Colors.accent
    property bool solid: false

    radius: DS.Layout.radi_xxl
    color: solid ? Qt.rgba(accent.r, accent.g, accent.b, 0.16) : DS.Colors.surfaceAlt
    border.width: 1
    border.color: solid ? accent : DS.Colors.border
    implicitHeight: 26
    implicitWidth: row.implicitWidth + DS.Layout.s_sm * 2

    Row {
        id: row
        anchors.centerIn: parent
        spacing: DS.Layout.s_mm

        Rectangle {
            width: 7; height: 7; radius: 3.5
            color: root.accent
            anchors.verticalCenter: parent.verticalCenter
            visible: root.label.length > 0
        }
        Text {
            text: root.label.length > 0 ? root.label + ":" : ""
            font: DS.Typography.caption
            color: DS.Colors.textSecondary
            visible: root.label.length > 0
        }
        Text {
            text: root.value
            font: DS.Typography.bodyStrong
            color: root.solid ? root.accent : DS.Colors.textPrimary
        }
    }
}
