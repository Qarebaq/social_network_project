import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    width: 1280
    height: 960

    // Emitted once the "Redirecting to dashboard..." progress bar
    // finishes, so App.qml can swap this page out for DashboardPage.
    signal loginSucceeded()

    Rectangle {
        anchors.fill: parent
        color: "#0b1929"
    }

    // ─────────────────────────────────────────────
    // Mock credentials (replace with real auth - see PDF notes)
    // ─────────────────────────────────────────────
    readonly property string validUser: "admin"
    readonly property string validPass: "1234"

    // ══════════════════════════════════════════════
    // STARFIELD BACKGROUND
    // ══════════════════════════════════════════════
    Repeater {
        model: 130
        delegate: Rectangle {
            id: star
            property real rndX:   Math.random()
            property real rndY:   Math.random()
            property real rndOp:  Math.random() * 0.55 + 0.08
            property real rndDur: 900 + Math.random() * 1400
            property bool bigStar: index % 12 === 0
            property bool blueStar: index % 18 === 0

            x:      rndX * root.width
            y:      rndY * root.height
            width:  bigStar ? 2.5 : 1.5
            height: width
            radius: width / 2
            color:  blueStar ? "#4dd9ff" : "#ffffff"
            opacity: rndOp

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: star.rndOp * 0.25; duration: star.rndDur; easing.type: Easing.InOutSine }
                NumberAnimation { to: star.rndOp;        duration: star.rndDur; easing.type: Easing.InOutSine }
            }
        }
    }

    // ══════════════════════════════════════════════
    // LOGIN CARD
    // ══════════════════════════════════════════════
    Rectangle {
        id: card
        width: 400
        anchors.centerIn: parent
        color: "#141f35"
        radius: 16
        border.color: "#1e3557"
        border.width: 1

        // Drop shadow simulation
        Rectangle {
            anchors.fill: parent
            anchors.margins: -8
            radius: parent.radius + 8
            color: "transparent"
            border.color: "#00000055"
            border.width: 8
            z: -1
        }

        ColumnLayout {
            id: mainLayout
            anchors {
                left:  parent.left
                right: parent.right
                top:   parent.top
                margins: 40
            }
            spacing: 0

            // ── Top spacing ──
            Item { Layout.preferredHeight: 36 }

            // ── Network node logo ──
            Canvas {
                id: logo
                Layout.alignment: Qt.AlignHCenter
                width: 56
                height: 48

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    var cx = width / 2
                    var cy = height / 2

                    // Node positions
                    var nodes = [
                        { x: cx,      y: cy - 16 },  // top-center
                        { x: cx - 18, y: cy - 2  },  // left
                        { x: cx + 18, y: cy - 2  },  // right
                        { x: cx - 10, y: cy + 15 },  // bottom-left
                        { x: cx + 10, y: cy + 15 },  // bottom-right
                    ]

                    // Edges
                    var edges = [[0,1],[0,2],[1,3],[2,4],[1,2],[3,4]]
                    ctx.strokeStyle = "#2196c8"
                    ctx.lineWidth = 1.6
                    edges.forEach(function(e) {
                        ctx.beginPath()
                        ctx.moveTo(nodes[e[0]].x, nodes[e[0]].y)
                        ctx.lineTo(nodes[e[1]].x, nodes[e[1]].y)
                        ctx.stroke()
                    })

                    // Nodes
                    nodes.forEach(function(n, i) {
                        ctx.beginPath()
                        ctx.arc(n.x, n.y, 5, 0, Math.PI * 2)
                        ctx.fillStyle   = (i === 0 || i === 2) ? "#4dd9ff" : "#2196c8"
                        ctx.strokeStyle = "#0b1929"
                        ctx.lineWidth   = 1.2
                        ctx.fill()
                        ctx.stroke()
                    })
                }
            }

            Item { Layout.preferredHeight: 14 }

            // ── App name ──
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "NetAnalysis Pro"
                font.family:    "Segoe UI, SF Pro Display, Arial"
                font.pixelSize: 26
                font.weight:    Font.Bold
                color: "#3dc8f5"
            }

            Item { Layout.preferredHeight: 6 }

            // ── Subtitle ──
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "ENTERPRISE NETWORK INTELLIGENCE"
                font.family:      "Segoe UI, Arial"
                font.pixelSize:   10
                font.letterSpacing: 2
                color: "#5a7898"
            }

            Item { Layout.preferredHeight: 32 }

            // ── Error message ──
            Rectangle {
                id: errorBox
                Layout.fillWidth: true
                height: errorText.implicitHeight + 14
                radius: 6
                color: "#2d1018"
                border.color: "#c0392b"
                border.width: 1
                visible: false
                opacity: 0

                Text {
                    id: errorText
                    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: 12 }
                    text: "Invalid username or password. Please try again."
                    color: "#e74c3c"
                    font.pixelSize: 12
                    font.family: "Segoe UI, Arial"
                    wrapMode: Text.WordWrap
                }

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            Item {
                Layout.preferredHeight: errorBox.visible ? 12 : 0
                Behavior on Layout.preferredHeight { NumberAnimation { duration: 200 } }
            }

            // ── USERNAME/ID label ──
            Text {
                text: "USERNAME/ID"
                font.family:      "Segoe UI, Arial"
                font.pixelSize:   11
                font.weight:      Font.DemiBold
                font.letterSpacing: 1
                color: "#b0cce0"
            }

            Item { Layout.preferredHeight: 8 }

            // ── Username field ──
            Rectangle {
                id: userFieldBg
                Layout.fillWidth: true
                height: 50
                radius: 7
                color: "#1a2a42"
                border.color: {
                    if (usernameField.activeFocus) return "#3dc8f5"
                    if (errorBox.visible)         return "#c0392b"
                    return "#253a56"
                }
                border.width: usernameField.activeFocus ? 1.5 : 1
                Behavior on border.color { ColorAnimation { duration: 150 } }

                Row {
                    anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }
                    spacing: 10

                    // Person icon
                    Canvas {
                        width: 18; height: 18
                        anchors.verticalCenter: parent.verticalCenter
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            ctx.strokeStyle = "#5a7898"
                            ctx.lineWidth = 1.6
                            ctx.lineCap = "round"
                            // head
                            ctx.beginPath()
                            ctx.arc(9, 6.5, 3.5, 0, Math.PI * 2)
                            ctx.stroke()
                            // shoulders
                            ctx.beginPath()
                            ctx.moveTo(1.5, 17)
                            ctx.bezierCurveTo(1.5, 11.5, 16.5, 11.5, 16.5, 17)
                            ctx.stroke()
                        }
                    }

                    TextField {
                        id: usernameField
                        width: userFieldBg.width - 58
                        height: 48
                        placeholderText: "Enter your employee ID"
                        placeholderTextColor: "#3d5878"
                        color: "#ddeeff"
                        font.pixelSize: 14
                        font.family: "Segoe UI, Arial"
                        background: Item {}
                        leftPadding: 0
                        verticalAlignment: TextInput.AlignVCenter
                        Keys.onReturnPressed: loginAction()
                        Keys.onEnterPressed:  loginAction()
                    }
                }
            }

            Item { Layout.preferredHeight: 18 }

            // ── PASSWORD label ──
            Text {
                text: "PASSWORD"
                font.family:      "Segoe UI, Arial"
                font.pixelSize:   11
                font.weight:      Font.DemiBold
                font.letterSpacing: 1
                color: "#b0cce0"
            }

            Item { Layout.preferredHeight: 8 }

            // ── Password field ──
            Rectangle {
                id: passFieldBg
                Layout.fillWidth: true
                height: 50
                radius: 7
                color: "#1a2a42"
                border.color: {
                    if (passwordField.activeFocus) return "#3dc8f5"
                    if (errorBox.visible)          return "#c0392b"
                    return "#253a56"
                }
                border.width: passwordField.activeFocus ? 1.5 : 1
                Behavior on border.color { ColorAnimation { duration: 150 } }

                Row {
                    anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }
                    spacing: 10

                    // Lock icon
                    Canvas {
                        width: 18; height: 20
                        anchors.verticalCenter: parent.verticalCenter
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            ctx.strokeStyle = "#5a7898"
                            ctx.lineWidth   = 1.6
                            ctx.lineCap     = "round"
                            ctx.lineJoin    = "round"
                            // shackle
                            ctx.beginPath()
                            ctx.arc(9, 7.5, 4.5, Math.PI, 0)
                            ctx.stroke()
                            // body
                            ctx.beginPath()
                            ctx.roundedRect(2.5, 9.5, 13, 9, 2, 2)
                            ctx.stroke()
                            // keyhole dot
                            ctx.beginPath()
                            ctx.arc(9, 14, 1.8, 0, Math.PI * 2)
                            ctx.stroke()
                        }
                    }

                    TextField {
                        id: passwordField
                        width: passFieldBg.width - 58
                        height: 48
                        echoMode: showPassBtn.showPassword ? TextInput.Normal : TextInput.Password
                        placeholderText: "Enter your password"
                        placeholderTextColor: "#3d5878"
                        color: "#ddeeff"
                        font.pixelSize: 14
                        font.family: "Segoe UI, Arial"
                        background: Item {}
                        leftPadding: 0
                        verticalAlignment: TextInput.AlignVCenter
                        Keys.onReturnPressed: loginAction()
                        Keys.onEnterPressed:  loginAction()
                    }
                }

                // Show/hide password toggle
                Rectangle {
                    id: showPassBtn
                    property bool showPassword: false
                    anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
                    width: 28; height: 28
                    radius: 4
                    color: showPassMouse.containsMouse ? "#253a56" : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }

                    Canvas {
                        anchors.centerIn: parent
                        width: 18; height: 14
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            ctx.strokeStyle = showPassBtn.showPassword ? "#3dc8f5" : "#5a7898"
                            ctx.lineWidth = 1.5
                            ctx.lineCap = "round"
                            // eye outline
                            ctx.beginPath()
                            ctx.moveTo(1, 7)
                            ctx.bezierCurveTo(1, 2, 17, 2, 17, 7)
                            ctx.bezierCurveTo(17, 12, 1, 12, 1, 7)
                            ctx.stroke()
                            // pupil
                            ctx.beginPath()
                            ctx.arc(9, 7, 2.5, 0, Math.PI * 2)
                            ctx.stroke()
                        }
                        // repaint when toggle changes
                        Connections {
                            target: showPassBtn
                            function onShowPasswordChanged() { parent.requestPaint() }
                        }
                    }

                    MouseArea {
                        id: showPassMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: showPassBtn.showPassword = !showPassBtn.showPassword
                    }
                }
            }

            Item { Layout.preferredHeight: 18 }

            // ── Remember Me + Forgot Password ──
            RowLayout {
                Layout.fillWidth: true
                spacing: 0

                Row {
                    spacing: 9

                    Rectangle {
                        id: rememberCheck
                        property bool checked: false
                        width: 17; height: 17
                        radius: 4
                        color:         checked ? "#3dc8f5"  : "#1a2a42"
                        border.color:  checked ? "#3dc8f5"  : "#3a5878"
                        border.width: 1.5
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color       { ColorAnimation { duration: 120 } }
                        Behavior on border.color { ColorAnimation { duration: 120 } }

                        Canvas {
                            anchors.centerIn: parent
                            width: 10; height: 8
                            visible: rememberCheck.checked
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.strokeStyle = "#0b1929"
                                ctx.lineWidth = 1.8
                                ctx.lineCap = "round"
                                ctx.lineJoin = "round"
                                ctx.beginPath()
                                ctx.moveTo(1, 4)
                                ctx.lineTo(4, 7)
                                ctx.lineTo(9, 1)
                                ctx.stroke()
                            }
                            Connections {
                                target: rememberCheck
                                function onCheckedChanged() { parent.requestPaint() }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: rememberCheck.checked = !rememberCheck.checked
                        }
                    }

                    Text {
                        text: "Remember Me"
                        font.pixelSize: 13
                        font.family: "Segoe UI, Arial"
                        color: "#7a9ab8"
                        anchors.verticalCenter: rememberCheck.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: rememberCheck.checked = !rememberCheck.checked
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    id: forgotLink
                    text: "Forgot Password?"
                    font.pixelSize: 13
                    font.family: "Segoe UI, Arial"
                    color: "#2196c8"
                    Behavior on color { ColorAnimation { duration: 100 } }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: forgotLink.color = "#4dd9ff"
                        onExited:  forgotLink.color = "#2196c8"
                        onClicked: forgotDialog.visible = true
                    }
                }
            }

            Item { Layout.preferredHeight: 22 }

            // ── Secure Login button ──
            Rectangle {
                id: loginButton
                Layout.fillWidth: true
                height: 52
                radius: 8

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: loginMouse.containsMouse ? "#00d4ff" : "#00b8e6" }
                    GradientStop { position: 1.0; color: loginMouse.containsMouse ? "#0090cc" : "#0078b0" }
                }

                scale: loginMouse.containsPress ? 0.975 : 1.0
                Behavior on scale { NumberAnimation { duration: 90; easing.type: Easing.OutQuad } }

                // Loading spinner
                Rectangle {
                    id: spinner
                    anchors.centerIn: parent
                    width: 22; height: 22
                    radius: 11
                    color: "transparent"
                    border.color: "#0b1929"
                    border.width: 2.5
                    visible: false
                    opacity: 0.7

                    Rectangle {
                        width: 6; height: 6
                        radius: 3
                        color: "#0b1929"
                        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
                        anchors.topMargin: -1
                    }

                    RotationAnimator on rotation {
                        running: spinner.visible
                        loops: Animation.Infinite
                        from: 0; to: 360
                        duration: 700
                    }
                }

                Row {
                    id: btnContent
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "Secure Login"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        font.family: "Segoe UI, Arial"
                        color: "#0b1929"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: "→"
                        font.pixelSize: 17
                        font.family: "Segoe UI, Arial"
                        color: "#0b1929"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: loginMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: loginAction()
                }
            }

            Item { Layout.preferredHeight: 28 }

            // ── System version ──
            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4
                Text {
                    text: "System Version "
                    font.pixelSize: 12
                    font.family: "Segoe UI, Arial"
                    color: "#4a6a88"
                }
                Text {
                    text: "v4.12.08-STABLE"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    font.family: "Segoe UI, Arial"
                    color: "#2196c8"
                }
            }

            Item { Layout.preferredHeight: 12 }

            // ── Footer links ──
            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: 14

                Repeater {
                    model: ["SECURITY POLICY", "TERMS OF ACCESS"]
                    delegate: Text {
                        property color baseColor: "#2a4a68"
                        text: modelData
                        font.pixelSize: 10
                        font.letterSpacing: 0.8
                        font.family: "Segoe UI, Arial"
                        color: baseColor
                        Behavior on color { ColorAnimation { duration: 100 } }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: parent.color = "#5a8aaa"
                            onExited:  parent.color = parent.baseColor
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: 38 }
        }

        height: mainLayout.implicitHeight + mainLayout.anchors.margins
    }

    // ══════════════════════════════════════════════
    // LOGIN LOGIC
    // ══════════════════════════════════════════════
    function loginAction() {
        if (loginButton.scale < 1) return   // debounce

        var user = usernameField.text.trim()
        var pass = passwordField.text

        if (user === "" || pass === "") {
            showError("Please fill in both username and password.")
            return
        }

        // Show loading state
        btnContent.visible = false
        spinner.visible    = true
        loginButton.opacity = 0.85

        loginTimer.start()
    }

    function showError(msg) {
        errorText.text    = msg
        errorBox.visible  = true
        errorBox.opacity  = 1

        // shake animation
        shakeAnim.start()
    }

    function clearError() {
        errorBox.opacity = 0
        Qt.callLater(function() { errorBox.visible = false })
    }

    // Simulated auth delay
    Timer {
        id: loginTimer
        interval: 1200
        onTriggered: {
            btnContent.visible  = true
            spinner.visible     = false
            loginButton.opacity = 1

            if (usernameField.text.trim() === root.validUser &&
                passwordField.text        === root.validPass) {
                clearError()
                successScreen.visible = true
                successAnim.start()
            } else {
                showError("Invalid username or password. Please try again.")
            }
        }
    }

    // Card shake on error
    SequentialAnimation {
        id: shakeAnim
        NumberAnimation { target: card; property: "anchors.horizontalCenterOffset"; to:  10; duration: 50 }
        NumberAnimation { target: card; property: "anchors.horizontalCenterOffset"; to: -10; duration: 50 }
        NumberAnimation { target: card; property: "anchors.horizontalCenterOffset"; to:   7; duration: 45 }
        NumberAnimation { target: card; property: "anchors.horizontalCenterOffset"; to:  -7; duration: 45 }
        NumberAnimation { target: card; property: "anchors.horizontalCenterOffset"; to:   0; duration: 40 }
    }

    // ══════════════════════════════════════════════
    // SUCCESS SCREEN
    // ══════════════════════════════════════════════
    Rectangle {
        id: successScreen
        anchors.fill: parent
        color: "#0b1929"
        visible: false
        opacity: 0

        Behavior on opacity { NumberAnimation { duration: 400 } }

        SequentialAnimation {
            id: successAnim
            NumberAnimation { target: successScreen; property: "opacity"; to: 1; duration: 400 }
        }

        Column {
            anchors.centerIn: parent
            spacing: 20

            // Green checkmark circle
            Rectangle {
                width: 80; height: 80
                radius: 40
                color: "#152e1a"
                border.color: "#2ecc71"
                border.width: 2
                anchors.horizontalCenter: parent.horizontalCenter

                Canvas {
                    anchors.centerIn: parent
                    width: 36; height: 28
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.strokeStyle = "#2ecc71"
                        ctx.lineWidth = 4
                        ctx.lineCap = "round"
                        ctx.lineJoin = "round"
                        ctx.beginPath()
                        ctx.moveTo(2,  14)
                        ctx.lineTo(13, 25)
                        ctx.lineTo(34,  3)
                        ctx.stroke()
                    }
                }
            }

            Text {
                text: "Welcome back!"
                font.pixelSize: 28
                font.weight: Font.Bold
                font.family: "Segoe UI, Arial"
                color: "#3dc8f5"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Login successful. Redirecting to dashboard…"
                font.pixelSize: 14
                font.family: "Segoe UI, Arial"
                color: "#5a7898"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Progress bar
            Rectangle {
                width: 280; height: 4
                radius: 2
                color: "#1a2a42"
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    id: progressBar
                    width: 0
                    height: parent.height
                    radius: parent.radius
                    color: "#3dc8f5"

                    NumberAnimation on width {
                        id: progressAnim
                        running: successScreen.visible
                        from: 0; to: 280
                        duration: 2000
                        easing.type: Easing.InOutQuad
                        onStopped: root.loginSucceeded()
                    }
                }
            }
        }
    }

    // ══════════════════════════════════════════════
    // FORGOT PASSWORD DIALOG
    // ══════════════════════════════════════════════
    Rectangle {
        id: forgotDialog
        visible: false
        anchors.fill: parent
        color: "#80000000"

        Rectangle {
            width: 360
            anchors.centerIn: parent
            color: "#141f35"
            radius: 12
            border.color: "#1e3557"
            border.width: 1
            // padding: 30

            Column {
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 30 }
                spacing: 16

                Text {
                    text: "Reset Password"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    font.family: "Segoe UI, Arial"
                    color: "#3dc8f5"
                }

                Text {
                    text: "Enter your employee ID and we'll send\nyou a reset link."
                    font.pixelSize: 13
                    font.family: "Segoe UI, Arial"
                    color: "#7a9ab8"
                    lineHeight: 1.4
                }

                Rectangle {
                    width: parent.width; height: 46
                    color: "#1a2a42"
                    radius: 7
                    border.color: resetField.activeFocus ? "#3dc8f5" : "#253a56"
                    border.width: 1
                    TextField {
                        id: resetField
                        anchors { fill: parent; margins: 1 }
                        placeholderText: "Employee ID"
                        placeholderTextColor: "#3d5878"
                        color: "#ddeeff"
                        font.pixelSize: 14
                        font.family: "Segoe UI, Arial"
                        leftPadding: 14
                        background: Item {}
                    }
                }

                Row {
                    spacing: 12
                    anchors.right: parent.right

                    Rectangle {
                        width: 90; height: 38
                        radius: 6
                        color: cancelMouse.containsMouse ? "#253a56" : "#1a2a42"
                        border.color: "#253a56"
                        Behavior on color { ColorAnimation { duration: 100 } }
                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            font.pixelSize: 13
                            font.family: "Segoe UI, Arial"
                            color: "#7a9ab8"
                        }
                        MouseArea {
                            id: cancelMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: forgotDialog.visible = false
                        }
                    }

                    Rectangle {
                        width: 110; height: 38
                        radius: 6
                        color: sendMouse.containsMouse ? "#00c8f0" : "#00b0d8"
                        Behavior on color { ColorAnimation { duration: 100 } }
                        Text {
                            anchors.centerIn: parent
                            text: "Send Link"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            font.family: "Segoe UI, Arial"
                            color: "#0b1929"
                        }
                        MouseArea {
                            id: sendMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: forgotDialog.visible = false
                        }
                    }
                }

                Item { height: 4 }
            }
        }
    }
}
