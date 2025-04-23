import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick
import QtQuick.Dialogs

Window {
    id: bullMat
    title: qsTr("Bulletin CPBI")
    // Dimension standard pour un format A4
    // Avec 1920 x 1080 de resolution et environ 22 pouce
    // Pour un resultat de sensiblement 96 DPI
    width: 794
    height: 1122
    maximumWidth: 794
    maximumHeight: 1122

    property int theId: 0
    property int docType: 0
    property var theData: {
    }

    Shortcut {
        sequence: StandardKey.Print
        context: Qt.ApplicationShortcut
        onActivated: {
            let stat = printableContainer.grabToImage(function (result) {
                MyApi.startPreviewDoc(result.image);
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

            HeaderDoc{
                id: headerDoc
                logoSrc: "qrc:/assets/images/logos/CPBI.png"
                minsNameFr: "MINISTERE DES ENSEIGNEMENTS SECONDAIRES"
                minsNameEn: "MINISTRY OF SECONDARY EDUCATION"
                imatFr: "N° d’Immatriculation: 2JJ2GSBD100191109"
                imatEn: "Immatricultion number : 2JJ2GSBD100191109"
                nameFr: "COLLEGE POLYVALENT BILINGUE IYA"
                nameEn: "IYA’S COMPREHENSIVE BILINGUAL HIGH SCHOOL"
                headerData: {
                    "numBull": theData.numBull,
                    "curMonth": theData.curMonth,
                    "empName": theData.empName,
                    "numCnps": theData.numCnps,
                    "numMatInt": theData.numMatInt,
                    "numNiu": theData.numNiu,
                    "libTypEmp": theData.libTypEmp,
                    "cate": theData.cate,
                    "anciennette": theData.anciennette
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
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: "Rémunération mensuelle"
                font.bold: true
                font.pixelSize: 16
            }

            Rectangle {
                id: details
                anchors.top: subTitle.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 30
                width: (titles.width + values.width + 10)
                height: titles.height

                Rectangle {
                    id: titles
                    width: (colTitles.implicitWidth + 10)
                    height: (colTitles.implicitHeight + 10)

                    ColumnLayout {
                        id: colTitles
                        anchors.fill: titles
                        anchors.margins: 10
                        spacing: 5

                        Label {
                            text: "Salaire de base :.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: "Primes :"
                            font.pixelSize: 16
                            font.bold: true
                        }
                        Label {
                            text: " - Transport :.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: "Salaire cotisable :.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: "Salaire taxable :.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: "Salaire brute :.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: "Retenues Impots :"
                            font.pixelSize: 16
                            font.bold: true
                        }
                        Label {
                            text: " - IRPP :.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: " - Taxe Communale :.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: " - Crédit foncier:.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: " - Cac :.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: " - Rav :.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: "Total Impots:"
                            font.bold: true
                            font.pixelSize: 16
                        }
                        Label {
                            text: "Retenues CNPS (4,2%):"
                            font.bold: true
                            font.pixelSize: 16
                        }
                        Label {
                            text: " - Cotisation :.............................."
                            font.pixelSize: 16
                        }
                        Label {
                            text: "Total Retenues:"
                            font.bold: true
                            font.pixelSize: 16
                        }
                        Label {
                            text: "Net à Payer:"
                            font.bold: true
                            font.pixelSize: 16
                        }
                    }
                }

                Rectangle {
                    id: values
                    anchors.left: titles.right
                    anchors.leftMargin: 75
                    width: 210
                    height: (colValues.implicitHeight + 10)
                    border.width: 2
                    border.color: "black"

                    ColumnLayout {
                        id: colValues
                        anchors.fill: values
                        anchors.margins: 10
                        spacing: 5

                        Label {
                            Component.onCompleted: {
                                text = theData.salBase
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            text: ""
                            font.pixelSize: 16
                            font.bold: true
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.prime
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.salCot
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.salTax
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.salBrute
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            text: ""
                            font.pixelSize: 16
                            font.bold: true
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.irpp
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.tc
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.cf
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.cac
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.rav
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.totalImpot
                            }
                            font.bold: true
                            font.pixelSize: 16
                        }
                        Label {
                            text: ""
                            font.bold: true
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.cotCnps
                            }
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.totalRet
                            }
                            font.bold: true
                            font.pixelSize: 16
                        }
                        Label {
                            Component.onCompleted: {
                                text = theData.nap
                            }
                            font.bold: true
                            font.pixelSize: 16
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

            Label {
                id: signEmp
                anchors.top: location.bottom
                anchors.topMargin: 20
                anchors.right: parent.right
                anchors.rightMargin: 50
                text: "Signature de l'employé(e):"
                font.pixelSize: 16
                font.bold: true
            }
        }
    }
}
