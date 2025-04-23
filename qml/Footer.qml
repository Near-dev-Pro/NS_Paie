import QtQuick
import QtQuick.Controls.Material

Rectangle {
    id: footer
    width: parent.width
    height: 50
    color: Material.background

    Label {
        anchors.centerIn: parent
        text: qsTr("NearSolutions - 2025")
        color: Material.primary
        font.underline: true
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Qt.openUrlExternally("mailto:vougueingghislainbryan@gmail.com")
        }
    }
}
