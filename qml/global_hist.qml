import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects

Page {
    id: currentChildView

    contentChildren: Rectangle {
        anchors.fill: parent
        gradient: Style.gradiantBg

        ScrollView {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                implicitHeight: colLayId2.implicitHeight

                ColumnLayout {
                    id: colLayId2
                    width: parent.width * 0.7
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10

                    // Contenu exemple (modifiable)
                    Label {
                        id: titreHist
                        text: qsTr("Historique global des paiements")
                        color: Style.placeholder
                        font.pixelSize: 22
                        font.bold: true
                        Layout.topMargin: 15
                        Layout.alignment: Qt.AlignCenter
                    }

                    Label {
                        id: emptyList
                        text: qsTr("Aucun contenu...")
                        color: Style.placeholder
                        font.pixelSize: 20
                        Layout.alignment: Qt.AlignCenter
                        visible: (partialHistTV.model === null || partialHistTV.rows === 0)
                    }

                    // Ligne du choix du table du contenu
                    ColumnLayout {
                        id: listContentColumn
                        Layout.preferredWidth: colLayId2.width
                        Layout.maximumWidth: colLayId2.width
                        spacing: 0

                        HorizontalHeaderView {
                            id: horizontalHeader
                            Layout.topMargin: 20
                            Layout.leftMargin: 10
                            Layout.rightMargin: 10
                            Layout.fillWidth: true
                            syncView: partialHistTV
                            clip: true
                            visible: (partialHistTV.model !== null && partialHistTV.rows > 0)
                            delegate: Rectangle {
                                color: Material.accent
                                implicitHeight: 40

                                Label {
                                    anchors.centerIn: parent
                                    color: Material.foreground
                                    Component.onCompleted: {
                                        text = display.toUpperCase()
                                    }
                                }
                            }
                        }

                        TableView {
                            id: partialHistTV
                            Layout.fillWidth: true
                            Layout.leftMargin: 10
                            Layout.rightMargin: 10
                            columnSpacing: 1
                            rowSpacing: 1
                            clip: true

                            // Calcul de la hauteur basée sur le contenu
                            implicitHeight: 30 * (partialHistTV.model ? partialHistTV.rows : 0)

                            visible: (partialHistTV.model !== null && partialHistTV.rows > 0)
                            boundsBehavior: Flickable.StopAtBounds
                            columnWidthProvider: function (column) {
                                return partialHistTV.width / 10;
                            }
                            model: MyApi.getFullHis(0, (new Date().getFullYear()))

                            delegate: ItemDelegate {
                                implicitHeight: 30
                                clip: true
                                background: Rectangle {
                                    color: Material.background
                                }

                                Text {
                                    text: model.display
                                    color: Material.foreground
                                    anchors.fill: parent
                                    anchors.leftMargin: 5
                                    wrapMode: TextField.WordWrap
                                    width: (partialHistTV.width / 10)
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
