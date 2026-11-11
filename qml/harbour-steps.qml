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

    initialPage: Component { MainPage { } }
    cover: Component { CoverPage { } }
    allowedOrientations: defaultAllowedOrientations
}
