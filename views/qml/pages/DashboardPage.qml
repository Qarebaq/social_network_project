import QtQuick 2.15
import QtQuick.Controls 2.15
import "../designsystem" as DS
import "../components"

/*
    DashboardPage
    -------------
    The screen shown right after login. Visually it follows the reference
    screenshot (dark sidebar, topbar search, stat cards, graph preview +
    activity feed, quick actions row) but every widget is mapped onto the
    actual project domain from the UML instead of the generic placeholder
    content in the reference image:

        screenshot "Total Users / Active Links / Network Health"
            -> NetworkStatistics.total_users / total_friendships / average_degree
        screenshot "Topology Preview"
            -> GraphView (users + friendships), drawn with a small Canvas
        screenshot "Node Trends" activity feed
            -> recent suggestions / new friendships (FriendSuggestionResult)
        screenshot "Node Analysis Quick-Action"
            -> the real controller actions: shortest path, suggestions,
               components, statistics
        screenshot "Global Distribution" world map
            -> replaced with a "Largest Communities" panel (ComponentResult),
               since a social graph has no geography - a literal world map
               would be misleading here (see PDF notes)

    This page is currently wired with placeholder/mock data (see the
    `--- MOCK DATA ---` blocks below). To connect it to the real app,
    replace those blocks with bindings to MainController / GraphFacade
    through a QObject bridge exposed from Python (see the PDF for the
    suggested wiring).
*/
Item {
    id: root
    width: 1280
    height: 960

    signal logoutRequested()
    signal addUserRequested()
    signal addFriendshipRequested()
    signal navigateRequested(string section)  // "dashboard" | "graph" | "users" | "results" | "settings"

    property string activeSection: "dashboard"

    // ---- MOCK DATA (replace with real bindings later) --------------------
    readonly property var stats: ({
        totalUsers: 128,
        totalFriendships: 342,
        averageDegree: 5.3,
        largestComponentSize: 96
    })
    ListModel {
        id: activityModel
        ListElement { kind: "suggestion"; title: "New suggestion"; detail: "Ali and Sara share 4 mutual friends"; time: "2m ago"; tagText: "SCORE 0.82"; tagOk: true }
        ListElement { kind: "friendship"; title: "New friendship"; detail: "Reza connected with Niloofar"; time: "14m ago"; tagText: "VERIFIED"; tagOk: true }
        ListElement { kind: "component";  title: "Component merged"; detail: "Two communities became one (12 users)"; time: "28m ago"; tagText: "REVIEW"; tagOk: false }
        ListElement { kind: "stat";       title: "Stats refreshed"; detail: "Average degree increased to 5.3"; time: "1h ago"; tagText: "OK"; tagOk: true }
    }
    ListModel {
        id: componentsModel
        ListElement { name: "Community A"; size: 96 }
        ListElement { name: "Community B"; size: 54 }
        ListElement { name: "Community C"; size: 31 }
        ListElement { name: "Community D"; size: 12 }
    }
    // simple mock node layout for the topology preview canvas
    readonly property var mockNodes: ([
        { x: 0.30, y: 0.30, comp: 0 }, { x: 0.55, y: 0.22, comp: 0 },
        { x: 0.72, y: 0.42, comp: 1 }, { x: 0.20, y: 0.60, comp: 0 },
        { x: 0.45, y: 0.65, comp: 0 }, { x: 0.65, y: 0.72, comp: 1 },
        { x: 0.85, y: 0.60, comp: 1 }, { x: 0.40, y: 0.85, comp: 2 }
    ])
    readonly property var mockEdges: ([[0,1],[0,3],[1,4],[3,4],[4,7],[2,5],[2,6],[5,6]])
    // ---- end mock data -----------------------------------------------------

    Rectangle { anchors.fill: parent; color: DS.Colors.background }

    Row {
        anchors.fill: parent

        // ══════════════════════════════════════
        // SIDEBAR
        // ══════════════════════════════════════
        Rectangle {
            id: sidebar
            width: 240
            height: parent.height
            color: DS.Colors.background
            border.width: 0

            Rectangle { anchors.right: parent.right; width: 1; height: parent.height; color: DS.Colors.border }

            Column {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: DS.Layout.s_sm + 6
                spacing: DS.Layout.s_s

                Column {
                    spacing: 2
                    Text { text: "Social Network"; font: DS.Typography.h1; color: DS.Colors.accent }
                    Text { text: "Graph Analysis"; font: DS.Typography.tiny; color: DS.Colors.textMuted }
                }

                Item { width: 1; height: DS.Layout.s_mm }

                Column {
                    width: parent.width
                    spacing: DS.Layout.s_mm

                    Repeater {
                        model: [
                            { id: "dashboard", label: "Dashboard",      icon: "dashboard" },
                            { id: "graph",     label: "Graph Explorer", icon: "network" },
                            { id: "users",     label: "Users",          icon: "people" },
                            { id: "results",   label: "Communities",    icon: "communities" },
                            { id: "settings",  label: "Management",     icon: "shield" }
                        ]
                        delegate: navDelegate
                    }
                }
            }

            Column {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: DS.Layout.s_sm + 6
                spacing: DS.Layout.s_mm

                Repeater {
                    model: [
                        { id: "help",     label: "Support",  icon: "help" },
                        { id: "settings", label: "Settings", icon: "gear" }
                    ]
                    delegate: navDelegate
                }

                Btn {
                    text: "Log Out"
                    variant: "secondary"
                    width: parent.width
                    onClicked: root.logoutRequested()
                }
            }
        }

        // ══════════════════════════════════════
        // MAIN CONTENT
        // ══════════════════════════════════════
        Flickable {
            id: contentScroll
            width: parent.width - sidebar.width
            height: parent.height
            contentWidth: width
            contentHeight: mainCol.implicitHeight + DS.Layout.s_l
            clip: true

            Column {
                id: mainCol
                width: parent.width - (DS.Layout.s_s * 2)
                x: DS.Layout.s_s
                y: DS.Layout.s_sm + 6
                spacing: DS.Layout.s_s

                // ---- Topbar ----------------------------------------------------
                Row {
                    width: parent.width
                    height: 44
                    spacing: DS.Layout.s_sm

                    Rectangle {
                        width: parent.width - 320
                        height: parent.height
                        radius: DS.Layout.radi_xl
                        color: DS.Colors.surfaceAlt
                        border.width: 1
                        border.color: DS.Colors.border

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: DS.Layout.s_sm
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: DS.Layout.s_mm
                            AppIcon { name: "search"; size: 16; color: DS.Colors.textMuted; anchors.verticalCenter: parent.verticalCenter }
                            Text {
                                text: "Quick search users, friendships, or components..."
                                font: DS.Typography.body
                                color: DS.Colors.textFaint
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    IconButton { iconName: "bell"; showBadge: true; anchors.verticalCenter: parent.verticalCenter }

                    Btn {
                        text: "Add User"
                        variant: "primary"
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: root.addUserRequested()
                    }

                    Row {
                        spacing: DS.Layout.s_mm
                        anchors.verticalCenter: parent.verticalCenter
                        Column {
                            spacing: 0
                            Text { text: "Analyst"; font: DS.Typography.caption; color: DS.Colors.textMuted; horizontalAlignment: Text.AlignRight; anchors.right: parent.right }
                            Text { text: "Session Active"; font: DS.Typography.bodyStrong; color: DS.Colors.textPrimary }
                        }
                        Rectangle {
                            width: 36; height: 36; radius: 18
                            color: DS.Colors.surfaceAlt
                            border.width: 1; border.color: DS.Colors.accent
                            anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "A"; color: DS.Colors.accent; font: DS.Typography.bodyStrong }
                        }
                    }
                }

                // ---- Stat cards --------------------------------------------------
                Row {
                    width: parent.width
                    spacing: DS.Layout.s_sm
                    height: 120

                    Repeater {
                        model: [
                            { label: "Total Users", value: String(root.stats.totalUsers), sub: "+ live", accent: DS.Colors.accent, icon: "people" },
                            { label: "Total Friendships", value: String(root.stats.totalFriendships), sub: "+ live", accent: DS.Colors.success, icon: "network" },
                            { label: "Average Degree", value: root.stats.averageDegree.toFixed(1), sub: "connections / user", accent: DS.Colors.warning, icon: "dashboard" }
                        ]
                        delegate: statCardComponent
                    }
                }

                // ---- Topology preview + activity feed -----------------------------
                Row {
                    width: parent.width
                    spacing: DS.Layout.s_sm
                    height: 340

                    Card {
                        width: parent.width * 0.62
                        height: parent.height
                        title: "Topology Preview"
                        subtitle: "Largest connected community"

                        Column {
                            anchors.fill: parent
                            spacing: DS.Layout.s_mm

                            Rectangle {
                                width: parent.width
                                height: parent.height - 40
                                radius: DS.Layout.radi_m
                                color: DS.Colors.background
                                border.width: 1
                                border.color: DS.Colors.border
                                clip: true

                                Canvas {
                                    id: graphCanvas
                                    anchors.fill: parent
                                    anchors.margins: DS.Layout.s_sm
                                    onPaint: {
                                        var ctx = getContext("2d");
                                        ctx.clearRect(0, 0, width, height);
                                        var nodes = root.mockNodes, edges = root.mockEdges;

                                        ctx.strokeStyle = DS.Colors.edgeColor;
                                        ctx.lineWidth = 1.4;
                                        edges.forEach(function(e) {
                                            var a = nodes[e[0]], b = nodes[e[1]];
                                            ctx.beginPath();
                                            ctx.moveTo(a.x * width, a.y * height);
                                            ctx.lineTo(b.x * width, b.y * height);
                                            ctx.stroke();
                                        });

                                        nodes.forEach(function(n) {
                                            ctx.beginPath();
                                            ctx.arc(n.x * width, n.y * height, n.comp === 0 ? 7 : 5, 0, Math.PI * 2);
                                            ctx.fillStyle = DS.Colors.colorForComponent(n.comp);
                                            ctx.fill();
                                        });
                                    }
                                }

                                Row {
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    anchors.margins: DS.Layout.s_mm
                                    spacing: DS.Layout.s_mm
                                    StatChip { label: ""; value: root.mockNodes.length + " nodes shown"; accent: DS.Colors.accent }
                                    StatChip { label: ""; value: root.mockEdges.length + " edges"; accent: DS.Colors.success }
                                }
                            }
                        }
                    }

                    Card {
                        width: parent.width * 0.38 - DS.Layout.s_sm
                        height: parent.height
                        title: "Recent Activity"

                        ListView {
                            anchors.fill: parent
                            spacing: DS.Layout.s_mm
                            clip: true
                            model: activityModel
                            delegate: Row {
                                width: ListView.view.width
                                spacing: DS.Layout.s_mm

                                Rectangle {
                                    width: 30; height: 30; radius: DS.Layout.radi_s
                                    color: DS.Colors.surfaceAlt
                                    border.width: 1; border.color: DS.Colors.border
                                    AppIcon {
                                        anchors.centerIn: parent
                                        size: 15
                                        color: model.tagOk ? DS.Colors.success : DS.Colors.warning
                                        name: model.kind === "friendship" ? "people"
                                              : model.kind === "component" ? "communities"
                                              : model.kind === "stat" ? "dashboard" : "network"
                                    }
                                }

                                Column {
                                    width: parent.width - 40
                                    spacing: 2
                                    Item {
                                        width: parent.width
                                        height: activityTitle.implicitHeight
                                        Text {
                                            id: activityTitle
                                            anchors.left: parent.left
                                            text: model.title
                                            font: DS.Typography.bodyStrong
                                            color: DS.Colors.textPrimary
                                        }
                                        Text {
                                            anchors.right: parent.right
                                            text: model.time
                                            font: DS.Typography.caption
                                            color: DS.Colors.textFaint
                                        }
                                    }
                                    Text {
                                        text: model.detail
                                        font: DS.Typography.caption
                                        color: DS.Colors.textSecondary
                                        width: parent.width
                                        wrapMode: Text.WordWrap
                                    }
                                    StatChip { label: ""; value: model.tagText; accent: model.tagOk ? DS.Colors.success : DS.Colors.warning; solid: true }
                                }
                            }
                        }
                    }
                }

                // ---- Quick actions + communities overview --------------------------
                Row {
                    width: parent.width
                    spacing: DS.Layout.s_sm
                    height: 210

                    Card {
                        width: parent.width * 0.5
                        height: parent.height
                        title: "Quick Analysis"

                        Grid {
                            anchors.fill: parent
                            columns: 2
                            rows: 2
                            columnSpacing: DS.Layout.s_mm
                            rowSpacing: DS.Layout.s_mm

                            Repeater {
                                model: [
                                    { icon: "network", title: "Shortest Path", subtitle: "Find path between users", target: "results" },
                                    { icon: "people", title: "Suggest Friends", subtitle: "Mutual-friend recommendations", target: "results" },
                                    { icon: "communities", title: "Components", subtitle: "Detect connected communities", target: "results" },
                                    { icon: "dashboard", title: "Statistics", subtitle: "Full network statistics report", target: "results" }
                                ]
                                delegate: quickActionComponent
                            }
                        }
                    }

                    Card {
                        width: parent.width * 0.5 - DS.Layout.s_sm
                        height: parent.height
                        title: "Largest Communities"
                        subtitle: "Replaces the reference screenshot's world map - not applicable to a social graph"

                        Column {
                            anchors.fill: parent
                            spacing: DS.Layout.s_mm

                            Repeater {
                                model: componentsModel
                                delegate: Row {
                                    width: parent.width
                                    spacing: DS.Layout.s_mm

                                    Text {
                                        width: 110
                                        text: model.name
                                        font: DS.Typography.caption
                                        color: DS.Colors.textSecondary
                                        elide: Text.ElideRight
                                    }
                                    Rectangle {
                                        width: parent.width - 110 - sizeLabel.implicitWidth - DS.Layout.s_mm * 2
                                        height: 14
                                        radius: 7
                                        color: DS.Colors.surfaceAlt
                                        anchors.verticalCenter: parent.verticalCenter

                                        Rectangle {
                                            height: parent.height
                                            radius: 7
                                            width: parent.width * (model.size / root.stats.largestComponentSize)
                                            color: DS.Colors.colorForComponent(index)
                                        }
                                    }
                                    Text {
                                        id: sizeLabel
                                        text: model.size + " users"
                                        font: DS.Typography.caption
                                        color: DS.Colors.textMuted
                                    }
                                }
                            }
                        }
                    }
                }

                Item { width: 1; height: DS.Layout.s_sm }
            }
        }
    }

    // ---- Reusable inline "component" for the sidebar nav rows ----------------
    Component {
        id: navDelegate
        Rectangle {
            width: parent ? parent.width : 200
            height: 40
            radius: DS.Layout.radi_m
            property bool active: root.activeSection === modelData.id
            color: active ? DS.Colors.surfaceAlt : (navMouse.containsMouse ? DS.Colors.surface : "transparent")
            border.width: active ? 1 : 0
            border.color: DS.Colors.accent

            Row {
                anchors.left: parent.left
                anchors.leftMargin: DS.Layout.s_mm
                anchors.verticalCenter: parent.verticalCenter
                spacing: DS.Layout.s_mm
                AppIcon {
                    name: modelData.icon
                    size: 17
                    color: parent.parent.active ? DS.Colors.accent : DS.Colors.textSecondary
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: modelData.label
                    font: parent.parent.active ? DS.Typography.bodyStrong : DS.Typography.body
                    color: parent.parent.active ? DS.Colors.textPrimary : DS.Colors.textSecondary
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: navMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.activeSection = modelData.id;
                    root.navigateRequested(modelData.id);
                }
            }
        }
    }

    // ---- Repeater delegate Components used above (read straight from modelData) --
    Component {
        id: statCardComponent
        Card {
            id: statCardRoot
            width: (mainCol.width - DS.Layout.s_sm * 2) / 3
            height: 120

            Row {
                anchors.fill: parent
                Column {
                    width: parent.width - 44
                    spacing: DS.Layout.s_mm
                    Text { text: modelData.label; font: DS.Typography.caption; color: DS.Colors.textMuted }
                    Text { text: modelData.value; font: DS.Typography.display; color: DS.Colors.textPrimary }
                    Text { text: modelData.sub; font: DS.Typography.tiny; color: modelData.accent }
                }
                Rectangle {
                    width: 40; height: 40; radius: DS.Layout.radi_m
                    color: DS.Colors.surfaceAlt
                    anchors.verticalCenter: parent.verticalCenter
                    AppIcon { anchors.centerIn: parent; name: modelData.icon; color: modelData.accent; size: 18 }
                }
            }
        }
    }

    Component {
        id: quickActionComponent
        Rectangle {
            id: qaRoot
            width: 200; height: 80
            radius: DS.Layout.radi_m
            color: qaMouse.containsMouse ? DS.Colors.surfaceRaised : DS.Colors.surfaceAlt
            border.width: 1
            border.color: DS.Colors.border
            Behavior on color { ColorAnimation { duration: 100 } }

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: DS.Layout.s_mm
                spacing: DS.Layout.s_mm
                Rectangle {
                    width: 32; height: 32; radius: DS.Layout.radi_s
                    color: DS.Colors.surface
                    AppIcon { anchors.centerIn: parent; name: modelData.icon; color: DS.Colors.accent; size: 15 }
                }
                Column {
                    spacing: 2
                    Text { text: modelData.title; font: DS.Typography.bodyStrong; color: DS.Colors.textPrimary }
                    Text { text: modelData.subtitle; font: DS.Typography.tiny; color: DS.Colors.textMuted; width: 140; wrapMode: Text.WordWrap }
                }
            }

            MouseArea {
                id: qaMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.navigateRequested(modelData.target)
            }
        }
    }
}
