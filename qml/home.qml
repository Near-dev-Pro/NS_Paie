import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Page {
    id: currentItemId
    property StackView stkView: StackView.view

    // Barre d'Outils
    // header: ToolBar {
    //     Layout.fillWidth: true
    //     opacity: 0.8

    //     RowLayout {
    //         anchors.fill: parent
    //         spacing: 10

    //         ToolButton {
    //             id: toolNewSale
    //             property string targetIcon: "qrc:/assets/images/x32/dashboard.svg"
    //             property string targetPage: "qrc:/qml/dashboard.qml"

    //             contentItem: RowLayout {
    //                 spacing: 5
    //                 Layout.alignment: Qt.AlignHCenter

    //                 IconImage {
    //                     source: toolNewSale.targetIcon
    //                     Layout.preferredWidth: 24
    //                     Layout.preferredHeight: 24
    //                     color: "white"
    //                 }
    //                 Label {
    //                     text: qsTr("Tableau de bord")
    //                     color: "white"
    //                     font.bold: true
    //                     font.pixelSize: 22
    //                 }
    //             }
    //         }

    //         Item {
    //             Layout.fillWidth: true
    //         }

    //         ToolButton {
    //             id: toolHelp
    //             property string targetIcon: "qrc:/assets/images/x32/contact_support.svg"
    //             property string targetPage: "qrc:/qml/contact_support.qml"

    //             onClicked: {
    //                 currentItemId.stkView.push("qrc:/qml/contact_support.qml")
    //             }

    //             contentItem: RowLayout {
    //                 spacing: 5
    //                 Layout.alignment: Qt.AlignHCenter

    //                 Label {
    //                     text: qsTr("Contacts & Supports")
    //                     color: "white"
    //                     font.bold: true
    //                     font.pixelSize: 22
    //                 }
    //                 IconImage {
    //                     source: toolHelp.targetIcon
    //                     Layout.preferredWidth: 24
    //                     Layout.preferredHeight: 24
    //                     color: "white"
    //                 }
    //             }
    //         }
    //     }
    // }

    ScrollView {
        anchors.fill: parent

        // To be removed
        Button {
            text: "click"
            onClicked: {
                currentItemId.stkView.push("qrc:/qml/bullMat.qml")
            }
        }
    }
}
