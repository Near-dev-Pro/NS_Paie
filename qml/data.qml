import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Effects

Page {
    id: currentItemId
    property string currentPage: "qrc:/qml/global_hist.qml"

    // Barre d'Outils
    header: ToolBar {
        Layout.fillWidth: true
        Material.background: Style.secondary

        RowLayout {
            anchors.fill: parent
            spacing: 10

            ToolButton {
                id: toolHistGlo
                property string targetIcon: "qrc:/assets/images/x32/global.svg"
                property string targetPage: "qrc:/qml/global_hist.qml"

                background: Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    height: 40
                    radius: Material.ExtraLargeScale
                    color: childStackView.currentItem === childStackView.get(0, StackView.DontLoad) ? Style.background : "transparent"
                }

                onClicked: {
                    currentItemId.currentPage = toolHistGlo.targetPage
                    childStackView.pop(null)
                }

                contentItem: RowLayout {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter

                    Image {
                        source: toolHistGlo.targetIcon
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
                        text: qsTr("Historique global annuel")
                        color: Style.text
                        font.bold: true
                        font.pixelSize: 18
                    }
                }
            }

            ToolSeparator{}

            Item {
                Layout.fillWidth: true
            }
        }
    }

    // pour une navigation en stack
    StackView {
        id: childStackView
        anchors.fill: parent
        initialItem: currentItemId.currentPage

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
}
