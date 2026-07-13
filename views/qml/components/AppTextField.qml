import QtQuick 2.15
import QtQuick.Controls 2.15
import "../designsystem" as DS

/*
    AppTextField
    ------------
    Labeled text field with an optional inline error message. Visually
    matches the username/password fields already built in the login
    screen (rounded #1a2a42 field, cyan focus border, #c0392b error
    border) but reusable for the "add user" / "add friendship" dialogs.
*/
Column {
    id: root
    spacing: DS.Layout.s_mm

    property alias text: field.text
    property alias placeholderText: field.placeholderText
    property alias validator: field.validator
    property alias echoMode: field.echoMode
    property string label: ""
    property string errorText: ""
    readonly property bool hasError: errorText.length > 0

    width: parent ? parent.width : implicitWidth

    Text {
        text: root.label
        font: DS.Typography.label
        color: DS.Colors.textSecondary
        visible: root.label.length > 0
    }

    TextField {
        id: field
        width: parent.width
        implicitHeight: DS.Layout.h_ml
        font: DS.Typography.body
        color: DS.Colors.textPrimary
        selectionColor: DS.Colors.accent
        placeholderTextColor: DS.Colors.textFaint
        leftPadding: DS.Layout.s_sm + 4
        rightPadding: DS.Layout.s_sm + 4

        background: Rectangle {
            radius: DS.Layout.radi_m
            color: DS.Colors.surfaceAlt
            border.width: field.activeFocus ? 1.5 : 1
            border.color: root.hasError
                          ? DS.Colors.danger
                          : (field.activeFocus ? DS.Colors.accent : DS.Colors.borderSoft)
            Behavior on border.color { ColorAnimation { duration: 150 } }
        }
    }

    Text {
        text: root.errorText
        font: DS.Typography.caption
        color: DS.Colors.dangerBright
        visible: root.hasError
        width: parent.width
        wrapMode: Text.WordWrap
    }
}
