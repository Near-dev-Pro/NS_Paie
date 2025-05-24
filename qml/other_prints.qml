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
                        text: qsTr("Impressions annuelles")
                        color: Style.placeholder
                        font.pixelSize: 22
                        font.bold: true
                        Layout.topMargin: 15
                        Layout.alignment: Qt.AlignCenter
                    }

                    // Ligne de l'annee
                    RowLayout {
                        id: yearRow
                        Layout.topMargin: 20
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte indicatif et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Année:")
                            Layout.preferredWidth: (colLayId.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        // SpinBox pour sélectionner une année
                        SpinBox {
                            id: yearFilter
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

                    Button {
                        id: searchBtn1
                        text: qsTr("Générer")
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: printRecapAnDep()
                        contentItem: RowLayout {
                            spacing: 5
                            Image {
                                source: "qrc:/assets/images/x32/render.svg"
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
                                text: searchBtn1.text
                                font: searchBtn1.font
                                color: Material.foreground
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }
                        }
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            border.color: Style.secondary
                            border.width: 1
                            radius: 25
                            color: Style.secondary
                        }
                    }

                    // Separateur
                    Rectangle {
                        id: sep1
                        height: 2
                        Layout.topMargin: 10
                        Layout.preferredWidth: (colLayId.width * 0.6)
                        Layout.alignment: Qt.AlignHCenter
                        color: Style.shadow
                    }

                    // Ligne du choix de l'employe
                    RowLayout {
                        id: empRow
                        Layout.topMargin: 20
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
                                    text: emp.model.data(emp.model.index(index, 0))
                                    color: Material.foreground
                                    font: emp.font
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                                highlighted: emp.highlightedIndex === index
                            }

                            indicator: Canvas {
                                id: canvas2
                                x: emp.width - width - emp.rightPadding
                                y: emp.topPadding + (emp.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"

                                Connections {
                                    target: emp
                                    function onPressedChanged() { canvas2.requestPaint(); }
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
                    }

                    Button {
                        id: searchBtn2
                        text: qsTr("Générer")
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: printRecapAnEmp()
                        contentItem: RowLayout {
                            spacing: 5
                            Image {
                                source: "qrc:/assets/images/x32/render.svg"
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
                                text: searchBtn2.text
                                font: searchBtn2.font
                                color: Material.foreground
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }
                        }
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            border.color: Style.secondary
                            border.width: 1
                            radius: 25
                            color: Style.secondary
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }

                ColumnLayout {
                    id: subColLayId01
                    width: (parent.width * 0.4)
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    spacing: 10

                    Label {
                        id: titreEmpPerm
                        text: qsTr("Impressions mensuelles")
                        color: Style.placeholder
                        font.pixelSize: 22
                        font.bold: true
                        Layout.topMargin: 15
                        Layout.alignment: Qt.AlignCenter
                    }

                    // Ligne de l'annee
                    RowLayout {
                        id: yearRow2
                        Layout.topMargin: 20
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte indicatif et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Année:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        // SpinBox pour sélectionner une année
                        SpinBox {
                            id: yearFilter2
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
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

                    // Ligne du mois
                    RowLayout {
                        id: monthRow
                        Layout.topMargin: 20
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte indicatif et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Mois:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        // SpinBox pour sélectionner un mois
                        SpinBox {
                            id: monthFilter
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            implicitHeight: 40
                            editable: true
                            from: 1
                            value: (new Date().getMonth() + 1)
                            to: 12
                            background: Rectangle {
                                color: Material.background
                                radius: 10
                                border.color: Material.accent
                                border.width: 1
                            }
                        }
                    }

                    // Ligne du departement
                    RowLayout {
                        id: depRow2
                        Layout.topMargin: 20
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Libellé du secteur:")
                            Layout.preferredWidth: (subColLayId01.width * 0.4)
                            font.pixelSize: 16
                            color: Material.foreground
                        }

                        ComboBox {
                            id: empDep2
                            Layout.preferredWidth: (subColLayId01.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            model: MyApi.getListSectNoms()
                            currentIndex: -1 // Aucun élément sélectionné par défaut

                            delegate: ItemDelegate {
                                id: delegateDep2

                                required property var model
                                required property int index

                                width: empDep2.width
                                contentItem: Text {
                                    text: delegateDep2.model[empDep2.textRole]
                                    color: Material.foreground
                                    font: empDep2.font
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                                highlighted: empDep2.highlightedIndex === index
                            }

                            indicator: Canvas {
                                id: canvas3
                                x: empDep2.width - width - empDep2.rightPadding
                                y: empDep2.topPadding + (empDep2.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"

                                Connections {
                                    target: empDep2
                                    function onPressedChanged() { canvas3.requestPaint(); }
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
                                rightPadding: empDep2.indicator.width + empDep2.spacing

                                text: empDep2.displayText
                                font: empDep2.font
                                color: Style.text
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                implicitWidth: (parent.width * 0.6)
                                implicitHeight: 40
                                color: Material.background
                                border.color: Material.accent
                                border.width: empDep2.visualFocus ? 2 : 1
                                radius: 10
                            }

                            popup: Popup {
                                y: empDep2.height - 1
                                width: empDep2.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: empDep2.popup.visible ? empDep2.delegateModel : null
                                    currentIndex: empDep2.highlightedIndex

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
                        id: searchBtn4
                        text: qsTr("Générer")
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: printRecapMensDep()
                        contentItem: RowLayout {
                            spacing: 5
                            Image {
                                source: "qrc:/assets/images/x32/render.svg"
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
                                text: searchBtn4.text
                                font: searchBtn4.font
                                color: Material.foreground
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }
                        }
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            border.color: Style.secondary
                            border.width: 1
                            radius: 25
                            color: Style.secondary
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }

    function printRecapMensDep() {
        const d = new Date();
        let yearMonthVal = `${yearFilter2.value}-${monthFilter.value.toString().padStart(2, "0")}`
        let currentDep = empDep2.currentIndex
        new Promise((resolve, reject) => {
            if (empDep2.currentIndex < 0) {
                reject("Veuillez choisir le secteur!")
            }
            else {
                switch (currentDep) {
                    case 0:
                    resolve("CBD")
                    break;
                    case 1:
                    resolve("CPBI")
                    break;
                    case 2:
                    resolve("CSD")
                    break;
                    case 3:
                    resolve("GSBD")
                    break;
                    case 4:
                    resolve("RLD")
                    break;

                    default:
                    reject("Secteur inconnu...")
                    break;
                }
            }
        })
        .then((fullEmpData) => {
            let fileName = `recapMois${fullEmpData}.qml`
            let component = Qt.createComponent(fileName);

            if (component.status === Component.Ready) {
                let RecapWin = component.createObject(
                    parent,
                    {
                        theData: {
                            theYearMonth: yearMonthVal
                        }
                    }
                );
                RecapWin.show();
            }
            else {
                MyApi.sendWarning("Veuillez patienter: Ouverture...");
            }
        })
        .catch((reason) => {
            MyApi.sendWarning(reason)
        })
    }

    function printRecapAnDep() {
        const d = new Date();
        let yearVal = yearFilter.value
        let currentDep = empDep.currentIndex
        new Promise((resolve, reject) => {
            if (empDep.currentIndex < 0) {
                reject("Veuillez choisir le secteur!")
            }
            else {
                switch (currentDep) {
                    case 0:
                    resolve("CBD")
                    break;
                    case 1:
                    resolve("CPBI")
                    break;
                    case 2:
                    resolve("CSD")
                    break;
                    case 3:
                    resolve("GSBD")
                    break;
                    case 4:
                    resolve("RLD")
                    break;

                    default:
                    reject("Secteur inconnu...")
                    break;
                }
            }
        })
        .then((fullEmpData) => {
            let fileName = `recapAn${fullEmpData}.qml`
            let component = Qt.createComponent(fileName);

            if (component.status === Component.Ready) {
                let RecapWin = component.createObject(
                    parent,
                    {
                        theData: {
                            theYear: yearVal
                        }
                    }
                );
                RecapWin.show();
            }
            else {
                MyApi.sendWarning("Veuillez patienter: Ouverture...");
            }
        })
        .catch((reason) => {
            MyApi.sendWarning(reason)
        })
    }

    function printRecapAnEmp() {
        const d = new Date();
        let empNameVal = emp.currentValue
        let yearVal = yearFilter.value
        new Promise((resolve, reject) => {
            if (emp.currentIndex < 0) {
                reject("Veuillez choisir l'employé!")
            }
            else {
                let fullEmpData = MyApi.getOneEmpForRecap(empNameVal)
                resolve(fullEmpData)
            }
        })
        .then((fullEmpData) => {
            let histData = MyApi.getHisOfEmpRecapAn(empNameVal, yearVal)
            let component = Qt.createComponent(`recapAnEmp.qml`);
            let salBase = Number(histData[0].totBase)
            let montPri = Number(histData[0].totPri)
            let montImp = Number(histData[0].totImp)
            let montCnps = Number(histData[0].totCnps)
            let monAnciennette = Number(d.getFullYear() - fullEmpData[0].anArriv - 1)

            if (component.status === Component.Ready) {
                let RecapWin = component.createObject(
                    parent,
                    {
                        theData: {
                            empName: fullEmpData[0].libEmp,
                            numCnps: fullEmpData[0].numCnps,
                            numMatInt: Number(fullEmpData[0].idEmp).toString().padStart(3, "0"),
                            numNiu: fullEmpData[0].niu,
                            libTypEmp: fullEmpData[0].libTypEmp,
                            cate: fullEmpData[0].cate,
                            anciennette: monAnciennette,
                            totBase: salBase,
                            totPri: montPri,
                            totImp: montImp,
                            totCnps: montCnps
                        }
                    }
                );
                RecapWin.show();
            }
            else {
                MyApi.sendWarning("Veuillez patienter: Ouverture...");
            }
        })
        .catch((reason) => {
            MyApi.sendWarning(reason)
        })
    }
}
