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
                        visible: (listView.model === null || listView.model.count === 0)
                    }

                    ListView {
                        id: listView
                        Layout.preferredHeight: childrenRect.height
                        Layout.preferredWidth: colLayId2.width
                        visible: (listView.model !== null && listView.model.count > 0)
                        model: ListModel {
                            // ListElement { idYear: "1"; libYear: "2025" }
                            // ListElement { idYear: "2"; libYear: "2024" }
                            // ListElement { idYear: "3"; libYear: "2023" }
                            // ListElement { idYear: "4"; libYear: "2022" }
                            // ListElement { idYear: "5"; libYear: "2021" }
                            // ListElement { idYear: "6"; libYear: "2020" }
                            // ListElement { idYear: "7"; libYear: "2019" }
                            // ListElement { idYear: "8"; libYear: "2018" }
                            // ListElement { idYear: "9"; libYear: "2017" }
                            // ListElement { idYear: "10"; libYear: "2016" }
                            // ListElement { idYear: "11"; libYear: "2015" }
                            // ListElement { idYear: "12"; libYear: "2014" }
                            // ListElement { idYear: "13"; libYear: "2013" }
                            // ListElement { idYear: "14"; libYear: "2012" }
                            // ListElement { idYear: "15"; libYear: "2011" }
                        }
                        delegate: Item {
                            width: listView.width
                            height: 60
                            Rectangle {
                                id: card
                                anchors.fill: parent
                                radius: 10
                                color: Material.background
                                border.color: Style.shadow
                                border.width: 1
                                anchors.margins: 10
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    shadowEnabled: true
                                    shadowBlur: 0.3
                                    shadowColor: Style.shadow
                                    autoPaddingEnabled: false
                                    paddingRect: Qt.rect(20, 20, 40, 30)
                                }
                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 20
                                    anchors.leftMargin: 15
                                    anchors.rightMargin: 15
                                    Text {
                                        text: model.idYear
                                        font.pixelSize: 16
                                        color: Material.foreground
                                    }
                                    Text {
                                        text: "Année: " + model.libYear
                                        font.pixelSize: 18
                                        color: Material.foreground
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }
                                    Image {
                                        id: moreActions
                                        source: "qrc:/assets/images/x32/more.svg"
                                        Layout.alignment: Qt.AlignRight
                                        Layout.preferredWidth: 20
                                        Layout.preferredHeight: 20
                                        layer.enabled: true
                                        layer.effect: MultiEffect {
                                            brightness: 0.0
                                            colorization: 1.0
                                            colorizationColor: Material.foreground
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                contextMenu.open();
                                            }
                                        }
                                    }
                                }
                            }
                            Menu {
                                id: contextMenu
                                x: moreActions.x + moreActions.width // Positionne le menu à droite de l'icône
                                y: moreActions.y // Aligne le menu verticalement avec l'icône
                                MenuItem {
                                    text: qsTr("Imprimer")
                                    onTriggered: console.log("Option 1 sélectionnée")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
