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
                implicitHeight: (subColLayId01.implicitHeight + subColLayId01.spacing + sep1.height + 10 + saveBtn1.implicitHeight)

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

                        // Texte indicatif
                        Label {
                            text: qsTr("Choisissez l'employé:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

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

                    // Ligne du type d'emploi
                    RowLayout {
                        id: typEmpRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Type d'emploi:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        ComboBox {
                            id: typEmp
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
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
                                implicitHeight: contentItem.implicitHeight
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

                        SpinBox {
                            id: salBase
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

                    // Ligne du salaire de brute
                    RowLayout {
                        id: salBruteRow
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le champ de saisie

                        // Texte indicatif
                        Label {
                            text: qsTr("Salaire brute:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        SpinBox {
                            id: salBrute
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

                    Item {
                        Layout.fillHeight: true
                    }
                }

                // Separateur
                Rectangle {
                    id: sep1
                    height: 2
                    width: (parent.width * 0.7)
                    anchors.top: subColLayId01.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Style.shadow
                }

                Button {
                    id: saveBtn1
                    text: qsTr("Modifier et Conserver")
                    font.bold: true
                    width: (parent.width * 0.2)
                    anchors.top: sep1.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: updateEmp()
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

    function updateEmp() {
        let myObj = {};

        if (emp.currentIndex < 0) {
            MyApi.sendWarning("Veuillez selectionner l'employé(e) cible!")
        }
        else {
            myObj["currentName"] = emp.currentValue

            let checkName = new Promise((resolve, reject) => {
                if (newEmpName.length > 0) {
                    myObj["newName"] = newEmpName.text

                    if (!MyApi.updateEmpNom(JSON.stringify(myObj))) {
                        reject("Le nom n'a pas été mis à jour!")
                    }
                    else {
                        // Important: Il faut mettre a jour le nom...
                        myObj["currentName"] = newEmpName.text
                        newEmpName.text = "" // Puis on peut effacer
                        resolve("ok")
                    }
                }
            });

            let checkCni = new Promise((resolve, reject) => {
                if (numCni.length > 0) {
                    myObj["newNumCni"] = numCni.text

                    if (!MyApi.updateEmpNumCni(JSON.stringify(myObj))) {
                        reject("Le numéro de la CNI n'a pas été mis à jour!")
                    }
                    else {
                        numCni.text = ""
                        resolve("ok")
                    }
                }
            });

            let checkContact = new Promise((resolve, reject) => {
                if (contact.length > 0) {
                    myObj["newContact"] = contact.text

                    if (!MyApi.updateEmpContact(JSON.stringify(myObj))) {
                        reject("Le contact n'a pas été mis à jour!")
                    }
                    else {
                        contact.text = ""
                        resolve("ok")
                    }
                }
            });

            let checkTypEmp = new Promise((resolve, reject) => {
                if (typEmp.currentIndex >= 0) {
                    myObj["newTypEmp"] = typEmp.currentValue

                    if (!MyApi.updateEmpTypEmp(JSON.stringify(myObj))) {
                        reject("Le type d'emploi n'a pas été mis à jour!")
                    }
                    else {
                        typEmp.currentIndex = -1
                        resolve("ok")
                    }
                }
            });

            let checkSalBase = new Promise((resolve, reject) => {
                if (salBase.value > 0) {
                    myObj["newSalBase"] = salBase.value

                    if (!MyApi.updateEmpSalBase(JSON.stringify(myObj))) {
                        reject("Le salaire de base n'a pas été mis à jour!")
                    }
                    else {
                        salBase.value = salBase.from
                        resolve("ok")
                    }
                }
            });

            let checkPrime = new Promise((resolve, reject) => {
                if (prime.value > 0) {
                    myObj["newPri"] = prime.value

                    if (!MyApi.updateEmpPrime(JSON.stringify(myObj))) {
                        reject("La prime n'a pas été mise à jour!")
                    }
                    else {
                        prime.value = prime.from
                        resolve("ok")
                    }
                }
            });

            let checkSalCot = new Promise((resolve, reject) => {
                if (salCot.value > 0) {
                    myObj["newSalCot"] = salCot.value

                    if (!MyApi.updateEmpSalCot(JSON.stringify(myObj))) {
                        reject("Le salaire cotisable n'a pas été mis à jour!")
                    }
                    else {
                        salCot.value = salCot.from
                        resolve("ok")
                    }
                }
            });

            let checkSalTax = new Promise((resolve, reject) => {
                if (salTax.value > 0) {
                    myObj["newSalTax"] = salTax.value

                    if (!MyApi.updateEmpSalTax(JSON.stringify(myObj))) {
                        reject("Le salaire taxable n'a pas été mis à jour!")
                    }
                    else {
                        salTax.value = salTax.from
                        resolve("ok")
                    }
                }
            });

            let checkSalBrute = new Promise((resolve, reject) => {
                if (salBrute.value > 0) {
                    myObj["newSalBrute"] = salBrute.value

                    if (!MyApi.updateEmpSalBrute(JSON.stringify(myObj))) {
                        reject("Le salaire brute n'a pas été mis à jour!")
                    }
                    else {
                        salBrute.value = salBrute.from
                        resolve("ok")
                    }
                }
            });

            let checkIrpp = new Promise((resolve, reject) => {
                if (irpp.value > 0) {
                    myObj["newIrpp"] = irpp.value

                    if (!MyApi.updateEmpIrpp(JSON.stringify(myObj))) {
                        reject("L'Irpp n'a pas été mis à jour!")
                    }
                    else {
                        irpp.value = irpp.from
                        resolve("ok")
                    }
                }
            });

            let checkTc = new Promise((resolve, reject) => {
                if (tc.value > 0) {
                    myObj["newTc"] = tc.value

                    if (!MyApi.updateEmpTc(JSON.stringify(myObj))) {
                        reject("La T.C n'a pas été mise à jour!")
                    }
                    else {
                        tc.value = tc.from
                        resolve("ok")
                    }
                }
            });

            let checkCf = new Promise((resolve, reject) => {
                if (cf.value > 0) {
                    myObj["newCf"] = cf.value

                    if (!MyApi.updateEmpCf(JSON.stringify(myObj))) {
                        reject("Le C.F n'a pas été mis à jour!")
                    }
                    else {
                        cf.value = cf.from
                        resolve("ok")
                    }
                }
            });

            let checkCac = new Promise((resolve, reject) => {
                if (cac.value > 0) {
                    myObj["newCac"] = cac.value

                    if (!MyApi.updateEmpCac(JSON.stringify(myObj))) {
                        reject("Le C.A.C n'a pas été mis à jour!")
                    }
                    else {
                        cac.value = cac.from
                        resolve("ok")
                    }
                }
            });

            let checkRav = new Promise((resolve, reject) => {
                if (rav.value > 0) {
                    myObj["newRav"] = rav.value

                    if (!MyApi.updateEmpRav(JSON.stringify(myObj))) {
                        reject("La R.A.V n'a pas été mise à jour!")
                    }
                    else {
                        rav.value = rav.from
                        resolve("ok")
                    }
                }
            });

            let finalPromise = Promise.all([
                checkName,
                checkCni,
                checkContact,
                checkTypEmp,
                checkSalBase,
                checkPrime,
                checkSalCot,
                checkSalTax,
                checkSalBrute,
                checkIrpp,
                checkTc,
                checkCf,
                checkCac,
                checkRav
            ])
            .then((values) => {
            })
            .catch((reason) => {
                MyApi.sendWarning(reason)
            })
        }
    }
}
