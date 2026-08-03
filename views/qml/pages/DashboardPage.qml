import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import "../designsystem" as DS
import "../components"

Item {
    id: root
    width: 1280
    height: 960

    signal logoutRequested()
    signal addUserRequested()
    signal addFriendshipRequested()
    signal navigateRequested(string section)  // "dashboard" | "graph" | "users" | "results" | "settings"

    property string activeSection: "dashboard"


    readonly property bool hasBridge: typeof bridge !== "undefined" && bridge !== null
    readonly property var pyBridge: hasBridge ? bridge : null

    property var liveUsers: []
    property var liveNodes: []
    property var liveEdges: []
    readonly property var stats: ({
        totalUsers: liveUsers.length,
        totalFriendships: liveEdges.length,
        averageDegree: liveUsers.length > 0 ? (2 * liveEdges.length / liveUsers.length) : 0,
        largestComponentSize: componentsModel.count > 0 ? componentsModel.get(0).size : 0
    })

    Connections {
        target: root.pyBridge
        function onUsersChanged(users) { root.liveUsers = users; }
        function onGraphChanged(nodes, edges) { root.rebuildTopology(nodes, edges); }
        function onResultReady(title, content) { resultDialog.openWith(title, content, false); }
        function onErrorOccurred(message) { resultDialog.openWith("Error", message, true); }
    }

    function rebuildTopology(nodes, edges) {
        // The bridge only sends ids/names; lay nodes out on a circle here.
        var laidOut = [];
        var idToIndex = {};
        for (var i = 0; i < nodes.length; i++) {
            var angle = (2 * Math.PI * i) / Math.max(nodes.length, 1);
            laidOut.push({
                id: nodes[i].id,
                name: nodes[i].name,
                x: 0.5 + 0.40 * Math.cos(angle),
                y: 0.5 + 0.40 * Math.sin(angle)
            });
            idToIndex[nodes[i].id] = i;
        }
        var indexedEdges = [];
        for (var j = 0; j < edges.length; j++) {
            var a = idToIndex[edges[j].source], b = idToIndex[edges[j].target];
            if (a !== undefined && b !== undefined) indexedEdges.push([a, b]);
        }
        root.liveNodes = laidOut;
        root.liveEdges = indexedEdges;
        graphCanvas.requestPaint();
    }
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
    // ---- end demo data -----------------------------------------------------

    Rectangle { anchors.fill: parent; color: DS.Colors.background }

    Row {
        anchors.fill: parent

        // ══════════════════════════════════════
        // SIDEBAR
        // ══════════════════════════════════════
        Rectangle {
            id: sidebar
            width: 200
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
                            { id: "users",     label: "Users",          icon: "people" },
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
                        onClicked: { root.addUserRequested(); addUserDialog.open(); }
                    }

                    Btn {
                        text: "Add Friendship"
                        variant: "secondary"
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: { root.addFriendshipRequested(); addFriendshipDialog.open(); }
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
                                height: parent.height
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
                                        var nodes = root.liveNodes, edges = root.liveEdges;

                                        ctx.strokeStyle = DS.Colors.edgeColor;
                                        ctx.lineWidth = 1.4;
                                        edges.forEach(function(e) {
                                            var a = nodes[e[0]], b = nodes[e[1]];
                                            if (!a || !b) return;
                                            ctx.beginPath();
                                            ctx.moveTo(a.x * width, a.y * height);
                                            ctx.lineTo(b.x * width, b.y * height);
                                            ctx.stroke();
                                        });

                                        nodes.forEach(function(n) {
                                            var cx = n.x * width, cy = n.y * height;

                                            ctx.beginPath();
                                            ctx.arc(cx, cy, 6, 0, Math.PI * 2);
                                            ctx.fillStyle = DS.Colors.colorForComponent(0);
                                            ctx.fill();
                                            ctx.lineWidth = 1;
                                            ctx.strokeStyle = DS.Colors.background;
                                            ctx.stroke();

                                            // small id/name label under each node
                                            ctx.font = "10px " + DS.Typography.fontFamily;
                                            ctx.textAlign = "center";
                                            ctx.fillStyle = DS.Colors.textSecondary;
                                            ctx.fillText(n.name + " (" + n.id + ")", cx, cy + 18);
                                        });
                                    }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    visible: root.liveNodes.length === 0
                                    text: root.hasBridge ? "No users yet — add one to see the graph" : "Preview mode — no live data (open via main.py)"
                                    font: DS.Typography.caption
                                    color: DS.Colors.textFaint
                                }

                                Row {
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    anchors.margins: DS.Layout.s_mm
                                    spacing: DS.Layout.s_mm
                                    StatChip { label: ""; value: root.liveNodes.length + " nodes shown"; accent: DS.Colors.accent }
                                    StatChip { label: ""; value: root.liveEdges.length + " edges"; accent: DS.Colors.success }
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
                    height: 500

                    Card {
                        
                        width: parent.width     
                        height: DS.Layout.w_xxl
                        title: "Quick Analysis"

                        Grid {
                            anchors.fill: parent
                            columns: 5
                            rows: 2
                            columnSpacing: DS.Layout.s_mm
                            rowSpacing: DS.Layout.s_mm

                            Repeater {
                                model: [
                                    {icon:"network",title:"Check Connection",subtitle:"Verify whether two users are connected",action:"connection"},
                                    { icon: "people", title: "Suggest Friends", subtitle: "Mutual-friend recommendations", action: "suggestFriends" },
                                    { icon: "communities", title: "Components", subtitle: "Detect connected communities", action: "components" },
                                    { icon: "dashboard", title: "Statistics", subtitle: "Full network statistics report", action: "statistics" },
                                    { icon: "network", title: "Shortest Path", subtitle: "Find shortest route between two users", action: "shortestPath" },
                                    { icon: "people", title: "Distances", subtitle: "Distance from one user to everyone else", action: "distance" },
                                    { icon: "dashboard", title: "Save Graph", subtitle: "Persist the current graph to a JSON file", action: "save" },
                                    { icon: "network", title: "Load Graph", subtitle: "Load a graph from a JSON file", action: "load" },
                                    { icon: "people", title: "Remove User", subtitle: "Delete a user and their friendships", action: "removeUser" },
                                    { icon: "network", title: "Remove Friendship", subtitle: "Delete a friendship between two users", action: "removeFriendship" }
                                ]
                                delegate: quickActionComponent
                            }
                        }
                    }

                    // Card {
                    //     width: parent.width * 0.5 - DS.Layout.s_sm
                    //     height: parent.height
                    //     title: "Largest Communities"
                    //     subtitle: "Replaces the reference screenshot's world map - not applicable to a social graph"

                    //     Column {
                    //         anchors.fill: parent
                    //         spacing: DS.Layout.s_mm

                    //         Repeater {
                    //             model: componentsModel
                    //             delegate: Row {
                    //                 width: parent.width
                    //                 spacing: DS.Layout.s_mm

                    //                 Text {
                    //                     width: 110
                    //                     text: model.name
                    //                     font: DS.Typography.caption
                    //                     color: DS.Colors.textSecondary
                    //                     elide: Text.ElideRight
                    //                 }
                    //                 Rectangle {
                    //                     width: parent.width - 110 - sizeLabel.implicitWidth - DS.Layout.s_mm * 2
                    //                     height: 14
                    //                     radius: 7
                    //                     color: DS.Colors.surfaceAlt
                    //                     anchors.verticalCenter: parent.verticalCenter

                    //                     Rectangle {
                    //                         height: parent.height
                    //                         radius: 7
                    //                         width: parent.width * (model.size / root.stats.largestComponentSize)
                    //                         color: DS.Colors.colorForComponent(index)
                    //                     }
                    //                 }
                    //                 Text {
                    //                     id: sizeLabel
                    //                     text: model.size + " users"
                    //                     font: DS.Typography.caption
                    //                     color: DS.Colors.textMuted
                    //                 }
                    //             }
                    //         }
                    //     }
                    // }
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
                onClicked: root.runQuickAction(modelData.action)
            }
        }
    }

    // ══════════════════════════════════════
    // DIALOGS (real actions -> bridge calls)
    // ══════════════════════════════════════

    function runQuickAction(action) {

    if (!root.hasBridge) {
        resultDialog.openWith(
            "Preview mode",
            "Run via main.py",
            true)
        return
    }

    switch(action) {

    case "shortestPath":
        shortestPathDialog.open()
        break

    case "suggestFriends":
        suggestFriendsDialog.open()
        break

    case "connection":
        connectionDialog.open()
        break

    case "distance":
        distanceDialog.open()
        break

    case "components":
        root.pyBridge.showComponents()
        break

    case "statistics":
        root.pyBridge.showStatistics()
        break

    case "save":
        saveDialog.open()
        break

    case "load":
        loadDialog.open()
        break

    case "removeUser":
        removeUserDialog.open()
        break

    case "removeFriendship":
        removeFriendshipDialog.open()
        break
    }
}

    Popup {
        id: addUserDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        width: 360
        padding: DS.Layout.s_sm + 6
        background: Rectangle { color: DS.Colors.surface; radius: DS.Layout.radi_l; border.width: 1; border.color: DS.Colors.border }

        Column {
            width: parent.width
            spacing: DS.Layout.s_mm
            Text { text: "Add User"; font: DS.Typography.h2; color: DS.Colors.textPrimary }
            AppTextField { id: newUserId; label: "User ID"; placeholderText: "e.g. E" }
            AppTextField { id: newUserName; label: "Name"; placeholderText: "e.g. Elham" }
            Row {
                width: parent.width
                spacing: DS.Layout.s_mm
                Btn { text: "Cancel"; variant: "ghost"; onClicked: addUserDialog.close() }
                Btn {
                    text: "Add"
                    variant: "primary"
                    onClicked: {
                        if (root.hasBridge && newUserId.text.length > 0 && newUserName.text.length > 0) {
                            root.pyBridge.addUser(newUserId.text, newUserName.text);
                            newUserId.text = ""; newUserName.text = "";
                            addUserDialog.close();
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: addFriendshipDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        width: 360
        padding: DS.Layout.s_sm + 6
        background: Rectangle { color: DS.Colors.surface; radius: DS.Layout.radi_l; border.width: 1; border.color: DS.Colors.border }

        Column {
            width: parent.width
            spacing: DS.Layout.s_mm
            Text { text: "Add Friendship"; font: DS.Typography.h2; color: DS.Colors.textPrimary }
            AppTextField { id: friendUser1; label: "User 1 ID"; placeholderText: "e.g. A" }
            AppTextField { id: friendUser2; label: "User 2 ID"; placeholderText: "e.g. B" }
            Row {
                width: parent.width
                spacing: DS.Layout.s_mm
                Btn { text: "Cancel"; variant: "ghost"; onClicked: addFriendshipDialog.close() }
                Btn {
                    text: "Add"
                    variant: "primary"
                    onClicked: {
                        if (root.hasBridge && friendUser1.text.length > 0 && friendUser2.text.length > 0) {
                            root.pyBridge.addFriendship(friendUser1.text, friendUser2.text);
                            friendUser1.text = ""; friendUser2.text = "";
                            addFriendshipDialog.close();
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: shortestPathDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        width: 360
        padding: DS.Layout.s_sm + 6
        background: Rectangle { color: DS.Colors.surface; radius: DS.Layout.radi_l; border.width: 1; border.color: DS.Colors.border }

        Column {
            width: parent.width
            spacing: DS.Layout.s_mm
            Text { text: "Shortest Path"; font: DS.Typography.h2; color: DS.Colors.textPrimary }
            AppTextField { id: pathSource; label: "From (user id)"; placeholderText: "e.g. A" }
            AppTextField { id: pathTarget; label: "To (user id)"; placeholderText: "e.g. C" }
            Row {
                width: parent.width
                spacing: DS.Layout.s_mm
                Btn { text: "Cancel"; variant: "ghost"; onClicked: shortestPathDialog.close() }
                Btn {
                    text: "Find"
                    variant: "primary"
                    onClicked: {
                        if (root.hasBridge && pathSource.text.length > 0 && pathTarget.text.length > 0) {
                            root.pyBridge.findShortestPath(pathSource.text, pathTarget.text);
                            shortestPathDialog.close();
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: distanceDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        width: 360
        padding: DS.Layout.s_sm + 6
        background: Rectangle { color: DS.Colors.surface; radius: DS.Layout.radi_l; border.width: 1; border.color: DS.Colors.border }

        Column {
            width: parent.width
            spacing: DS.Layout.s_mm
            Text { text: "Distances From User"; font: DS.Typography.h2; color: DS.Colors.textPrimary }
            Text {
                text: "Shows the distance from this user to every other reachable user."
                font: DS.Typography.caption
                color: DS.Colors.textMuted
                wrapMode: Text.WordWrap
                width: parent.width
            }
            AppTextField { id: distanceUserId; label: "User ID"; placeholderText: "e.g. A" }
            Row {
                width: parent.width
                spacing: DS.Layout.s_mm
                Btn { text: "Cancel"; variant: "ghost"; onClicked: distanceDialog.close() }
                Btn {
                    text: "Show"
                    variant: "primary"
                    onClicked: {
                        if (root.hasBridge && distanceUserId.text.length > 0) {
                            root.pyBridge.distancesFromUser(distanceUserId.text.trim());
                            distanceUserId.text = "";
                            distanceDialog.close();
                        }
                    }
                }
            }
        }

        onClosed: distanceUserId.text = ""
    }

    Popup {
        id: saveDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        width: 380
        padding: DS.Layout.s_sm + 6
        background: Rectangle { color: DS.Colors.surface; radius: DS.Layout.radi_l; border.width: 1; border.color: DS.Colors.border }

        Column {
            width: parent.width
            spacing: DS.Layout.s_mm
            Text { text: "Save Graph"; font: DS.Typography.h2; color: DS.Colors.textPrimary }
            Text {
                text: "Saved as a .json file inside the app's data folder - just type a name, no path or extension needed."
                font: DS.Typography.caption
                color: DS.Colors.textMuted
                wrapMode: Text.WordWrap
                width: parent.width
            }
            AppTextField { id: savePath; label: "Graph name"; placeholderText: "e.g. my_network" }
            Row {
                width: parent.width
                spacing: DS.Layout.s_mm
                Btn { text: "Cancel"; variant: "ghost"; onClicked: saveDialog.close() }
                Btn {
                    text: "Save"
                    variant: "primary"
                    onClicked: {
                        if (root.hasBridge && savePath.text.length > 0) {
                            root.pyBridge.saveGraph(savePath.text.trim());
                            savePath.text = "";
                            saveDialog.close();
                        }
                    }
                }
            }
        }

        onClosed: savePath.text = ""
    }

    FileDialog {
        id: loadFileDialog
        title: "Select a graph JSON file"
        nameFilters: ["JSON files (*.json)", "All files (*)"]
        currentFolder: root.hasBridge ? root.pyBridge.dataDirectoryUrl : undefined
        onAccepted: {
            loadPath.text = root.hasBridge ? root.pyBridge.toLocalFile(selectedFile) : "";
        }
    }

    Popup {
        id: loadDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        width: 380
        padding: DS.Layout.s_sm + 6
        background: Rectangle { color: DS.Colors.surface; radius: DS.Layout.radi_l; border.width: 1; border.color: DS.Colors.border }

        Column {
            width: parent.width
            spacing: DS.Layout.s_mm
            Text { text: "Load Graph"; font: DS.Typography.h2; color: DS.Colors.textPrimary }
            Text {
                text: "This replaces the currently loaded graph."
                font: DS.Typography.caption
                color: DS.Colors.textMuted
                wrapMode: Text.WordWrap
                width: parent.width
            }
            Text {
                text: "File"
                font: DS.Typography.label
                color: DS.Colors.textSecondary
            }
            Row {
                id: fileRow
                width: parent.width
                spacing: DS.Layout.s_mm

                AppTextField {
                    id: loadPath
                    width: fileRow.width - attachBtn.width - fileRow.spacing
                    placeholderText: "e.g. my_network.json"
                }
                Btn {
                    id: attachBtn
                    text: "Attach..."
                    variant: "secondary"
                    onClicked: loadFileDialog.open()
                }
            }
            Row {
                width: parent.width
                spacing: DS.Layout.s_mm
                Btn { text: "Cancel"; variant: "ghost"; onClicked: loadDialog.close() }
                Btn {
                    text: "Load"
                    variant: "primary"
                    onClicked: {
                        if (root.hasBridge && loadPath.text.length > 0) {
                            root.pyBridge.loadGraph(loadPath.text.trim());
                            loadPath.text = "";
                            loadDialog.close();
                        }
                    }
                }
            }
        }

        onClosed: loadPath.text = ""
    }

    Popup {
        id: suggestFriendsDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        width: 360
        padding: DS.Layout.s_sm + 6
        background: Rectangle { color: DS.Colors.surface; radius: DS.Layout.radi_l; border.width: 1; border.color: DS.Colors.border }

        Column {
            width: parent.width
            spacing: DS.Layout.s_mm
            Text { text: "Suggest Friends"; font: DS.Typography.h2; color: DS.Colors.textPrimary }
            AppTextField { id: suggestUserId; label: "User ID"; placeholderText: "e.g. A" }
            Row {
                width: parent.width
                spacing: DS.Layout.s_mm
                Btn { text: "Cancel"; variant: "ghost"; onClicked: suggestFriendsDialog.close() }
                Btn {
                    text: "Suggest"
                    variant: "primary"
                    onClicked: {
                        if (root.hasBridge && suggestUserId.text.length > 0) {
                            root.pyBridge.suggestFriends(suggestUserId.text);
                            suggestFriendsDialog.close();
                        }
                    }
                }
            }
        }
    }

    Popup {
    id: connectionDialog

    anchors.centerIn: parent
    modal: true
    focus: true

    width: 380

    padding: DS.Layout.s_sm + 6

    background: Rectangle {
        color: DS.Colors.surface
        radius: DS.Layout.radi_l
        border.width: 1
        border.color: DS.Colors.border
    }

    Column {
        width: parent.width
        spacing: DS.Layout.s_mm

        Text {
            text: "Check Connection"
            font: DS.Typography.h2
            color: DS.Colors.textPrimary
        }

        Text {
            text: "Check whether two users are connected in the graph."
            font: DS.Typography.caption
            color: DS.Colors.textMuted
            wrapMode: Text.WordWrap
            width: parent.width
        }

        AppTextField {
            id: connectionUser1
            label: "First User ID"
            placeholderText: "e.g. A"
        }

        AppTextField {
            id: connectionUser2
            label: "Second User ID"
            placeholderText: "e.g. B"
        }

        Rectangle {
            width: parent.width
            height: 1
            color: DS.Colors.border
        }

        Row {
            width: parent.width
            spacing: DS.Layout.s_mm

            Btn {
                width: (parent.width - spacing) / 2
                text: "Cancel"
                variant: "ghost"

                onClicked: {
                    connectionDialog.close()
                }
            }

            Btn {
                width: (parent.width - spacing) / 2
                text: "Check"
                variant: "primary"

                onClicked: {

                    if (!root.hasBridge)
                        return

                    if (connectionUser1.text === "" ||
                        connectionUser2.text === "")
                        return

                    root.pyBridge.checkConnection(
                                connectionUser1.text.trim(),
                                connectionUser2.text.trim())

                    connectionUser1.text = ""
                    connectionUser2.text = ""

                    connectionDialog.close()
                }
            }
        }
    }

    onClosed: {
        connectionUser1.text = ""
        connectionUser2.text = ""
    }
    }

    Popup {
        id: removeUserDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        width: 360
        padding: DS.Layout.s_sm + 6
        background: Rectangle { color: DS.Colors.surface; radius: DS.Layout.radi_l; border.width: 1; border.color: DS.Colors.border }

        Column {
            width: parent.width
            spacing: DS.Layout.s_mm
            Text { text: "Remove User"; font: DS.Typography.h2; color: DS.Colors.textPrimary }
            Text {
                text: "This also removes every friendship this user is part of."
                font: DS.Typography.caption
                color: DS.Colors.textMuted
                wrapMode: Text.WordWrap
                width: parent.width
            }
            AppTextField { id: removeUserId; label: "User ID"; placeholderText: "e.g. A" }
            Row {
                width: parent.width
                spacing: DS.Layout.s_mm
                Btn { text: "Cancel"; variant: "ghost"; onClicked: removeUserDialog.close() }
                Btn {
                    text: "Remove"
                    variant: "danger"
                    onClicked: {
                        if (root.hasBridge && removeUserId.text.length > 0) {
                            root.pyBridge.removeUser(removeUserId.text.trim());
                            removeUserId.text = "";
                            removeUserDialog.close();
                        }
                    }
                }
            }
        }

        onClosed: removeUserId.text = ""
    }

    Popup {
        id: removeFriendshipDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        width: 360
        padding: DS.Layout.s_sm + 6
        background: Rectangle { color: DS.Colors.surface; radius: DS.Layout.radi_l; border.width: 1; border.color: DS.Colors.border }

        Column {
            width: parent.width
            spacing: DS.Layout.s_mm
            Text { text: "Remove Friendship"; font: DS.Typography.h2; color: DS.Colors.textPrimary }
            AppTextField { id: removeFriendUser1; label: "User 1 ID"; placeholderText: "e.g. A" }
            AppTextField { id: removeFriendUser2; label: "User 2 ID"; placeholderText: "e.g. B" }
            Row {
                width: parent.width
                spacing: DS.Layout.s_mm
                Btn { text: "Cancel"; variant: "ghost"; onClicked: removeFriendshipDialog.close() }
                Btn {
                    text: "Remove"
                    variant: "danger"
                    onClicked: {
                        if (root.hasBridge && removeFriendUser1.text.length > 0 && removeFriendUser2.text.length > 0) {
                            root.pyBridge.removeFriendship(removeFriendUser1.text.trim(), removeFriendUser2.text.trim());
                            removeFriendUser1.text = ""; removeFriendUser2.text = "";
                            removeFriendshipDialog.close();
                        }
                    }
                }
            }
        }

        onClosed: { removeFriendUser1.text = ""; removeFriendUser2.text = ""; }
    }

    Popup {
        id: resultDialog
        anchors.centerIn: parent
        modal: true
        focus: true
        width: 420
        padding: DS.Layout.s_sm + 6
        property bool isError: false

        background: Rectangle { color: DS.Colors.surface; radius: DS.Layout.radi_l; border.width: 1; border.color: resultDialog.isError ? DS.Colors.danger : DS.Colors.border }

        function openWith(title, content, error) {
            resultTitle.text = title;
            resultContent.text = content;
            isError = error;
            open();
        }

        Column {
            width: parent.width
            spacing: DS.Layout.s_mm
            Text { id: resultTitle; font: DS.Typography.h2; color: resultDialog.isError ? DS.Colors.dangerBright : DS.Colors.textPrimary }
            Text { id: resultContent; font: DS.Typography.body; color: DS.Colors.textSecondary; width: parent.width; wrapMode: Text.WordWrap }
            Btn { text: "Close"; variant: "secondary"; onClicked: resultDialog.close() }
        }
    }
}
