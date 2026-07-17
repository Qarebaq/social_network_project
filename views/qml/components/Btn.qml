import QtQuick 2.15
import QtQuick.Controls 2.15
import "../designsystem" as DS

/*
    Btn.qml
    -------
    This file existed already but had three bugs that would have crashed
    at load time or misbehaved silently:
      1. `import DesignSystem.Styles`  -> that module doesn't exist,
         the design-system module is just "DesignSystem" (see qmldir).
      2. `width: Layout`               -> Layout is a whole singleton
         object, not a number; you can't assign it directly to width.
      3. Naming the spacing/size singleton "Layout" collides with
         QtQuick.Layouts' attached type `Layout` (Layout.fillWidth,
         Layout.preferredHeight, Layout.alignment - used all over the
         login screen inside ColumnLayout/RowLayout). Importing this
         module with "as DS" avoids that clash: we always write
         DS.Layout.xxx, never a bare Layout.xxx.

    variant: "primary" | "secondary" | "ghost" | "danger"
    (style matches the existing "Secure Login" / "Cancel" buttons in
    the login screen, just made reusable)

    Usage:
        Btn { text: "Add Node"; variant: "primary"; onClicked: ... }
*/
Button {
    id: root

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

    contentItem: Row {
        spacing: DS.Layout.s_mm + 3
        anchors.centerIn: parent

        BusyIndicator {
            visible: root.busy
            running: root.busy
            width: 16; height: 16
        }

        Text {
            id: label
            text: root.text
            font: DS.Typography.bodyStrong
            color: root.isPrimary ? DS.Colors.textOnAccent : DS.Colors.textPrimary
            visible: !root.busy
        }
    }
}
