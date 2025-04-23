import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick

Rectangle {
    id: headerDoc
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: baseInfoCol.implicitHeight
    clip: true

    property string logoSrc
    property string minsNameFr: ""
    property string minsNameEn: ""
    property string imatFr: ""
    property string imatEn: ""
    property string delRegFr: "DELEGATION REGIONALE ADAMAOUA"
    property string delRegEn: "ADAMAWA REGIONAL DELEGATION"
    property string delDepFr: "DELEGATION DEPARTEMENTALE VINA"
    property string delDepEn: "VINA DIVISION DELEGATION"
    property string arrondFr: ""
    property string arrondEn: ""
    property string nameFr: ""
    property string nameEn: ""
    property var headerData: {
        "numBull": "",
        "curMonth": "",
        "empName": "",
        "numCnps": "",
        "numMatInt": "000",
        "numNiu": "",
        "libTypEmp": "",
        "cate": "",
        "anciennette": ""
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 30
        id: baseInfoCol
        spacing: 1

        RowLayout {
            Layout.fillWidth: true
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
                    text: headerDoc.minsNameFr
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
                    text: headerDoc.delRegFr
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
                    text: headerDoc.delDepFr
                    font.bold: true
                    font.pixelSize: 12
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    Layout.topMargin: 3
                    text: headerDoc.arrondFr
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
                    text: headerDoc.imatFr
                    font.bold: true
                    font.pixelSize: 10
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            Image {
                id: logoDep
                source: headerDoc.logoSrc // Chemin vers l'icône
                Layout.preferredWidth: 120
                Layout.preferredHeight: 120
                Layout.alignment: Qt.AlignCenter
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
                    text: headerDoc.minsNameEn
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
                    text: headerDoc.delRegEn
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
                    text: headerDoc.delDepEn
                    font.bold: true
                    font.pixelSize: 12
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    Layout.topMargin: 3
                    text: headerDoc.arrondEn
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
                    text: headerDoc.imatEn
                    font.bold: true
                    font.pixelSize: 10
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Label {
            Layout.topMargin: 5
            text: headerDoc.nameFr
            font.bold: true
            font.pixelSize: 18
            Layout.alignment: Qt.AlignHCenter
        }
        Label {
            text: headerDoc.nameEn
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
        }
        Label {
            text: "B.P : 366 Ngaoundéré Tél : 675 46 06 28/698 07 08 37 email : ladistinction2003@yahoo.com"
            font.bold: true
            font.pixelSize: 14
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            id: myHeaderDivider
            Layout.preferredWidth: (parent.width * 0.95)
            height: 5
            color: "black"
        }

        Label {
            Layout.topMargin: 10
            Component.onCompleted: {
                text = "Bulletin de paye: N° "+headerData.numBull
            }
            font.bold: true
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
        }
        Label {
            Component.onCompleted: {
                text = "Mois de: "+headerData.curMonth
            }
            font.bold: true
            font.pixelSize: 16
        }
        Label {
            Component.onCompleted: {
                text = "Nom du travailleur: "+headerData.empName
            }
            font.bold: true
            font.pixelSize: 16
        }
        Label {
            Component.onCompleted: {
                text = "N° CNPS: "+headerData.numCnps
            }
            font.bold: true
            font.pixelSize: 16
        }
        Label {
            Component.onCompleted: {
                text = "N° matricule interne: "+headerData.numMatInt
            }
            font.bold: true
            font.pixelSize: 16
        }
        Label {
            Component.onCompleted: {
                text = "NIU: "+headerData.numNiu
            }
            font.bold: true
            font.pixelSize: 16
        }
        Label {
            Component.onCompleted: {
                text = "Type d'emploi: "+headerData.libTypEmp
            }
            font.bold: true
            font.pixelSize: 16
        }
        Label {
            Component.onCompleted: {
                text = "Catégorie: "+headerData.cate
            }
            font.bold: true
            font.pixelSize: 16
        }
        Label {
            Component.onCompleted: {
                text = "Anciennetté: "+headerData.anciennette+" an(s)"
            }
            font.bold: true
            font.pixelSize: 16
        }
    }
}
