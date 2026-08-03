import QtQuick 2.15
import QtQuick.Controls 2.15
import "../designsystem" as DS
import "../components"

Item {
    id: root
    width: 1280
    height: 960

    signal enterDashboardRequested()

    Rectangle { anchors.fill: parent; color: DS.Colors.background }

    Canvas {
        id: bgCanvas
        anchors.fill: parent

        property var nodes: []
        readonly property int nodeCount: 60
        readonly property real linkDistance: 160

        function initNodes() {
            if (width <= 0 || height <= 0) return;
            var arr = [];
            for (var i = 0; i < nodeCount; i++) {
                arr.push({
                    x: Math.random() * width,
                    y: Math.random() * height,
                    vx: (Math.random() - 0.5) * 0.35,
                    vy: (Math.random() - 0.5) * 0.35,
                    r: 1.4 + Math.random() * 2.2
                });
            }
            nodes = arr;
        }

        function step() {
            if (nodes.length === 0) return;
            for (var i = 0; i < nodes.length; i++) {
                var n = nodes[i];
                n.x += n.vx;
                n.y += n.vy;
                if (n.x <= 0 || n.x >= width) { n.vx *= -1; n.x = Math.max(0, Math.min(width, n.x)); }
                if (n.y <= 0 || n.y >= height) { n.vy *= -1; n.y = Math.max(0, Math.min(height, n.y)); }
            }
            requestPaint();
        }

        onWidthChanged: initNodes()
        onHeightChanged: initNodes()
        Component.onCompleted: initNodes()

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            ctx.lineWidth = 1;
            for (var i = 0; i < nodes.length; i++) {
                for (var j = i + 1; j < nodes.length; j++) {
                    var a = nodes[i], b = nodes[j];
                    var dx = a.x - b.x, dy = a.y - b.y;
                    var dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist < linkDistance) {
                        ctx.strokeStyle = DS.Colors.edgeColor;
                        ctx.globalAlpha = 0.9 * (1 - dist / linkDistance);
                        ctx.beginPath();
                        ctx.moveTo(a.x, a.y);
                        ctx.lineTo(b.x, b.y);
                        ctx.stroke();
                    }
                }
            }

            ctx.globalAlpha = 0.9;
            for (var k = 0; k < nodes.length; k++) {
                var n2 = nodes[k];
                ctx.beginPath();
                ctx.arc(n2.x, n2.y, n2.r, 0, Math.PI * 2);
                ctx.fillStyle = DS.Colors.accent;
                ctx.fill();
            }
            ctx.globalAlpha = 1;
        }

        Timer {
            interval: 33
            running: true
            repeat: true
            onTriggered: bgCanvas.step()
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.043, 0.098, 0.161, 0.35) }
            GradientStop { position: 0.5; color: Qt.rgba(0.043, 0.098, 0.161, 0.72) }
            GradientStop { position: 1.0; color: Qt.rgba(0.043, 0.098, 0.161, 0.92) }
        }
    }
    Column {
        id: content
        anchors.centerIn: parent
        width: 440
        spacing: DS.Layout.s_l

        // ---- title / subtitle --------------------------------------------
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "Project NETWORK SOCIAL ANALYSIS "
            font: DS.Typography.display
            color: DS.Colors.textPrimary
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: "Network Structural Analysis - explore users, friendships and communities as a living graph"
            font: DS.Typography.caption
            color: DS.Colors.textMuted
        }

        // ---- enter button --------------------------------------------------
        Item {
            width: parent.width
            height: enterBtn.height

            Btn {
                id: enterBtn
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Enter Dashboard"
                variant: "primary"
                onClicked: root.enterDashboardRequested()
            }
        }
    }
}
