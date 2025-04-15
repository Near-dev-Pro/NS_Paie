import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Page {
    id: currentItemId
    property string currentPage: "qrc:/qml/new_paie.qml"

    // Barre d'Outils
    header: ToolBar {
        Layout.fillWidth: true
        Material.background: Style.secondColorLight

        RowLayout {
            anchors.fill: parent
            spacing: 10

            ToolButton {
                id: toolNewPaie
                property string targetIcon: "qrc:/assets/images/x32/new_paie.svg"
                property string targetPage: "qrc:/qml/new_paie.qml"

                background: Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    height: 40
                    radius: Material.ExtraLargeScale
                    color: childStackView.currentItem === childStackView.get(0, StackView.DontLoad) ? Style.backgroundLight : "transparent"
                }

                onClicked: {
                    currentItemId.currentPage = toolNewPaie.targetPage
                    childStackView.pop(null)
                }

                contentItem: RowLayout {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter

                    IconImage {
                        source: toolNewPaie.targetIcon
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        color: Material.primary
                    }
                    Label {
                        text: qsTr("Nouvelle paie")
                        color: Material.foreground
                        font.bold: true
                        font.pixelSize: 18
                    }
                }
            }

            ToolSeparator{}

            ToolButton {
                id: toolHistPaie
                property string targetIcon: "qrc:/assets/images/x32/hist_paie.svg"
                property string targetPage: "qrc:/qml/hist_paie.qml"
                property Item currentItemStkView

                background: Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    height: 40
                    radius: Material.ExtraLargeScale
                    color: childStackView.currentItem === toolHistPaie.currentItemStkView ? Style.backgroundLight : "transparent"
                }

                onClicked: {
                    currentItemId.currentPage = toolHistPaie.targetPage
                    toolHistPaie.currentItemStkView = childStackView.push(currentItemId.currentPage)
                }

                contentItem: RowLayout {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter

                    IconImage {
                        source: toolHistPaie.targetIcon
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        color: Material.primary
                    }
                    Label {
                        text: qsTr("Historique des paies")
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
