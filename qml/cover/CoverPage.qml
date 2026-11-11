import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"

CoverBackground {
    id: cover

    StepBadge {
        anchors.centerIn: parent
        width: parent.width
        size: parent.width * 0.62
        lineWidth: Theme.paddingMedium
        value: app.steps.todayTotal
        goal: app.goal
        numberSize: Theme.fontSizeLarge
        labelSize: Theme.fontSizeSmall
    }
}
