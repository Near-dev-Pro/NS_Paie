import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick
import QtQuick.Effects

ApplicationWindow {
    id: mainAppScreen
    minimumWidth: 1000
    minimumHeight: 600
    visible: true
    title: qsTr("NS Paie")
    property string currentPage: "qrc:/qml/home.qml"
    property string myTheme: "Light"

    Component.onCompleted: updateTheme(mainAppScreen.myTheme)

    function updateTheme (curState) {
        Style.curTheme = curState
        Material.foreground = Style.text
        Material.background = Style.background
        Material.primary = Style.primary
        Material.accent = Style.accent
    }

    Shortcut {
        sequence: "Ctrl+Q"
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Barre de Navigation
        ToolBar {
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent // Ajouté pour que RowLayout remplisse tout l'espace du ToolBar
                spacing: 10

                // Bouton Menu pour ouvrir le Drawer
                ToolButton {
                    icon.name: "menu"
                    icon.source: "qrc:/assets/images/x32/drawer_menu.svg"
                    icon.color: Material.background
                    onClicked: drawer.open()
                }

                // Nom de l'application
                Label {
                    text: qsTr("Gestion de la paie")
                    font.pixelSize: 22
                    font.bold: true
                    Layout.alignment: Qt.AlignVCenter
                    color: Material.background
                }

                // Item pour pousser les éléments à droite
                Item {
                    Layout.fillWidth: true
                }

                ToolButton {
                    id: toolButtonTheme
                    icon.name: "theme"
                    icon.source: "qrc:/assets/images/x32/theme.svg"
                    icon.color: Material.background
                    onClicked: {
                        contextMenu.open() // Ouvrir le menu contextuel au clic
                    }
                }

                // Définition du menu contextuel
                Menu {
                    id: contextMenu
                    x: toolButtonTheme.x + toolButtonTheme.width // Position horizontale relative au ToolButton
                    y: toolButtonTheme.y + toolButtonTheme.height // Position verticale relative au ToolButton

                    MenuItem {
                        text: qsTr("Thème sombre")
                        onTriggered: {
                            mainAppScreen.myTheme = "Dark"
                            updateTheme(mainAppScreen.myTheme)
                        }
                    }
                    MenuItem {
                        text: qsTr("Thème clair")
                        onTriggered: {
                            mainAppScreen.myTheme = "Light"
                            updateTheme(mainAppScreen.myTheme)
                        }
                    }
                }
            }
        }

        // pour une navigation en stack
        StackView {
            id: stackview
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: mainAppScreen.currentPage

            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 200
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 200
                }
            }
            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 200
                }
            }
            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 200
                }
            }
        }

        // Pied de Page
        Footer {
            Layout.fillWidth: true
        }
    }

    // Drawer pour le menu latéral
    Drawer {
        id: drawer
        width: 300
        height: parent.height  // Remplit toute la hauteur de la fenêtre
        Material.background: Material.accent

        // Conteneur global du drawer
        ColumnLayout {
            spacing: 2

            // Zone du logo et du nom avec fond primaire
            Rectangle {
                id: logoAndNameRect
                color: Material.accent
                Layout.preferredWidth: drawer.width
                Layout.preferredHeight: 100  // Définir la hauteur explicite
                ColumnLayout {
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter

                    // Logo de l'application
                    Image {
                        source: "qrc:/assets/images/logos/logo.svg"  // Chemin vers le logo
                        Layout.preferredWidth: 128
                        Layout.preferredHeight: 64
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // Nom de l'application
                    Label {
                        text: qsTr("NS Paie")
                        font.pixelSize: 20
                        Layout.alignment: Qt.AlignHCenter
                        color: Style.background
                    }
                }
            }

            // Zone des ToolButtons avec fond blanc
            Rectangle {
                Layout.preferredWidth: drawer.width
                Layout.preferredHeight: (drawer.availableHeight - logoAndNameRect.height)
                radius: 25
                color: Style.background

                ColumnLayout {
                    spacing: 10
                    anchors.left: parent.left
                    anchors.right: parent.right

                    // Icônes de navigation avec labels dans le drawer
                    ToolButton {
                        id: toolHome
                        Layout.fillWidth: true
                        Layout.topMargin: 10

                        background: Rectangle {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            height: 40
                            radius: Material.FullScale
                            color: stackview.currentItem === stackview.get(0, StackView.DontLoad) ? Style.secondary : "transparent"
                        }

                        property string targetIcon: "qrc:/assets/images/x32/home.svg"
                        property string targetPage: "qrc:/qml/home.qml"

                        onClicked: {
                            mainAppScreen.currentPage = toolHome.targetPage
                            stackview.pop(null)
                            drawer.close()
                        }
                        contentItem: RowLayout {
                            spacing: 10
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20

                            Image {
                                id: toolHomeIcon
                                source: toolHome.targetIcon
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    brightness: 0.0
                                    colorization: 1.0
                                    colorizationColor: Material.primary
                                }
                            }

                            Label {
                                text: qsTr("Accueil")
                                color: Material.foreground
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                        }
                    }

                    ToolButton {
                        id: toolEmp
                        Layout.fillWidth: true

                        background: Rectangle {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            height: 40
                            radius: Material.FullScale
                            color: stackview.currentItem === toolEmp.currentItemStkView ? Style.secondary : "transparent"
                        }

                        property string targetIcon: "qrc:/assets/images/x32/employe.svg"
                        property string targetPage: "qrc:/qml/employe.qml"
                        property Item currentItemStkView

                        onClicked: {
                            mainAppScreen.currentPage = toolEmp.targetPage
                            toolEmp.currentItemStkView = stackview.push(mainAppScreen.currentPage)
                            drawer.close()
                        }
                        contentItem: RowLayout {
                            spacing: 10
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20

                            Image {
                                source: toolEmp.targetIcon
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    brightness: 0.0
                                    colorization: 1.0
                                    colorizationColor: Material.primary
                                }
                            }
                            Label {
                                text: qsTr("Employés")
                                color: Material.foreground
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                        }
                    }

                    ToolButton {
                        id: toolData
                        Layout.fillWidth: true

                        background: Rectangle {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            height: 40
                            radius: Material.FullScale
                            color: stackview.currentItem === toolData.currentItemStkView ? Style.secondary : "transparent"
                        }

                        property string targetIcon: "qrc:/assets/images/x32/data.svg"
                        property string targetPage: "qrc:/qml/data.qml"
                        property Item currentItemStkView

                        onClicked: {
                            mainAppScreen.currentPage = toolData.targetPage
                            toolData.currentItemStkView = stackview.push(mainAppScreen.currentPage)
                            drawer.close()
                        }
                        contentItem: RowLayout {
                            spacing: 10
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20

                            Image {
                                source: toolData.targetIcon
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    brightness: 0.0
                                    colorization: 1.0
                                    colorizationColor: Material.primary
                                }
                            }
                            Label {
                                text: qsTr("Divers")
                                color: Material.foreground
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }

    // Dialogue pour les erreurs
    Dialog {
        id: errorDialog
        title: qsTr("A votre attention (érreur)!")
        x: (mainAppScreen.width - width) / 2
        y: 100
        contentItem: ColumnLayout {
            Image {
                source: "qrc:/assets/images/x64/error.svg"
                Layout.preferredWidth: 64
                Layout.preferredHeight: 64
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                id: errorMessageText
                text: ""
                Layout.alignment: Qt.AlignHCenter
                wrapMode: Text.WordWrap
                color: Material.foreground
            }
            Button {
                id: dlg1Btn
                text: qsTr("Lu!")
                font.bold: true
                onClicked: errorDialog.close()
                Layout.alignment: Qt.AlignHCenter

                contentItem: Text {
                    text: dlg1Btn.text
                    font: dlg1Btn.font
                    color: Material.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    border.color: Material.accent
                    border.width: 1
                    radius: 15
                    color: Material.accent
                }
            }
        }
    }

    // Dialogue pour les avertissements
    Dialog {
        id: warningDialog
        title: qsTr("A votre attention (avertissement)!")
        x: (mainAppScreen.width - width) / 2
        y: 100
        contentItem: ColumnLayout {
            Image {
                source: "qrc:/assets/images/x64/warning.svg"
                Layout.preferredWidth: 64
                Layout.preferredHeight: 64
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                id: warningMessageText
                text: ""
                Layout.alignment: Qt.AlignHCenter
                wrapMode: Text.WordWrap
                color: Material.foreground
            }
            Button {
                id: dlg2Btn
                text: qsTr("Lu!")
                font.bold: true
                onClicked: warningDialog.close()
                Layout.alignment: Qt.AlignHCenter

                contentItem: Text {
                    text: dlg2Btn.text
                    font: dlg2Btn.font
                    color: Material.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    border.color: Material.accent
                    border.width: 1
                    radius: 15
                    color: Material.accent
                }
            }
        }
    }

    // Dialogue pour les evenements success
    Dialog {
        id: successDialog
        title: qsTr("A votre attention (succès)!")
        x: (mainAppScreen.width - width) / 2
        y: 100
        contentItem: ColumnLayout {
            Image {
                source: "qrc:/assets/images/x64/success.svg"
                Layout.preferredWidth: 64
                Layout.preferredHeight: 64
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                id: successMessageText
                text: ""
                Layout.alignment: Qt.AlignHCenter
                wrapMode: Text.WordWrap
                color: Material.foreground
            }
            Button {
                id: dlg3Btn
                text: qsTr("Lu!")
                font.bold: true
                onClicked: successDialog.close()
                Layout.alignment: Qt.AlignHCenter

                contentItem: Text {
                    text: dlg3Btn.text
                    font: dlg3Btn.font
                    color: Material.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    border.color: Material.accent
                    border.width: 1
                    radius: 15
                    color: Material.accent
                }
            }
        }
    }

    // Connexions
    Connections {
        target: MyApi
        function onErrorOccurred(errorMsg) {
            errorMessageText.text = errorMsg
            errorDialog.open();
        }
        function onWarningOccurred(warningMsg) {
            warningMessageText.text = warningMsg
            warningDialog.open();
        }
        function onSuccessOperation(successMsg) {
            successMessageText.text = successMsg
            successDialog.open();
        }
    }
}
