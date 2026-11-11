import QtQuick 2.6
import Sailfish.Silica 1.0

// The top menu item, enlarged: the goal ring with the count inside and a
// label below. `size` is the ring's diameter.
Column {
    id: badge

    property int value
    property int goal: 1
    property real size: Theme.itemSizeLarge
    property real lineWidth: Theme.paddingMedium
    property string label: qsTr("Steps")
    property real numberSize: Theme.fontSizeHuge
    property real labelSize: Theme.fontSizeMedium
    property color color: Theme.highlightColor

    spacing: Theme.paddingSmall

    StepRing {
        anchors.horizontalCenter: parent.horizontalCenter
        width: badge.size
        lineWidth: badge.lineWidth
        value: badge.value
        goal: badge.goal
        arcColor: badge.color
        trackColor: Theme.rgba(badge.color, Theme.opacityFaint)

        Label {
            id: number
            anchors.centerIn: parent
            width: parent.width - Theme.paddingMedium
            horizontalAlignment: Text.AlignHCenter
            text: Number(badge.value).toLocaleString(Qt.locale(), "f", 0)
            // Sail Sans digits are about 0.58 em wide; a separator less. Size the font
            // so the whole number fits the chord through the centre, never above numberSize.
            font.pixelSize: Math.max(Theme.fontSizeTiny, Math.min(badge.numberSize, width / (0.58 * text.length)))
            color: badge.color
        }
    }

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        text: badge.label
        font.pixelSize: badge.labelSize
        color: badge.color
    }
}
