import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"

CoverBackground {
    id: cover

    StepRing {
        anchors.centerIn: parent
        width: parent.width * 0.7
        lineWidth: Theme.paddingMedium
        value: app.steps.todayTotal
        goal: app.goal

        Column {
            anchors.centerIn: parent
            width: parent.width
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("steps")
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryHighlightColor
            }
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: Number(app.steps.todayTotal).toLocaleString(Qt.locale(), "f", 0)
                font.pixelSize: Theme.fontSizeLarge
                fontSizeMode: Text.HorizontalFit
                color: Theme.highlightColor
            }
        }
    }
}
