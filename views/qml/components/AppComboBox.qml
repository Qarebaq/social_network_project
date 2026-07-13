import QtQuick 2.15
import QtQuick.Controls 2.15
import "../designsystem" as DS

/*
    AppComboBox
    -----------
    Labeled combo box, used e.g. to pick "user 1" / "user 2" when creating
    a friendship, or the source user for shortest-path / distances.
*/
Column {
    id: root
    spacing: DS.Layout.s_mm
    width: parent ? parent.width : implicitWidth

    property alias model: box.model
    property alias currentIndex: box.currentIndex
    property alias currentText: box.currentText
    property alias textRole: box.textRole
    property alias valueRole: box.valueRole
    property alias currentValue: box.currentValue
    property string label: ""

    Text {
        text: root.label
        font: DS.Typography.label
        color: DS.Colors.textSecondary
        visible: root.label.length > 0
    }

    ComboBox {
        id: box
        width: parent.width
        implicitHeight: DS.Layout.h_ml
        font: DS.Typography.body

        background: Rectangle {
            radius: DS.Layout.radi_m
            color: DS.Colors.surfaceAlt
            border.width: 1
            border.color: box.activeFocus ? DS.Colors.accent : DS.Colors.borderSoft
        }

        contentItem: Text {
            text: box.displayText
            font: DS.Typography.body
            color: DS.Colors.textPrimary
            leftPadding: DS.Layout.s_sm + 4
            verticalAlignment: Text.AlignVCenter
        }

        popup: Popup {
            y: box.height + 4
            width: box.width
            implicitHeight: Math.min(240, listView.contentHeight)
            padding: DS.Layout.s_mm

            background: Rectangle {
                color: DS.Colors.surface
                radius: DS.Layout.radi_m
                border.width: 1
                border.color: DS.Colors.border
            }

            contentItem: ListView {
                id: listView
                clip: true
                implicitHeight: contentHeight
                model: box.popup.visible ? box.delegateModel : null
                currentIndex: box.highlightedIndex
            }
        }

        delegate: ItemDelegate {
            width: box.width
            height: 34
            highlighted: box.highlightedIndex === index

            background: Rectangle {
                color: highlighted ? DS.Colors.surfaceAlt : "transparent"
                radius: DS.Layout.radi_s
            }
            contentItem: Text {
                text: box.textRole ? model[box.textRole] : modelData
                color: DS.Colors.textPrimary
                font: DS.Typography.body
                leftPadding: DS.Layout.s_mm
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
