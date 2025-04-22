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
                implicitHeight: (colLayId2.implicitHeight + colLayId2.spacing)

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
                        text: qsTr("Historique des paiements d'un employé")
                        color: Style.placeholder
                        font.pixelSize: 22
                        font.bold: true
                        Layout.topMargin: 15
                        Layout.alignment: Qt.AlignCenter
                    }

                    // Ligne du choix de l'employe
                    RowLayout {
                        id: empRow
                        Layout.topMargin: 10
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: (colLayId2.width * 0.5)
                        Layout.maximumWidth: (colLayId2.width * 0.7)
                        spacing: 10 // Espacement entre le texte et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Choisissez l'employé:")
                            Layout.preferredWidth: (empRow.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        ComboBox {
                            id: emp
                            Layout.preferredWidth: (empRow.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            model: MyApi.getListEmp()
                            currentIndex: -1 // Aucun élément sélectionné par défaut

                            delegate: ItemDelegate {
                                id: delegateEmp

                                required property var model
                                required property int index

                                width: emp.width
                                contentItem: Text {
                                    text: delegateEmp.model[emp.textRole]
                                    color: Material.foreground
                                    font: emp.font
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                                highlighted: emp.highlightedIndex === index
                            }

                            indicator: Canvas {
                                id: canvas
                                x: emp.width - width - emp.rightPadding
                                y: emp.topPadding + (emp.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"

                                Connections {
                                    target: emp
                                    function onPressedChanged() { canvas.requestPaint(); }
                                }

                                onPaint: {
                                    context.reset();
                                    context.moveTo(0, 0);
                                    context.lineTo(width, 0);
                                    context.lineTo(width / 2, height);
                                    context.closePath();
                                    context.fillStyle = Material.accent;
                                    context.fill();
                                }
                            }

                            contentItem: Text {
                                leftPadding: 15
                                rightPadding: emp.indicator.width + emp.spacing

                                text: emp.displayText
                                font: emp.font
                                color: Style.text
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                implicitWidth: (parent.width * 0.6)
                                implicitHeight: 40
                                color: Material.background
                                border.color: Material.accent
                                border.width: emp.visualFocus ? 2 : 1
                                radius: 10
                            }

                            popup: Popup {
                                y: emp.height - 1
                                width: emp.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: emp.popup.visible ? emp.delegateModel : null
                                    currentIndex: emp.highlightedIndex

                                    ScrollIndicator.vertical: ScrollIndicator { }
                                }

                                background: Rectangle {
                                    color: Material.background
                                    border.color: Material.accent
                                    radius: 10
                                }
                            }
                        }
                    }

                    Button {
                        id: searchEmp
                        text: qsTr("Lancer la recherche")
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: {
                            // TODO
                        }
                        contentItem: RowLayout {
                            spacing: 5
                            Image {
                                source: "qrc:/assets/images/x32/person_search.svg"
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: 20
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    brightness: 1.0
                                    saturation: 1.0
                                    colorization: 1.0
                                    colorizationColor: Material.foreground
                                }
                            }
                            Text {
                                text: searchEmp.text
                                font: searchEmp.font
                                color: Material.foreground
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }
                        }
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            border.color: Material.accent
                            border.width: 1
                            radius: 25
                            color: Style.accent
                        }
                    }

                    // Separateur
                    Rectangle {
                        id: sep1
                        height: 2
                        width: (parent.width * 0.7)
                        Layout.topMargin: 10
                        Layout.alignment: Qt.AlignHCenter
                        color: Style.shadow
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
                            ListElement { idEmp: "1"; libEmp: "Alice" }
                            ListElement { idEmp: "2"; libEmp: "Bob" }
                            // ListElement { idEmp: "3"; libEmp: "Charlie" }
                            // ListElement { idEmp: "4"; libEmp: "Diana" }
                            // ListElement { idEmp: "5"; libEmp: "Edward" }
                            // ListElement { idEmp: "6"; libEmp: "Fiona" }
                            // ListElement { idEmp: "7"; libEmp: "George" }
                            // ListElement { idEmp: "8"; libEmp: "Hannah" }
                            // ListElement { idEmp: "9"; libEmp: "Ian" }
                            // ListElement { idEmp: "10"; libEmp: "Julia" }
                            // ListElement { idEmp: "11"; libEmp: "Kevin" }
                            // ListElement { idEmp: "12"; libEmp: "Laura" }
                            // ListElement { idEmp: "13"; libEmp: "Mark" }
                            // ListElement { idEmp: "14"; libEmp: "Nina" }
                            // ListElement { idEmp: "15"; libEmp: "Oscar" }
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
                                        text: model.idEmp
                                        font.pixelSize: 16
                                        color: Material.foreground
                                    }
                                    Text {
                                        text: "Nom: " + model.libEmp
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
                                    text: qsTr("Bulletin de paie")
                                    onTriggered: console.log("Option 1 sélectionnée")
                                }
                                MenuItem {
                                    text: qsTr("Recapitulatif annuel")
                                    onTriggered: console.log("Option 2 sélectionnée")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
