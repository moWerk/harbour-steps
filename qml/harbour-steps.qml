import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import org.asteroid.sensorlogd 1.0
import "pages"
import "cover"

ApplicationWindow {
    id: app

    // The daily goal, shared with the cover and the top menu item through dconf.
    property alias goal: goalConf.value
    readonly property int goalMin: 5000
    readonly property int goalMax: 20000
    readonly property int goalStep: 1000

    // Today's steps, live from sensorfw through sensorlogd's loader; the
    // per-day history comes from the daemon's log files.
    property alias steps: stepsLoader

    ConfigurationValue {
        id: goalConf
        key: "/apps/harbour-steps/goal"
        defaultValue: 8000
    }

    StepsDataLoader {
        id: stepsLoader
    }

    // todayTotal only re-evaluates on a step event; after midnight the ring
    // would keep yesterday's number until the first step. Re-read it when
    // the date changes.
    property int today: testValue.value > 0 ? testValue.value : stepsLoader.todayTotal
    // debug: a non-zero value is shown instead of the live count
    ConfigurationValue {
        id: testValue
        key: "/apps/harbour-steps/testValue"
        defaultValue: 0
    }
    Timer {
        interval: 30000; running: Qt.application.active; repeat: true
        property int day: new Date().getDate()
        onTriggered: { var d = new Date().getDate(); if (d !== day) { day = d; app.today = Qt.binding(function() { return testValue.value > 0 ? testValue.value : stepsLoader.getTodayTotal() }) } }
    }

    initialPage: Component { MainPage { } }
    cover: Component { CoverPage { } }
    allowedOrientations: defaultAllowedOrientations
}
