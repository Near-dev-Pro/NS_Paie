import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Page {
    id: currentChildView
    anchors.fill: parent

    contentChildren: ScrollView {
        anchors.fill: parent

        Item {
            id: eltLay
            anchors.fill: parent // eltLay remplit son parent

            ColumnLayout {
                id: colLayId
                width: parent.width * 0.8 // Largeur à 80% du parent
                anchors.horizontalCenter: parent.horizontalCenter // Centrer colLayId horizontalement
                spacing: 10

                TextField {
                    id: empName
                    placeholderText: qsTr("Entrez le nom de l'employé")
                    implicitHeight: 50 // Fixer la hauteur à 50
                    font.pixelSize: 24 // Ajuster la taille de la police
                    Layout.alignment: Qt.AlignHCenter // Centrer empName dans le layout
                    Layout.topMargin: 20 // Ajouter une marge en haut
                    Layout.preferredWidth: colLayId.width * 0.7 // Ajuster la largeur à 70% de colLayId
                    horizontalAlignment: Text.AlignHCenter // Centrer le texte horizontalement
                    verticalAlignment: Text.AlignVCenter // Centrer le texte verticalement
                    background: Rectangle {
                        color: Material.background // Utilise Material.background pour le fond
                        radius: 10 // Coins arrondis
                        border.color: Material.accent // Appliquer Material.accent sur la bordure
                        border.width: 1 // Épaisseur de la bordure
                    }
                }

                Button {
                    id: searchBtn
                    text: qsTr("Rechercher") // Texte du bouton
                    font.bold: true // Texte en gras
                    Layout.alignment: Qt.AlignHCenter // Centrer le bouton horizontalement
                    onClicked: {
                        // TODO
                    }

                    contentItem: RowLayout {
                        spacing: 5 // Espacement entre l'icône et le texte

                        IconImage {
                            source: "qrc:/assets/images/x32/person_search.svg" // Nouveau chemin de l'image
                            Layout.preferredWidth: 20 // Largeur de l'icône
                            Layout.preferredHeight: 20 // Hauteur de l'icône
                            color: Material.foreground // Couleur de l'icône
                        }

                        Text {
                            text: searchBtn.text
                            font: searchBtn.font
                            color: Material.foreground // Couleur du texte
                            horizontalAlignment: Text.AlignHCenter // Centrer le texte horizontalement
                            verticalAlignment: Text.AlignVCenter // Centrer le texte verticalement
                            elide: Text.ElideRight // Éliminer le débordement si le texte est trop long
                        }
                    }

                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        border.color: Material.accent // Bordure avec couleur d'accent
                        border.width: 1 // Épaisseur de la bordure
                        radius: 15 // Coins arrondis
                        color: Material.accent // Couleur d'accent pour le fond
                    }
                }

                Rectangle {
                    id: sep1 // Identification unique du séparateur
                    height: 1 // Épaisseur de la ligne
                    Layout.preferredWidth: colLayId.width // Largeur égale à celle de colLayId
                    color: Material.dividerColor // Utilise Material.dividerColor pour la couleur de séparation
                }
            }
        }
    }
}
