import QtQuick 2.15
import "../designsystem" as DS

/*
    AppIcon
    -------
    Renders an icon by name (see DS.Icons.names for the valid list).
    A handful of icons used on the dashboard sidebar/topbar are drawn by
    hand with Canvas, using the exact same technique as the person/lock/
    eye icons already hand-drawn inside the login screen. Anything not
    in that hand-drawn set falls back to a plain-text glyph from
    DS.Icons.glyphFor(), so an unknown name never crashes the UI.

    Usage:
        AppIcon { name: "dashboard"; size: 18; color: DS.Colors.accent }
*/
Item {
    id: root
    property string name: "dashboard"
    property color color: DS.Colors.textSecondary
    property int size: 18

    implicitWidth: size
    implicitHeight: size

    Canvas {
        id: canvas
        anchors.fill: parent
        visible: ["dashboard", "network", "people", "communities", "shield",
                   "search", "bell", "plus", "gear"].indexOf(root.name) !== -1
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.strokeStyle = root.color;
            ctx.fillStyle = root.color;
            ctx.lineWidth = 1.6;
            ctx.lineCap = "round";
            ctx.lineJoin = "round";
            var w = width, h = height;

            switch (root.name) {
            case "dashboard":
                // 2x2 grid of rounded squares
                var g = w * 0.42, gap = w * 0.16;
                ctx.roundedRect(0, 0, g, g, 2, 2); ctx.stroke();
                ctx.roundedRect(g + gap, 0, g, g, 2, 2); ctx.stroke();
                ctx.roundedRect(0, g + gap, g, g, 2, 2); ctx.stroke();
                ctx.roundedRect(g + gap, g + gap, g, g, 2, 2); ctx.stroke();
                break;
            case "network":
                // small node graph, same idea as the login logo
                var pts = [[w*0.5,h*0.1],[w*0.15,h*0.45],[w*0.85,h*0.45],[w*0.3,h*0.9],[w*0.7,h*0.9]];
                var edges = [[0,1],[0,2],[1,3],[2,4],[1,2]];
                edges.forEach(function(e){
                    ctx.beginPath(); ctx.moveTo(pts[e[0]][0], pts[e[0]][1]);
                    ctx.lineTo(pts[e[1]][0], pts[e[1]][1]); ctx.stroke();
                });
                pts.forEach(function(p){
                    ctx.beginPath(); ctx.arc(p[0], p[1], w*0.09, 0, Math.PI*2); ctx.fill();
                });
                break;
            case "people":
                ctx.beginPath(); ctx.arc(w*0.35, h*0.32, w*0.16, 0, Math.PI*2); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(w*0.1, h*0.85);
                ctx.bezierCurveTo(w*0.1, h*0.55, w*0.6, h*0.55, w*0.6, h*0.85); ctx.stroke();
                ctx.beginPath(); ctx.arc(w*0.68, h*0.28, w*0.12, 0, Math.PI*2); ctx.stroke();
                break;
            case "communities":
                ctx.beginPath();
                ctx.roundedRect(w*0.08, h*0.15, w*0.84, h*0.55, 4, 4);
                ctx.stroke();
                ctx.beginPath();
                ctx.moveTo(w*0.25, h*0.7); ctx.lineTo(w*0.2, h*0.92); ctx.lineTo(w*0.45, h*0.7);
                ctx.stroke();
                break;
            case "shield":
                ctx.beginPath();
                ctx.moveTo(w*0.5, h*0.05);
                ctx.lineTo(w*0.9, h*0.2);
                ctx.lineTo(w*0.9, h*0.5);
                ctx.bezierCurveTo(w*0.9, h*0.8, w*0.7, h*0.95, w*0.5, h*1.0);
                ctx.bezierCurveTo(w*0.3, h*0.95, w*0.1, h*0.8, w*0.1, h*0.5);
                ctx.lineTo(w*0.1, h*0.2);
                ctx.closePath();
                ctx.stroke();
                break;
            case "search":
                ctx.beginPath(); ctx.arc(w*0.42, h*0.42, w*0.3, 0, Math.PI*2); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(w*0.65, h*0.65); ctx.lineTo(w*0.92, h*0.92); ctx.stroke();
                break;
            case "bell":
                ctx.beginPath();
                ctx.arc(w*0.5, h*0.45, w*0.3, Math.PI, 0);
                ctx.lineTo(w*0.85, h*0.75); ctx.lineTo(w*0.15, h*0.75);
                ctx.closePath(); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(w*0.4, h*0.85);
                ctx.bezierCurveTo(w*0.4, h*0.95, w*0.6, h*0.95, w*0.6, h*0.85);
                ctx.stroke();
                break;
            case "plus":
                ctx.beginPath(); ctx.moveTo(w*0.5, h*0.1); ctx.lineTo(w*0.5, h*0.9); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(w*0.1, h*0.5); ctx.lineTo(w*0.9, h*0.5); ctx.stroke();
                break;
            case "gear":
                ctx.beginPath(); ctx.arc(w*0.5, h*0.5, w*0.22, 0, Math.PI*2); ctx.stroke();
                for (var i = 0; i < 8; i++) {
                    var a = (Math.PI * 2 / 8) * i;
                    var x1 = w*0.5 + Math.cos(a) * w*0.32, y1 = h*0.5 + Math.sin(a) * h*0.32;
                    var x2 = w*0.5 + Math.cos(a) * w*0.42, y2 = h*0.5 + Math.sin(a) * h*0.42;
                    ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.stroke();
                }
                break;
            }
        }
        Connections {
            target: root
            function onColorChanged() { canvas.requestPaint(); }
            function onNameChanged() { canvas.requestPaint(); }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: !canvas.visible
        text: DS.Icons.glyphFor(root.name)
        color: root.color
        font.pixelSize: root.size * 0.85
    }
}
