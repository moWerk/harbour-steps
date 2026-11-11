import QtQuick 2.6
import Sailfish.Silica 1.0
import com.jolla.settings 1.0
import Nemo.Configuration 1.0
import org.asteroid.sensorlogd 1.0

// Today's steps in the top menu: "steps" and the count on two lines inside
// the goal ring. The count is live from sensorfw through sensorlogd's loader;
// the goal is the app's dconf key. A tap asks the daemon to write a record.
SettingsControl {
    id: root

    name: "Steps"
    contentHeight: ring.height + 2 * Theme.paddingSmall
    _showPress: false

    onClicked: steps.triggerDaemonRecording()

    ConfigurationValue {
        id: goal
        key: "/apps/harbour-steps/goal"
        defaultValue: 8000
    }

    StepsDataLoader {
        id: steps
    }

    Item {
        id: ring

        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: Theme.paddingSmall }
        width: Theme.itemSizeSmall + Theme.paddingLarge
        height: width

        readonly property real lineWidth: Theme.paddingSmall
        readonly property real fraction: goal.value > 0 ? Math.min(steps.todayTotal / goal.value, 1) : 0
        readonly property color arcColor: root.highlighted ? Theme.highlightColor : Theme.primaryColor

        onFractionChanged: canvas.requestPaint()
        onArcColorChanged: canvas.requestPaint()

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
                ctx.strokeStyle = Theme.rgba(Theme.primaryColor, Theme.opacityFaint)
                ctx.beginPath(); ctx.arc(c, c, r, 0, 2 * Math.PI); ctx.stroke()
                if (ring.fraction > 0) {
                    var start = -Math.PI / 2
                    ctx.strokeStyle = ring.arcColor
                    ctx.beginPath(); ctx.arc(c, c, r, start, start + 2 * Math.PI * ring.fraction); ctx.stroke()
                }
            }
        }

        Column {
            anchors.centerIn: parent
            width: parent.width - 2 * ring.lineWidth - Theme.paddingSmall
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "steps"
                font.pixelSize: Theme.fontSizeTiny
                color: root.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
            }
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: Number(steps.todayTotal).toLocaleString(Qt.locale(), "f", 0)
                font.pixelSize: Theme.fontSizeSmall
                fontSizeMode: Text.HorizontalFit
                color: root.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
        }
    }
}
