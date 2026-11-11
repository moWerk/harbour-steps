import QtQuick 2.6
import Sailfish.Silica 1.0

// A goal ring: a faint full track and an arc from twelve o'clock clockwise
// for value/goal. Children are centred inside the ring.
Item {
    id: ring

    property int value
    property int goal: 1
    property real lineWidth: Theme.paddingMedium
    property color trackColor: Theme.rgba(Theme.primaryColor, Theme.opacityFaint)
    property color arcColor: Theme.highlightColor
    readonly property real fraction: goal > 0 ? Math.min(value / goal, 1) : 0
    default property alias content: inner.data

    width: Theme.itemSizeLarge
    height: width

    onFractionChanged: canvas.requestPaint()
    onLineWidthChanged: canvas.requestPaint()
    onTrackColorChanged: canvas.requestPaint()
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
            ctx.strokeStyle = ring.trackColor
            ctx.beginPath()
            ctx.arc(c, c, r, 0, 2 * Math.PI)
            ctx.stroke()
            if (ring.fraction > 0) {
                var start = -Math.PI / 2
                ctx.strokeStyle = ring.arcColor
                ctx.beginPath()
                ctx.arc(c, c, r, start, start + 2 * Math.PI * ring.fraction)
                ctx.stroke()
            }
        }
    }

    Item {
        id: inner
        anchors.centerIn: parent
        width: parent.width - 2 * ring.lineWidth
        height: width
    }
}
