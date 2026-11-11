import QtQuick 2.6
import Sailfish.Silica 1.0
import com.jolla.settings 1.0
import Nemo.Configuration 1.0
import org.asteroid.sensorlogd 1.0
import org.nemomobile.lipstick 0.1

// Today's steps in the top menu, laid out like a SettingsToggle: the goal
// ring where the toggle has its circle, the count inside it, "Steps" below.
// The count is live from sensorfw through sensorlogd's loader; the goal is
// the app's dconf key. A tap opens the app.
SettingsControl {
    id: root

    name: "Steps"
    contentHeight: label.y + label.height + Theme.paddingSmall
    _showPress: false

    readonly property color ringColor: highlighted ? Theme.highlightColor : Theme.primaryColor

    onClicked: launcher.launchApplication()

    LauncherItem {
        id: launcher
        filePath: "/usr/share/applications/harbour-steps.desktop"
    }

    ConfigurationValue {
        id: goal
        key: "/apps/harbour-steps/goal"
        defaultValue: 8000
    }

    // debug: a non-zero value is shown instead of the live count (dconf write, no restart)
    ConfigurationValue {
        id: testValue
        key: "/apps/harbour-steps/testValue"
        defaultValue: 0
    }
    readonly property int shown: testValue.value > 0 ? testValue.value : today

    StepsDataLoader {
        id: steps
    }

    // todayTotal only re-evaluates on a step event; re-read it when the date changes
    property int today: steps.todayTotal
    Timer {
        interval: 30000; running: true; repeat: true
        property int day: new Date().getDate()
        onTriggered: { var d = new Date().getDate(); if (d !== day) { day = d; root.today = steps.getTodayTotal() } }
    }
    Connections { target: steps; onTodayTotalChanged: root.today = steps.todayTotal }

    Item {
        id: ring

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: Theme.paddingSmall
        }
        width: Theme.itemSizeSmall
        height: Theme.itemSizeSmall

        readonly property real lineWidth: Theme.paddingSmall * 0.75
        readonly property real fraction: goal.value > 0 ? Math.min(root.shown / goal.value, 1) : 0

        onFractionChanged: canvas.requestPaint()

        Connections {
            target: root
            onRingColorChanged: canvas.requestPaint()
        }

        Canvas {
            id: canvas
            anchors.fill: parent
            antialiasing: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var c = width / 2
                var r = c - ring.lineWidth / 2
                ctx.lineWidth = ring.lineWidth
                ctx.lineCap = "round"
                ctx.strokeStyle = Theme.rgba(root.ringColor, Theme.opacityFaint)
                ctx.beginPath(); ctx.arc(c, c, r, 0, 2 * Math.PI); ctx.stroke()
                if (ring.fraction > 0) {
                    var start = -Math.PI / 2
                    ctx.strokeStyle = root.ringColor
                    ctx.beginPath(); ctx.arc(c, c, r, start, start + 2 * Math.PI * ring.fraction); ctx.stroke()
                }
            }
        }

        Label {
            anchors.centerIn: parent
            width: parent.width - 2 * ring.lineWidth - Theme.paddingSmall
            horizontalAlignment: Text.AlignHCenter
            text: Number(root.shown).toLocaleString(Qt.locale(), "f", 0)
            // Sail Sans digits are about 0.58 em wide: size the font so the number fits
            // the chord through the centre, at most fontSizeSmall (three digits).
            font.pixelSize: Math.max(Theme.fontSizeTiny * 0.8, Math.min(Theme.fontSizeSmall, width / (0.58 * text.length)))
            color: root.ringColor
        }
    }

    Label {
        id: label

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: ring.bottom
            topMargin: Theme.paddingSmall
        }
        width: root.width - Theme.paddingMedium * 2
        horizontalAlignment: implicitWidth > width ? Text.AlignLeft : Text.AlignHCenter
        truncationMode: TruncationMode.Fade
        text: root.name
        font.pixelSize: Theme.fontSizeTiny
        color: root.ringColor
    }
}
