import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick
import QtQuick.Dialogs

Window {
    id: recapAnEmp
    title: qsTr("Récapitulatif annuel d'un emplé")
    // Dimension standard pour un format A4
    // Avec 1920 x 1080 de resolution et environ 22 pouce
    // Pour un resultat de sensiblement 96 DPI
    width: 794
    height: 1122
    maximumWidth: 794
    maximumHeight: 1122

    property var theData: {
    }

    Shortcut {
        sequence: StandardKey.Print
        context: Qt.ApplicationShortcut
        onActivated: {
            let stat = printableContainer.grabToImage(function (result) {
                MyApi.startPreviewDoc(result.image, "RECAP ANNUEL");
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
                    anchors.leftMargin: 30
                    id: baseInfoCol
                    spacing: 1

                    Label {
                        Layout.topMargin: 10
                        text: "BULLETIN RECAPITULATIF ANNUEL"
                        font.bold: true
                        font.pixelSize: 22
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Label {
                        Layout.topMargin: 20
                        Component.onCompleted: {
                            text = "Nom du travailleur: "+theData.empName
                        }
                        font.bold: true
                        font.pixelSize: 16
                    }
                    Label {
                        Component.onCompleted: {
                            text = "N° CNPS: "+theData.numCnps
                        }
                        font.bold: true
                        font.pixelSize: 16
                    }
                    Label {
                        Component.onCompleted: {
                            text = "N° matricule interne: "+theData.numMatInt
                        }
                        font.bold: true
                        font.pixelSize: 16
                    }
                    Label {
                        Component.onCompleted: {
                            text = "NIU: "+theData.numNiu
                        }
                        font.bold: true
                        font.pixelSize: 16
                    }
                    Label {
                        Component.onCompleted: {
                            text = "Type d'emploi: "+theData.libTypEmp
                        }
                        font.bold: true
                        font.pixelSize: 16
                    }
                    Label {
                        Component.onCompleted: {
                            text = "Catégorie: "+theData.cate
                        }
                        font.bold: true
                        font.pixelSize: 16
                    }
                    Label {
                        Component.onCompleted: {
                            text = "Anciennetté: "+theData.anciennette+" an(s)"
                        }
                        font.bold: true
                        font.pixelSize: 16
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
                id: subTitle1
                anchors.top: myDivider.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                text: "GAINS ANNUELS"
                font.bold: true
                font.pixelSize: 20
            }

            Rectangle {
                id: details
                anchors.top: subTitle1.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                width: (titles.width + values.width + 10)
                height: titles.height

                Rectangle {
                    id: titles
                    width: (colTitles.implicitWidth + 10)
                    height: (colTitles.implicitHeight + 10)

                    Label {
                        id: titleLib
                        anchors.left: parent.left
                        text: "LIBELLES"
                        font.bold: true
                        font.pixelSize: 18
                    }

                    ColumnLayout {
                        id: colTitles
                        anchors.top: titleLib.bottom
                        anchors.left: titles.left
                        anchors.right: titles.right
                        anchors.bottom: titles.bottom
                        anchors.margins: 10
                        spacing: 5

                        Label {
                            text: " - SALAIRE DE BASE"
                            font.pixelSize: 16
                        }
                        Label {
                            text: " - PRIMES"
                            font.pixelSize: 16
                        }
                    }
                }

                Rectangle {
                    id: values
                    anchors.left: titles.right
                    anchors.leftMargin: 150
                    width: 210
                    height: (colValues.implicitHeight + 10)

                    Label {
                        id: titleLib2
                        anchors.left: parent.left
                        text: "MONTANTS"
                        font.bold: true
                        font.pixelSize: 18
                    }

                    ColumnLayout {
                        id: colValues
                        anchors.top: titleLib2.bottom
                        anchors.left: values.left
                        anchors.right: values.right
                        anchors.bottom: values.bottom
                        anchors.margins: 10
                        spacing: 5

                        Label {
                            Component.onCompleted: {
                                text = theData.totBase
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.totPri
                            }
                            font.pixelSize: 16
                        }
                    }
                }
            }

            Label {
                id: totGains
                anchors.top: details.bottom
                anchors.topMargin: 70
                anchors.horizontalCenter: parent.horizontalCenter
                Component.onCompleted: {
                    text = "TOTAL DE GAINS ANNUELS: " + Number(theData.totBase+ theData.totPri) + "FCFA"
                }
                font.pixelSize: 16
            }

            Label {
                id: subTitle2
                anchors.top: totGains.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                text: "RETENUES ANNUELS"
                font.bold: true
                font.pixelSize: 20
            }

            Rectangle {
                id: details2
                anchors.top: subTitle2.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                width: (titles2.width + values2.width + 10)
                height: titles2.height

                Rectangle {
                    id: titles2
                    width: (colTitles2.implicitWidth + 10)
                    height: (colTitles2.implicitHeight + 10)

                    Label {
                        id: titleLib3
                        anchors.left: parent.left
                        text: "LIBELLES"
                        font.bold: true
                        font.pixelSize: 18
                    }

                    ColumnLayout {
                        id: colTitles2
                        anchors.top: titleLib3.bottom
                        anchors.left: titles2.left
                        anchors.right: titles2.right
                        anchors.bottom: titles2.bottom
                        anchors.margins: 10
                        spacing: 5

                        Label {
                            text: " - RETENUES IMPOTS"
                            font.pixelSize: 16
                        }
                        Label {
                            text: " - COTISATIONS CNPS"
                            font.pixelSize: 16
                        }
                    }
                }

                Rectangle {
                    id: values2
                    anchors.left: titles2.right
                    anchors.leftMargin: 150
                    width: 210
                    height: (colValues2.implicitHeight + 10)

                    Label {
                        id: titleLib4
                        anchors.left: parent.left
                        text: "MONTANTS"
                        font.bold: true
                        font.pixelSize: 18
                    }

                    ColumnLayout {
                        id: colValues2
                        anchors.top: titleLib4.bottom
                        anchors.left: values2.left
                        anchors.right: values2.right
                        anchors.bottom: values2.bottom
                        anchors.margins: 10
                        spacing: 5

                        Label {
                            Component.onCompleted: {
                                text = theData.totImp
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.totCnps
                            }
                            font.pixelSize: 16
                        }
                    }
                }
            }

            Label {
                id: totRet
                anchors.top: details2.bottom
                anchors.topMargin: 70
                anchors.horizontalCenter: parent.horizontalCenter
                Component.onCompleted: {
                    text = "TOTAL DE RETENUES ANNUELS: " + Number(theData.totImp+ theData.totCnps) + "FCFA"
                }
                font.pixelSize: 16
            }

            Label {
                id: location
                anchors.top: totRet.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16
                font.bold: true
                Component.onCompleted: {
                    text = `Fait à Ngaoundéré, le : ${new Date().toISOString().split("T")[0]}`
                }
            }
        }
    }
}
