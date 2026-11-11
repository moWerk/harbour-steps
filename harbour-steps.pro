# Steps: a step counter for Sailfish OS. The counting is done by the sensor
# hub and logged by sensorlogd; this is the Silica UI, the cover and the
# top menu item around it.
TARGET = harbour-steps

isEmpty(VERSION): VERSION = 0.1.0
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

CONFIG += sailfishapp

SOURCES += src/main.cpp

DISTFILES += qml/harbour-steps.qml \
    qml/pages/*.qml \
    qml/cover/*.qml \
    qml/components/*.qml \
    topmenu/*.qml \
    entries/*.json \
    rpm/harbour-steps.spec \
    harbour-steps.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172
