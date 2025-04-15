import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Page {
    id: currentItemId
    property string currentPage: "qrc:/qml/add_emp.qml"

    // Barre d'Outils
    header: ToolBar {
        Layout.fillWidth: true
        Material.background: Style.secondColorLight

        RowLayout {
            anchors.fill: parent
            spacing: 10

            ToolButton {
                id: toolNewEmp
                property string targetIcon: "qrc:/assets/images/x32/add_emp.svg"
                property string targetPage: "qrc:/qml/add_emp.qml"

                background: Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    height: 40
                    radius: Material.ExtraLargeScale
                    color: childStackView.currentItem === childStackView.get(0, StackView.DontLoad) ? Style.backgroundLight : "transparent"
                }

                onClicked: {
                    currentItemId.currentPage = toolNewEmp.targetPage
                    childStackView.pop(null)
                }

                contentItem: RowLayout {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter

                    IconImage {
                        source: toolNewEmp.targetIcon
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        color: Material.primary
                    }
                    Label {
                        text: qsTr("Ajout")
                        color: Material.foreground
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
                    color: childStackView.currentItem === toolModifEmp.currentItemStkView ? Style.backgroundLight : "transparent"
                }

                onClicked: {
                    currentItemId.currentPage = toolModifEmp.targetPage
                    toolModifEmp.currentItemStkView = childStackView.push(currentItemId.currentPage)
                }

                contentItem: RowLayout {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter

                    IconImage {
                        source: toolModifEmp.targetIcon
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        color: Material.primary
                    }
                    Label {
                        text: qsTr("Modifications")
                        color: Material.foreground
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
        Layout.fillWidth: true
        Layout.fillHeight: true
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
