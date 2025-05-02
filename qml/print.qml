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
                implicitHeight: colLayId.implicitHeight

                ColumnLayout {
                    id: colLayId
                    width: parent.width
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10

                    Label {
                        id: titreCoreData
                        text: qsTr("Liste des employés par secteurs!")
                        color: Style.placeholder
                        font.pixelSize: 22
                        font.bold: true
                        Layout.topMargin: 15
                        Layout.alignment: Qt.AlignCenter
                    }

                    // Ligne du choix du secteur
                    RowLayout {
                        id: empRow
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: (colLayId.width * 0.3)
                        Layout.maximumWidth: (colLayId.width * 0.4)
                        spacing: 10 // Espacement entre le texte et le ComboBox

                        ComboBox {
                            id: empDep
                            Layout.preferredWidth: (empRow.width * 0.6)
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

                        Button {
                            id: saveBtn1
                            text: qsTr("Charger")
                            font.bold: true
                            Layout.preferredWidth: (empDep.width * 0.4)
                            onClicked: showEmpOfDep()
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

                        Item {
                            Layout.fillWidth: true
                        }
                    }

                    Label {
                        id: emptyList
                        text: qsTr("Aucun contenu...")
                        color: Style.placeholder
                        font.pixelSize: 20
                        Layout.alignment: Qt.AlignCenter
                        visible: (partialHistTV.model === null || partialHistTV.rows === 0)
                    }

                    // Ligne du choix du table du contenu
                    ColumnLayout {
                        id: listContentColumn
                        Layout.preferredWidth: colLayId.width
                        Layout.maximumWidth: colLayId.width
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
                                color: Material.accent
                                implicitHeight: 40

                                Label {
                                    anchors.centerIn: parent
                                    color: Material.foreground
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
                                // Colonnes à masquer (par groupe)
                                const hiddenColumnsGroup1 = [1, 2, 3, 6, 8, 9, 11];
                                const hiddenColumnsGroup2 = [12, 13, 14, 15, 16, 17, 18];
                                const hiddenColumnsGroup3 = [20, 22, 23, 24, 25, 26];

                                if (hiddenColumnsGroup1.includes(column) || hiddenColumnsGroup2.includes(column) || hiddenColumnsGroup3.includes(column)) {
                                    return 0; // Masquer la colonne
                                }

                                // Largeur par défaut pour les autres colonnes
                                return partialHistTV.width / 8;
                            }
                            model: null

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
                                    width: (partialHistTV.width / 8)
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
            }
        }
    }

    function showEmpOfDep() {
        if (empDep.currentIndex < 0) {
            MyApi.sendWarning("Veuillez selectionner le secteur!")
        }
        else {
            let myObj = {};
            myObj["sect"] = empDep.currentValue

            partialHistTV.model = MyApi.getGroupOfEmp(JSON.stringify(myObj), true)
        }
    }
}
