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
                id: subEltLay
                anchors.fill: parent
                color: "transparent"
                implicitHeight: colLayId.implicitHeight

                ColumnLayout {
                    id: colLayId
                    width: (parent.width * 0.4)
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 10
                    anchors.left: parent.left
                    spacing: 10

                    Item {
                        Layout.fillHeight: true
                    }

                    TextField {
                        id: empName
                        placeholderText: qsTr("Entrez le nom de l'employé")
                        implicitHeight: 50
                        font.pixelSize: 24
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 20
                        placeholderTextColor: Style.placeholder
                        Layout.preferredWidth: colLayId.width * 0.7
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        background: Rectangle {
                            color: Material.background
                            radius: 25
                            border.color: Material.accent
                            border.width: 1
                        }
                        Keys.onEnterPressed: searchEmp()
                        Keys.onReturnPressed: searchEmp()
                    }

                    Button {
                        id: searchBtn
                        text: qsTr("Rechercher")
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: searchEmp()
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
                                text: searchBtn.text
                                font: searchBtn.font
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

                    Rectangle {
                        id: sep1
                        height: 1
                        Layout.preferredWidth: (colLayId.width * 0.7)
                        Layout.alignment: Qt.AlignHCenter
                        color: Style.shadow
                    }

                    // Filtres de recherche
                    RowLayout {
                        id: departmentRow
                        Layout.topMargin: 20
                        Layout.preferredWidth: colLayId.width * 0.7
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Secteur:")
                            font.pixelSize: 16
                            color: Material.foreground
                            verticalAlignment: Text.AlignVCenter
                        }

                        // ComboBox pour sélectionner un département

                        ComboBox {
                            id: departmentFilter
                            Layout.preferredWidth: (parent.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            model: MyApi.getListSectNoms()
                            currentIndex: -1 // Aucun élément sélectionné par défaut

                            delegate: ItemDelegate {
                                id: delegateDep

                                required property var model
                                required property int index

                                width: departmentFilter.width
                                contentItem: Text {
                                    text: delegateDep.model[departmentFilter.textRole]
                                    color: Material.foreground
                                    font: departmentFilter.font
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                                highlighted: departmentFilter.highlightedIndex === index
                            }

                            indicator: Canvas {
                                id: canvas
                                x: departmentFilter.width - width - departmentFilter.rightPadding
                                y: departmentFilter.topPadding + (departmentFilter.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"

                                Connections {
                                    target: departmentFilter
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
                                rightPadding: departmentFilter.indicator.width + departmentFilter.spacing

                                text: departmentFilter.displayText
                                font: departmentFilter.font
                                color: Style.text
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                implicitWidth: (parent.width * 0.6)
                                implicitHeight: 40
                                color: Material.background
                                border.color: Material.accent
                                border.width: departmentFilter.visualFocus ? 2 : 1
                                radius: 10
                            }

                            popup: Popup {
                                y: departmentFilter.height - 1
                                width: departmentFilter.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: departmentFilter.popup.visible ? departmentFilter.delegateModel : null
                                    currentIndex: departmentFilter.highlightedIndex

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

                    RowLayout {
                        id: genderRow
                        Layout.preferredWidth: colLayId.width * 0.7
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte indicatif et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Sexe:")
                            font.pixelSize: 16
                            color: Material.foreground
                            verticalAlignment: Text.AlignVCenter
                        }

                        // ComboBox pour sélectionner le sexe
                        ComboBox {
                            id: genderFilter
                            Layout.preferredWidth: (parent.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            model: ["Masculin", "Féminin"]
                            currentIndex: -1 // Aucun élément sélectionné par défaut

                            delegate: ItemDelegate {
                                id: delegateGender

                                required property var model
                                required property int index

                                width: genderFilter.width
                                contentItem: Text {
                                    text: delegateGender.model[genderFilter.textRole]
                                    color: Material.foreground
                                    font: genderFilter.font
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                                highlighted: genderFilter.highlightedIndex === index
                            }

                            indicator: Canvas {
                                id: canvasGender
                                x: genderFilter.width - width - genderFilter.rightPadding
                                y: genderFilter.topPadding + (genderFilter.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"

                                Connections {
                                    target: genderFilter
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
                                rightPadding: genderFilter.indicator.width + genderFilter.spacing

                                text: genderFilter.displayText
                                font: genderFilter.font
                                color: Style.text
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                implicitWidth: (parent.width * 0.6)
                                implicitHeight: 40
                                color: Material.background
                                border.color: Material.accent
                                border.width: genderFilter.visualFocus ? 2 : 1
                                radius: 10
                            }

                            popup: Popup {
                                y: genderFilter.height - 1
                                width: genderFilter.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: genderFilter.popup.visible ? genderFilter.delegateModel : null
                                    currentIndex: genderFilter.highlightedIndex

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

                    RowLayout {
                        id: yearRow
                        Layout.preferredWidth: colLayId.width * 0.7
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10 // Espacement entre le texte indicatif et le ComboBox

                        // Texte indicatif
                        Label {
                            text: qsTr("Année:")
                            font.pixelSize: 16
                            color: Material.foreground
                            verticalAlignment: Text.AlignVCenter
                        }

                        // SpinBox pour sélectionner une année
                        SpinBox {
                            id: yearFilter
                            Layout.preferredWidth: (parent.width * 0.6)
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

                    Button {
                        id: applyFilterBtn
                        text: qsTr("Appliquer et chercher")
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: searchWithFilters()
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
                                text: applyFilterBtn.text
                                font: applyFilterBtn.font
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

                    Item {
                        Layout.fillHeight: true
                    }
                }

                // Deuxième ColumnLayout : 50% de la largeur
                ColumnLayout {
                    id: colLayId2
                    width: subEltLay.width * 0.5
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    spacing: 10

                    // Contenu exemple (modifiable)
                    Label {
                        id: emptyList
                        text: qsTr("Aucun contenu...")
                        color: Style.placeholder
                        font.pixelSize: 20
                        Layout.alignment: Qt.AlignCenter
                        visible: (listView.model === null || listView.count === 0)
                    }

                    ListView {
                        id: listView
                        Layout.fillHeight: true
                        Layout.preferredWidth: colLayId2.width
                        visible: (listView.model !== null && listView.count > 0)
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
                                        text: (index + 1)
                                        font.pixelSize: 16
                                        color: Material.foreground
                                    }
                                    Text {
                                        text: listView.model.data(listView.model.index(index, 0))
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
                                            brightness: 1.0
                                            saturation: 1.0
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
                                    text: qsTr("Aperçu du bulletin de paie")
                                    onTriggered: searchSecForBullPaie(listView.model.data(listView.model.index(index, 0)))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function searchEmp() {
        let checkEmpName = new Promise((resolve, reject) => {
            if (empName.length < 1) {
                reject("Veuillez saisir un nom à rechercher!")
            }
            else {
                resolve(empName.text)
            }
        })
        .then ((theName) => {
            listView.model = MyApi.getOneEmp(theName)
        })
        .catch ((reason) => {
            MyApi.sendWarning(reason)
        })
    }

    function searchWithFilters() {
        let myObj = {};
        myObj["sect"] = departmentFilter.currentValue
        myObj["sex"] = genderFilter.currentIndex
        myObj["year"] = yearFilter.value.toString()

        listView.model = MyApi.getGroupOfEmp(JSON.stringify(myObj))
    }

    function searchSecForBullPaie(theEmpName) {
        new Promise((resolve, reject) => {
            let correctBullname = MyApi.getSecNomForShowBull(theEmpName)
            if (correctBullname.length > 0) {
                resolve(correctBullname)
            }
            else {
                reject("Impossible d'ouvrir le bulltin!")
            }
        })
        .then((finalName) => {
            const d = new Date();
            const month = ["Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Decembre"];
            let component = Qt.createComponent(`bull${finalName}.qml`);

            let bullWin = component.createObject(
                parent,
                {
                    theData: {
                        numBull: `${Number(0).toString().padStart(3, "0")}/${d.getFullYear().toString()}/${finalName}/bla/bla`,
                        curMonth: month[d.getMonth()],
                              empName: "",
                              numCnps: "",
                              numMatInt: Number(24).toString().padStart(3, "0"),
                              numNiu: "",
                              libTypEmp: "",
                              cate: "",
                              salBase: Number(0).toString(),
                              prime: Number(0).toString(),
                              salCot: Number(0).toString(),
                              salTax: Number(0).toString(),
                              salBrute: Number(0).toString(),
                              irpp: Number(0).toString(),
                              tc: Number(0).toString(),
                              cf: Number(0).toString(),
                              cac: Number(0).toString(),
                              rav: Number(0).toString(),
                              cotCnps: Number(0).toString(),
                              nap: Number(0).toString()
                    }
                }
            );
            if (component.status === Component.Ready) {
                bullWin.show();
            }
            else {
                MyApi.sendWarning("Veuillez patienter: Ouverture du bulletin...");
            }
        })
        .catch((reason) => {
            MyApi.sendWarning(reason)
        })
    }
}
