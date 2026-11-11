import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page

    // The last 30 days with a record, newest first; today is always shown.
    function reloadHistory() {
        history.clear()
        var today = new Date()
        for (var i = 0; i < 30; i++) {
            var d = new Date(today.getFullYear(), today.getMonth(), today.getDate() - i)
            var total = i === 0 ? app.steps.todayTotal : app.steps.getTotalForDate(d)
            if (i === 0 || total > 0) {
                history.append({ day: d, total: total })
            }
        }
    }

    function dayLabel(d) {
        var today = new Date()
        var diff = Math.round((new Date(today.getFullYear(), today.getMonth(), today.getDate()) - new Date(d.getFullYear(), d.getMonth(), d.getDate())) / 86400000)
        if (diff === 0) return qsTr("Today")
        if (diff === 1) return qsTr("Yesterday")
        return Qt.formatDate(d, diff < 7 ? "dddd" : "ddd d MMM")
    }

    Component.onCompleted: reloadHistory()

    Connections {
        target: app.steps
        onDataChanged: page.reloadHistory()
        onTodayTotalChanged: if (history.count > 0) history.setProperty(0, "total", app.steps.todayTotal)
    }

    // Midnight: the top row becomes yesterday
    Timer {
        interval: 60000; running: page.status === PageStatus.Active; repeat: true
        property int day: new Date().getDate()
        onTriggered: { var d = new Date().getDate(); if (d !== day) { day = d; page.reloadHistory() } }
    }

    ListModel { id: history }

    SilicaListView {
        id: list
        anchors.fill: parent
        model: history

        header: Column {
            width: parent.width

            PageHeader { title: qsTr("Steps") }

            StepBadge {
                width: parent.width
                size: Math.min(page.width, page.height) * 0.55
                lineWidth: Theme.paddingLarge
                value: app.steps.todayTotal
                goal: app.goal
                numberSize: Theme.fontSizeHuge * 1.3
                labelSize: Theme.fontSizeLarge
            }

            Item { width: 1; height: Theme.paddingLarge }

            Slider {
                id: goalSlider
                width: parent.width
                minimumValue: app.goalMin
                maximumValue: app.goalMax
                stepSize: app.goalStep
                value: app.goal
                label: qsTr("Daily goal")
                valueText: Number(sliderValue).toLocaleString(Qt.locale(), "f", 0) + " " + qsTr("steps")
                          + " (" + Math.round(100 * app.steps.todayTotal / sliderValue) + " %)"
                onReleased: app.goal = sliderValue
            }

            SectionHeader { text: qsTr("History") }
        }

        delegate: ListItem {
            id: row
            contentHeight: Theme.itemSizeSmall
            readonly property real share: app.goal > 0 ? Math.min(model.total / app.goal, 1) : 0
            readonly property bool reached: model.total >= app.goal

            // goal bar behind the text
            Rectangle {
                anchors { left: parent.left; leftMargin: Theme.horizontalPageMargin; verticalCenter: parent.verticalCenter }
                width: (parent.width - 2 * Theme.horizontalPageMargin) * row.share
                height: parent.height - 2 * Theme.paddingMedium
                radius: Theme.paddingSmall
                color: Theme.rgba(row.reached ? Theme.highlightColor : Theme.primaryColor, row.reached ? Theme.opacityLow : Theme.opacityFaint)
            }
            Label {
                anchors { left: parent.left; leftMargin: Theme.horizontalPageMargin + Theme.paddingMedium; verticalCenter: parent.verticalCenter }
                text: page.dayLabel(model.day)
                color: row.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            Label {
                anchors { right: parent.right; rightMargin: Theme.horizontalPageMargin + Theme.paddingMedium; verticalCenter: parent.verticalCenter }
                text: Number(model.total).toLocaleString(Qt.locale(), "f", 0)
                color: row.reached ? Theme.highlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeMedium
            }
        }

        VerticalScrollDecorator { }
    }
}
