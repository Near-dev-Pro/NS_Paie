import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Effects

Page {
    id: currentItemId
    property string currentPage: "qrc:/qml/new_emp.qml"

    // Barre d'Outils
    header: ToolBar {
        Layout.fillWidth: true
        Material.background: Style.secondary

        RowLayout {
            anchors.fill: parent
            spacing: 10

            ToolButton {
                id: toolNewEmp
                property string targetIcon: "qrc:/assets/images/x32/add_emp.svg"
                property string targetPage: "qrc:/qml/new_emp.qml"

                background: Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    height: 40
                    radius: Material.ExtraLargeScale
                    color: childStackView.currentItem === childStackView.get(0, StackView.DontLoad) ? Style.background : "transparent"
                }

                onClicked: {
                    currentItemId.currentPage = toolNewEmp.targetPage
                    childStackView.pop(null)
                }

                contentItem: RowLayout {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter

                    Image {
                        source: toolNewEmp.targetIcon
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
                        text: qsTr("Ajouter")
                        color: Style.text
                        font.bold: true
                        font.pixelSize: 18
                    }
                }
            }

            ToolSeparator{}

            ToolButton {
                id: toolModifEmp
                property string targetIcon: "qrc:/assets/images/x32/modif_emp.svg"
                property string targetPage: "qrc:/qml/modif_emp.qml"
                property Item currentItemStkView

                background: Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    height: 40
                    radius: Material.ExtraLargeScale
                    color: childStackView.currentItem === toolModifEmp.currentItemStkView ? Style.background : "transparent"
                }

                onClicked: {
                    currentItemId.currentPage = toolModifEmp.targetPage
                    toolModifEmp.currentItemStkView = childStackView.push(currentItemId.currentPage)
                }

                contentItem: RowLayout {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter

                    Image {
                        source: toolModifEmp.targetIcon
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
                        text: qsTr("Modifier")
                        color: Style.text
                        font.bold: true
                        font.pixelSize: 18
                    }
                }
            }

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
