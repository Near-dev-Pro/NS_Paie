import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick
import QtQuick.Dialogs

Window {
    id: recapCBD
    title: qsTr("Récapitulatif mensuel CSD")
    // Dimension standard pour un format A4
    // Avec 1920 x 1080 de resolution et environ 22 pouce
    // Pour un resultat de sensiblement 96 DPI
    width: 1122
    height: 794
    maximumWidth: 1122
    maximumHeight: 794

    property string logoSrc: "qrc:/assets/images/logos/CSD.png"
    property string minsNameFr: "MINISTERE DE LA SANTE PUBLIQUE"
    property string minsNameEn: "MINISTRY OF PUBLIC HEALTH"
    property string nameFr: "CENTRE DE SANTE LA DISTINCTION"
    property string nameEn: "DISTINCTION HEALTH CENTRE"
    property string delRegFr: "Délégation régionale de la santé de l’Adamaoua"
    property string delRegEn: "Adamawa Reginal Delegation of heath"
    property string delDepFr: "District de santé de Ngaoundéré Urbain"
    property string delDepEn: "Ngaoundere Urbain Heath district"
    property var theData: {
    }

    Shortcut {
        sequence: StandardKey.Print
        context: Qt.ApplicationShortcut
        onActivated: {
            let stat = printableContainer.grabToImage(function (result) {
                MyApi.startPreviewDoc(result.image, "RECAP MENSUEL CSD");
            });
        }
    }

    ScrollView {
        id: printableContainer
        anchors.fill: parent
        contentHeight: printableContent.height

        Rectangle {
            id: printableContent
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 10

            Rectangle {
                id: headerDoc
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: baseInfoCol.implicitHeight
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    id: baseInfoCol
                    spacing: 1

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        uniformCellSizes: true

                        ColumnLayout {
                            spacing: 0

                            Label {
                                text: "REPUBLIQUE DU CAMEROUN"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: "****************"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                Layout.topMargin: 3
                                Component.onCompleted: {
                                    text = minsNameFr
                                }
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: "****************"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                Layout.topMargin: 3
                                Component.onCompleted: {
                                    text= delRegFr
                                }
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: "****************"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                Layout.topMargin: 3
                                Component.onCompleted: {
                                    text= delDepFr
                                }
                                font.bold: true
                                font.pixelSize: 12
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: "****************"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        Image {
                            id: logoDep
                            Component.onCompleted: {
                                source= logoSrc // Chemin vers l'icône
                            }
                            Layout.preferredWidth: 120
                            Layout.preferredHeight: 120
                            Layout.alignment: Qt.AlignHCenter
                        }

                        ColumnLayout {
                            spacing: 0

                            Label {
                                text: "REPUBIC OF CAMEROON"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: "****************"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                Layout.topMargin: 3
                                Component.onCompleted: {
                                    text= minsNameEn
                                }
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: "****************"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                Layout.topMargin: 3
                                Component.onCompleted: {
                                    text= delRegEn
                                }
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: "****************"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                Layout.topMargin: 3
                                Component.onCompleted: {
                                    text= delDepEn
                                }
                                font.bold: true
                                font.pixelSize: 12
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Label {
                                text: "****************"
                                font.bold: true
                                font.pixelSize: 10
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    Label {
                        Layout.topMargin: 5
                        Component.onCompleted: {
                            text= nameFr
                        }
                        font.bold: true
                        font.pixelSize: 18
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Label {
                        Component.onCompleted: {
                            text= nameEn
                        }
                        font.pixelSize: 16
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Label {
                        text: "B.P : 366 Ngaoundéré Tél : 675 46 06 28/698 07 08 37 email : ladistinction2003@yahoo.com"
                        font.bold: true
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            Rectangle {
                id: myDivider
                anchors.top: headerDoc.bottom
                anchors.left: parent.left
                anchors.topMargin: 10
                width: parent.width
                height: 2
                color: "black"
            }

            Label {
                id: subTitle
                anchors.top: myDivider.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                text: "RECAPITULATIF MENSUEL"
                font.bold: true
                font.pixelSize: 20
            }

            Rectangle {
                id: details
                anchors.top: subTitle.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 30
                width: parent.width
                implicitHeight: listContentColumn.implicitHeight

                // Ligne du choix du table du contenu
                ColumnLayout {
                    id: listContentColumn
                    anchors.fill: details
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
                            color: "black"
                            implicitHeight: 40

                            Label {
                                anchors.centerIn: parent
                                color: "white"
                                font.bold: true
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
                            return partialHistTV.width / 9;
                        }
                        Component.onCompleted: {
                            model = MyApi.getHisOfDepRecapMens(3, theData.theYearMonth)
                        }

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
                                width: (partialHistTV.width / 9)
                                elide: Text.ElideRight
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    ToolTip {
                                        text: model.display
                                        visible: parent.containsMouse
                                    }
                                }
                            }
                        }
                    }

                    TableView {
                        id: partialHistTV2
                        Layout.topMargin: 20
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        columnSpacing: 1
                        rowSpacing: 1
                        clip: true

                        // Calcul de la hauteur basée sur le contenu
                        implicitHeight: 30 * (partialHistTV2.model ? partialHistTV2.rows : 0)

                        visible: (partialHistTV.model !== null && partialHistTV.rows > 0)
                        boundsBehavior: Flickable.StopAtBounds
                        columnWidthProvider: function (column) {
                            return partialHistTV2.width / 9;
                        }
                        Component.onCompleted: {
                            model = MyApi.getHisOfDepRecapMensTot(3, theData.theYearMonth)
                        }

                        delegate: ItemDelegate {
                            implicitHeight: 40
                            clip: true
                            background: Rectangle {
                                color: "black"
                            }

                            Text {
                                text: model.display
                                color: "white"
                                font.bold: true
                                anchors.fill: parent
                                anchors.leftMargin: 5
                                wrapMode: TextField.WordWrap
                                width: (partialHistTV2.width / 9)
                                elide: Text.ElideRight
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    ToolTip {
                                        text: model.display
                                        visible: parent.containsMouse
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Label {
                id: location
                anchors.top: details.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16
                Component.onCompleted: {
                    text = `Fait à Ngaoundéré, le : ${new Date().toISOString().split("T")[0]}`
                }
            }

            Label {
                id: visaEco
                anchors.top: location.bottom
                anchors.left: parent.left
                anchors.topMargin: 20
                anchors.leftMargin: 50
                text: "Visa du DAF:"
                font.pixelSize: 16
                font.bold: true
            }
        }
    }
}
