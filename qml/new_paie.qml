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
                    }

                    Button {
                        id: searchBtn
                        text: qsTr("Rechercher")
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
                            text: qsTr("Département:")
                            font.pixelSize: 16
                            color: Material.foreground
                            verticalAlignment: Text.AlignVCenter
                        }

                        // ComboBox pour sélectionner un département

                        ComboBox {
                            id: departmentFilter
                            Layout.preferredWidth: (parent.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            model: ["Marketing", "RH", "Finance", "Production"]
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

                        // ComboBox pour sélectionner une année
                        ComboBox {
                            id: yearFilter
                            Layout.preferredWidth: (parent.width * 0.6)
                            Layout.alignment: Qt.AlignRight
                            currentIndex: -1 // Aucun élément sélectionné par défaut

                            // Génération dynamique des 20 dernières années
                            model: ListModel {
                                Component.onCompleted: {
                                    const currentYear = new Date().getFullYear();
                                    for (let i = 0; i < 20; i++) {
                                        append({ year: (currentYear - i).toString() });
                                    }
                                }
                            }

                            delegate: ItemDelegate {
                                id: delegateYear

                                required property var model
                                required property int index

                                width: yearFilter.width
                                contentItem: Text {
                                    text: delegateYear.model[yearFilter.textRole]
                                    color: Material.foreground
                                    font: yearFilter.font
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                                highlighted: yearFilter.highlightedIndex === index
                            }

                            indicator: Canvas {
                                id: canvasYear
                                x: yearFilter.width - width - yearFilter.rightPadding
                                y: yearFilter.topPadding + (yearFilter.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"

                                Connections {
                                    target: yearFilter
                                    function onPressedChanged() { canvasYear.requestPaint(); }
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
                                rightPadding: yearFilter.indicator.width + yearFilter.spacing

                                text: yearFilter.displayText
                                font: yearFilter.font
                                color: Style.text
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                implicitWidth: (parent.width * 0.6)
                                implicitHeight: 40
                                color: Material.background
                                border.color: Material.accent
                                border.width: yearFilter.visualFocus ? 2 : 1
                                radius: 10
                            }

                            popup: Popup {
                                y: yearFilter.height - 1
                                width: yearFilter.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: yearFilter.popup.visible ? yearFilter.delegateModel : null
                                    currentIndex: yearFilter.highlightedIndex

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
                        id: applyFilterBtn
                        text: qsTr("Appliquer et chercher")
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
                        visible: (listView.model === null || listView.model.count === 0)
                    }

                    ListView {
                        id: listView
                        Layout.fillHeight: true
                        Layout.preferredWidth: colLayId2.width
                        visible: (listView.model !== null && listView.model.count > 0)
                        model: ListModel {
                            // ListElement { idEmp: "1"; libEmp: "Alice" }
                            // ListElement { idEmp: "2"; libEmp: "Bob" }
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
