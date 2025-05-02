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
                implicitHeight: (colLayId.implicitHeight + colLayId.spacing + sep1.height + 10 + saveBtn1.implicitHeight)

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

                    // Ligne du departement
                    RowLayout {
                        id: depRow
                        Layout.topMargin: 20
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Libellé du secteur:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        ComboBox {
                            id: empDep
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            model: MyApi.getListSectNoms()
                            currentIndex: -1 // Aucun élément sélectionné par défaut

                            delegate: ItemDelegate {
                                id: delegateDep

                                required property var model
                                required property int index

                                width: empDep.width
                                contentItem: Text {
                                    text: delegateDep.model[empDep.textRole]
                                    color: Material.foreground
                                    font: empDep.font
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                                highlighted: empDep.highlightedIndex === index
                            }

                            indicator: Canvas {
                                id: canvas
                                x: empDep.width - width - empDep.rightPadding
                                y: empDep.topPadding + (empDep.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"

                                Connections {
                                    target: empDep
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
                                rightPadding: empDep.indicator.width + empDep.spacing

                                text: empDep.displayText
                                font: empDep.font
                                color: Style.text
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                implicitWidth: (parent.width * 0.6)
                                implicitHeight: 40
                                color: Material.background
                                border.color: Material.accent
                                border.width: empDep.visualFocus ? 2 : 1
                                radius: 10
                            }

                            popup: Popup {
                                y: empDep.height - 1
                                width: empDep.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: empDep.popup.visible ? empDep.delegateModel : null
                                    currentIndex: empDep.highlightedIndex

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

                        TextField {
                            id: newEmpName
                            placeholderText: qsTr("Entrez le nom de l'employé")
                            implicitHeight: 40
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignHCenter
                            placeholderTextColor: Style.placeholder
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        TextField {
                            id: numCni
                            placeholderText: qsTr("Entrez le numéro CNI")
                            implicitHeight: 40
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignHCenter
                            placeholderTextColor: Style.placeholder
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        TextField {
                            id: contact
                            placeholderText: qsTr("Entrez le contact")
                            implicitHeight: 40
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignHCenter
                            placeholderTextColor: Style.placeholder
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        // ComboBox pour sélectionner le sexe
                        ComboBox {
                            id: gender
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            model: ["Masculin", "Féminin"]
                            currentIndex: -1 // Aucun élément sélectionné par défaut

                            delegate: ItemDelegate {
                                id: delegateGender

                                required property var model
                                required property int index

                                width: gender.width
                                contentItem: Text {
                                    text: delegateGender.model[gender.textRole]
                                    color: Material.foreground
                                    font: gender.font
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                                highlighted: gender.highlightedIndex === index
                            }

                            indicator: Canvas {
                                id: canvasGender
                                x: gender.width - width - gender.rightPadding
                                y: gender.topPadding + (gender.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"

                                Connections {
                                    target: gender
                                    function onPressedChanged() { canvasGender.requestPaint(); }
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
                                rightPadding: gender.indicator.width + gender.spacing

                                text: gender.displayText
                                font: gender.font
                                color: Style.text
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                implicitWidth: (parent.width * 0.6)
                                implicitHeight: 40
                                color: Material.background
                                border.color: Material.accent
                                border.width: gender.visualFocus ? 2 : 1
                                radius: 10
                            }

                            popup: Popup {
                                y: gender.height - 1
                                width: gender.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: gender.popup.visible ? gender.delegateModel : null
                                    currentIndex: gender.highlightedIndex

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

                        // SpinBox pour sélectionner une année
                        SpinBox {
                            id: year
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            implicitHeight: 40
                            editable: true
                            from: 2000
                            value: new Date().getFullYear()
                            to: 2100
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        TextField {
                            id: cnps
                            placeholderText: qsTr("Entrez le numéro CNPS")
                            implicitHeight: 40
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignHCenter
                            placeholderTextColor: Style.placeholder
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        TextField {
                            id: niu
                            placeholderText: qsTr("Entrez le NIU")
                            implicitHeight: 40
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignHCenter
                            placeholderTextColor: Style.placeholder
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        ComboBox {
                            id: typEmp
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            model: MyApi.getListTypEmpNoms()
                            currentIndex: -1 // Aucun élément sélectionné par défaut

                            delegate: ItemDelegate {
                                id: delegateTypEmp

                                required property var model
                                required property int index

                                width: typEmp.width
                                contentItem: Text {
                                    text: delegateTypEmp.model[typEmp.textRole]
                                    color: Material.foreground
                                    font: typEmp.font
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                                highlighted: typEmp.highlightedIndex === index
                            }

                            indicator: Canvas {
                                id: canvasTypEmp
                                x: typEmp.width - width - typEmp.rightPadding
                                y: typEmp.topPadding + (typEmp.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"

                                Connections {
                                    target: typEmp
                                    function onPressedChanged() { canvasTypEmp.requestPaint(); }
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
                                rightPadding: typEmp.indicator.width + typEmp.spacing

                                text: typEmp.displayText
                                font: typEmp.font
                                color: Style.text
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                implicitWidth: (parent.width * 0.6)
                                implicitHeight: 40
                                color: Material.background
                                border.color: Material.accent
                                border.width: typEmp.visualFocus ? 2 : 1
                                radius: 10
                            }

                            popup: Popup {
                                y: typEmp.height - 1
                                width: typEmp.width
                                // Fixe la hauteur à 10 éléments maximum et active le scrolling
                                implicitHeight: Math.min(typEmp.count, 5) * 50
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: typEmp.popup.visible ? typEmp.delegateModel : null
                                    currentIndex: typEmp.highlightedIndex

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

                        TextField {
                            id: cat
                            placeholderText: qsTr("Entrez la catégorie")
                            implicitHeight: 40
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignHCenter
                            placeholderTextColor: Style.placeholder
                            Layout.preferredWidth: (colLayId.width * 0.6)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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
                        text: qsTr("Informations détaillées")
                        color: Style.placeholder
                        font.pixelSize: 22
                        font.bold: true
                        Layout.topMargin: 15
                        Layout.alignment: Qt.AlignCenter
                    }

                    // Ligne du salaire de base
                    RowLayout {
                        id: salBaseRow
                        Layout.topMargin: 20
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Salaire de base:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        SpinBox {
                            id: salBase
                            implicitHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            editable: true
                            from: 100
                            to: 1000000
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        SpinBox {
                            id: prime
                            implicitHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            editable: true
                            from: 0
                            to: 1000000
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        SpinBox {
                            id: salCot
                            implicitHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            editable: true
                            from: 100
                            to: 1000000
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        SpinBox {
                            id: salTax
                            implicitHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            editable: true
                            from: 100
                            to: 1000000
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        SpinBox {
                            id: irpp
                            implicitHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            editable: true
                            from: 0
                            to: 1000000
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        SpinBox {
                            id: tc
                            implicitHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            editable: true
                            from: 0
                            to: 1000000
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        SpinBox {
                            id: cf
                            implicitHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            editable: true
                            from: 0
                            to: 1000000
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        SpinBox {
                            id: cac
                            implicitHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            editable: true
                            from: 0
                            to: 1000000
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
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

                        SpinBox {
                            id: rav
                            implicitHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            editable: true
                            from: 0
                            to: 1000000
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
                        }
                    }

                    // Ligne du nouveau type d'emploi
                    RowLayout {
                        id: newTypEmpRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Type d'emploi (Opt):")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        TextField {
                            id: newTypEmp
                            placeholderText: qsTr("Entrez le nouveau type")
                            implicitHeight: 40
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignHCenter
                            placeholderTextColor: Style.placeholder
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }

                            // Forcer l'affichage en majuscule
                            onTextChanged: {
                                newTypEmp.text = newTypEmp.text.toUpperCase();
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }

                // Separateur
                Rectangle {
                    id: sep1
                    height: 2
                    width: (parent.width * 0.7)
                    anchors.top: colLayId.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Style.shadow
                }

                Button {
                    id: saveBtn1
                    text: qsTr("Enregistrer")
                    font.bold: true
                    width: (parent.width * 0.2)
                    anchors.top: sep1.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: addEmp()
                    contentItem: RowLayout {
                        spacing: 5

                        Item {
                            Layout.fillWidth: true
                        }

                        Image {
                            source: "qrc:/assets/images/x32/save.svg"
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
        }
    }

    function addEmp() {
        let myObj = {};

        // Logique de verification et de validation
        let checkSect = new Promise((resolve, reject) => {
            if (empDep.currentIndex < 0) {
                reject("Veuillez selectionner un secteur valide!")
            }
            else {
                myObj["sect"] = empDep.currentText
                resolve("ok")
            }
        });

        let checkName = new Promise((resolve, reject) => {
            if (newEmpName.length < 1) {
                reject("Veuillez saisir un nom valide!")
            }
            else {
                myObj["empName"] = newEmpName.text
                resolve("ok")
            }
        });

        let checkCni = new Promise((resolve, reject) => {
            if (numCni.length < 1) {
                reject("Veuillez saisir un numéro de CNI valide!")
            }
            else {
                myObj["numCni"] = numCni.text
                resolve("ok")
            }
        });

        let checkContact = new Promise((resolve, reject) => {
            if (contact.length < 1) {
                reject("Veuillez saisir un contact valide!")
            }
            else {
                myObj["contact"] = contact.text
                resolve("ok")
            }
        });

        // 0 pour masculin et 1 pour feminin
        let checkGender = new Promise((resolve, reject) => {
            if (gender.currentIndex < 0) {
                reject("Veuillez selectionner le sexe!")
            }
            else {
                myObj["sex"] = gender.currentIndex
                resolve("ok")
            }
        });

        let checkCnps = new Promise((resolve, reject) => {
            if (cnps.length < 1) {
                reject("Veuillez saisir un numéro de CNPS valide!")
            }
            else {
                myObj["numCnps"] = cnps.text
                resolve("ok")
            }
        });

        let checkNiu = new Promise((resolve, reject) => {
            if (niu.length < 1) {
                reject("Veuillez saisir un NIU valide!")
            }
            else {
                myObj["niu"] = niu.text
                resolve("ok")
            }
        });

        let checkTypEmp = new Promise((resolve, reject) => {
            if (typEmp.currentIndex < 0) {
                if (newTypEmp.length < 1) {
                    reject("Veuillez selectionner un type d'emploi valide OU fournir un nouveau type (en bas dernière ligne colonne droite)!")
                }
                else {
                    myObj["newTypEmp"] = newTypEmp.text
                    resolve("ok")
                }
            }
            else {
                if (newTypEmp.length < 1) {
                    myObj["typEmp"] = typEmp.currentText
                    myObj["newTypEmp"] = ""
                    resolve("ok")
                }
                else {
                    myObj["newTypEmp"] = newTypEmp.text
                    resolve("ok")
                }
            }
        });

        let checkCat = new Promise((resolve, reject) => {
            if (cat.length < 1) {
                reject("Veuillez saisir une catégorie valide!")
            }
            else {
                myObj["cat"] = cat.text
                resolve("ok")
            }
        });

        let finalPromise = Promise.all([
            checkSect,
            checkName,
            checkCni,
            checkContact,
            checkGender,
            checkCnps,
            checkNiu,
            checkTypEmp,
            checkCat
        ])
        .then((values) => {
            // informations numeriques
            myObj["anArriv"] = year.value.toString()
            myObj["salBase"] = salBase.value
            myObj["prime"] = prime.value
            myObj["salCot"] = salCot.value
            myObj["salTax"] = salTax.value
            myObj["irpp"] = irpp.value
            myObj["tc"] = tc.value
            myObj["cf"] = cf.value
            myObj["cac"] = cac.value
            myObj["rav"] = rav.value

            if (MyApi.submitNewEmp(JSON.stringify(myObj))) {
                year.value = new Date().getFullYear()
                empDep.currentIndex = -1
                newEmpName.text = ""
                numCni.text = ""
                contact.text = ""
                gender.currentIndex = -1
                cnps.text = ""
                niu.text = ""
                typEmp.currentIndex = -1
                cat.text = ""
                salBase.value = salBase.from
                salCot.value = salCot.from
                salTax.value = salTax.from
                newTypEmp.text = ""
                prime.value = irpp.value = tc.value = cf.value = cac.value = rav.value = 0
            }
        })
        .catch((reason) => {
            MyApi.sendWarning(reason)
        })
    }
}
