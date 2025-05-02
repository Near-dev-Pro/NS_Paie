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
                implicitHeight: (colLayId.implicitHeight + colLayId.spacing)

                // Colonne pour infos de base
                ColumnLayout {
                    id: colLayId
                    width: (parent.width * 0.4)
                    anchors.top: parent.top
                    anchors.leftMargin: 10
                    anchors.left: parent.left
                    spacing: 10

                    Label {
                        id: titreCoreData
                        text: qsTr("Informations de base")
                        color: Style.placeholder
                        font.pixelSize: 22
                        font.bold: true
                        Layout.topMargin: 15
                        Layout.alignment: Qt.AlignCenter
                    }

                    // Ligne du choix de l'employe
                    RowLayout {
                        id: empRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le ComboBox

                        ComboBox {
                            id: emp
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            model: MyApi.getListEmp()
                            currentIndex: -1 // Aucun élément sélectionné par défaut

                            delegate: ItemDelegate {
                                id: delegateEmp

                                required property var model
                                required property int index

                                width: emp.width
                                contentItem: Text {
                                    text: emp.model.data(emp.model.index(index, 0))
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
                                // Fixe la hauteur à 10 éléments maximum et active le scrolling
                                implicitHeight: Math.min(emp.count, 5) * 50
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

                        Button {
                            id: saveBtn1
                            text: qsTr("Charger")
                            font.bold: true
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            onClicked: showEmp()
                            contentItem: RowLayout {
                                spacing: 5

                                Item {
                                    Layout.fillWidth: true
                                }

                                Image {
                                    source: "qrc:/assets/images/x32/show_emp.svg"
                                    Layout.preferredWidth: 20
                                    Layout.preferredHeight: 20
                                    layer.enabled: true
                                    layer.effect: MultiEffect {
                                        brightness: 1.0
                                        colorization: 1.0
                                        colorizationColor: Material.foreground
                                    }
                                }
                                Text {
                                    text: saveBtn1.text
                                    font: saveBtn1.font
                                    color: Material.foreground
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                }

                                Item {
                                    Layout.fillWidth: true
                                }
                            }
                            background: Rectangle {
                                implicitWidth: 100
                                implicitHeight: 40
                                border.color: Material.accent
                                border.width: 1
                                radius: 25
                                color: Material.accent
                            }
                        }
                    }

                    // Ligne du nom
                    RowLayout {
                        id: nameRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Nom complèt:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forName
                            text: qsTr("")
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne du numCni
                    RowLayout {
                        id: numCniRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Numéro CNI:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }


                        Label {
                            id: forCni
                            text: qsTr("")
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne du contact
                    RowLayout {
                        id: contactRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Contact:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forContact
                            text: qsTr("")
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne de sexe
                    RowLayout {
                        id: genderRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte indicatif et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Sexe:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forGender
                            text: qsTr("")
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne de l'annee d'arrivee
                    RowLayout {
                        id: yearRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte indicatif et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Année d'arrivée:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forAnArriv
                            text: qsTr("")
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne du numero de la CNPS
                    RowLayout {
                        id: numCnpsRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Numéro CNPS:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forCnps
                            text: qsTr("")
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne du NIU
                    RowLayout {
                        id: numNiuRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("NIU:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forNiu
                            text: qsTr("")
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne du type d'emploi
                    RowLayout {
                        id: typEmpRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Type d'emploi:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forTypEmp
                            text: qsTr("")
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne de la categorie
                    RowLayout {
                        id: catRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Catégorie:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forCate
                            text: qsTr("")
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }

                ColumnLayout {
                    id: subColLayId01
                    width: parent.width * 0.5
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    spacing: 10

                    Label {
                        id: titreEmpPerm
                        text: qsTr("Détails de rémunération")
                        color: Style.placeholder
                        font.pixelSize: 22
                        font.bold: true
                        Layout.topMargin: 15
                        Layout.alignment: Qt.AlignCenter
                    }

                    // Ligne du salaire de base
                    RowLayout {
                        id: salBaseRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Salaire de base:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forSalBase
                            text: qsTr("")
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne de la prime
                    RowLayout {
                        id: primeRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Prime:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forPrime
                            text: qsTr("")
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne du salaire cotisable
                    RowLayout {
                        id: salCotRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Salaire cotisable:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forSalCot
                            text: qsTr("")
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne du salaire taxable
                    RowLayout {
                        id: salTaxRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Salaire taxable:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forSalTax
                            text: qsTr("")
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne de l'irpp
                    RowLayout {
                        id: irppRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Montant IRPP:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forIrpp
                            text: qsTr("")
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne de la taxe communale
                    RowLayout {
                        id: tcRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Montant TC:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forTc
                            text: qsTr("")
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne du credit foncier
                    RowLayout {
                        id: cfRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Montant CF:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forCf
                            text: qsTr("")
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne du cac (?)
                    RowLayout {
                        id: cacRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Montant CAC:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forCac
                            text: qsTr("")
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    // Ligne de la redevence audio-visuelle
                    RowLayout {
                        id: ravRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Montant RAV:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        Label {
                            id: forRav
                            text: qsTr("")
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            font.pixelSize: 20
                            font.bold: true
                            color: Material.foreground
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }

    function showEmp() {
        if (emp.currentIndex < 0) {
            MyApi.sendWarning("Veuillez selectionner un employé à afficher!")
        }
        else {
            new Promise((resolve, reject) => {
                let fullData = MyApi.getOneEmp(emp.currentText)
                if (fullData !== null) {
                    resolve(fullData)
                }
                else {
                    reject("Les données sont nulles!")
                }
            })
            .then ((theData) => {
                forName.text = theData.data(theData.index(0, 0))
                forCni.text = theData.data(theData.index(0, 4)).toString()
                forContact.text = theData.data(theData.index(0, 5)).toString()
                forGender.text = (theData.data(theData.index(0, 3)) === 0)? "Masculin": "Feminin"
                forAnArriv.text = theData.data(theData.index(0, 19)).toString()
                forCnps.text = theData.data(theData.index(0, 7)).toString()
                forNiu.text = theData.data(theData.index(0, 8)).toString()
                forTypEmp.text = theData.data(theData.index(0, 27))
                forCate.text = theData.data(theData.index(0, 10))
                forSalBase.text = theData.data(theData.index(0, 11)).toString()
                forPrime.text = theData.data(theData.index(0, 25)).toString()
                forSalCot.text = theData.data(theData.index(0, 12)).toString()
                forSalTax.text = theData.data(theData.index(0, 13)).toString()
                forIrpp.text = theData.data(theData.index(0, 14)).toString()
                forTc.text = theData.data(theData.index(0, 15)).toString()
                forCf.text = theData.data(theData.index(0, 16)).toString()
                forCac.text = theData.data(theData.index(0, 17)).toString()
                forRav.text = theData.data(theData.index(0, 18)).toString()
            })
            .catch ((reason) => {
                MyApi.sendWarning(reason)
            })
        }
    }
}
