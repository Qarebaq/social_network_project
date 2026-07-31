import QtQuick 2.15
import QtQuick.Controls 2.15
import "../designsystem" as DS

Button {
    id: root
    focusPolicy: Qt.NoFocus
    activeFocusOnTab: false
    hoverEnabled: true
    palette.button: "transparent"
    property string variant: "primary"
    property bool busy: false
    enabled: !busy
    implicitWidth: Math.max(DS.Layout.w_sm * 2, label.implicitWidth + DS.Layout.s_sm * 3)
    implicitHeight: DS.Layout.h_ml

    readonly property bool isPrimary: variant === "primary"
    readonly property bool isDanger: variant === "danger"
    readonly property bool isGhost: variant === "ghost"

    background: Rectangle {
        radius: DS.Layout.radi_m
                opacity: bsbutton.enabled ? 1 : 0.3
            Behavior on color {
                ColorAnimation {
                    duration: 150
            }
        }
        border.width: root.isGhost || root.variant === "secondary" ? 1 : 0
        border.color: DS.Colors.borderSoft

        gradient: root.isPrimary ? primaryGradient : null
        color: {
            if (root.isPrimary) return "transparent"; // gradient handles it
            if (root.isDanger)  return root.down ? Qt.darker(DS.Colors.danger, 1.15) : DS.Colors.danger;
            if (root.isGhost)   return root.hovered ? DS.Colors.surfaceAlt : "transparent";
            return root.hovered ? DS.Colors.surfaceRaised : DS.Colors.surfaceAlt; // secondary
        }
    
        
        
        Gradient {
            id: primaryGradient
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: root.hovered ? DS.Colors.accentGradTop : DS.Colors.accentStrong }
            GradientStop { position: 1.0; color: root.hovered ? DS.Colors.accentGradBot : DS.Colors.accentSoft }
        }

        Behavior on color { ColorAnimation { duration: 120 } }
    }

    scale: root.down ? 0.975 : 1.0
    Behavior on scale { NumberAnimation { duration: 90; easing.type: Easing.OutQuad } }

    contentItem: Item {
    anchors.fill: parent

    Row {
        anchors.centerIn: parent
        spacing: DS.Layout.s_mm + 3

        BusyIndicator {
            visible: root.busy
            running: root.busy
            width: 16
            height: 16
        }

        Text {
            id: label
            text: root.text
            font: DS.Typography.bodyStrong
            color: root.isPrimary
                   ? DS.Colors.textOnAccent
                   : DS.Colors.textPrimary
            visible: !root.busy

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
}
