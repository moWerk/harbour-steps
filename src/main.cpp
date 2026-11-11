/*
 * Steps: a step counter for Sailfish OS.
 * Copyright (C) 2026 moWerk
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */
#include <sailfishapp.h>
#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setApplicationName("harbour-steps");
    app->setApplicationVersion(APP_VERSION);
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->rootContext()->setContextProperty("appVersion", APP_VERSION);
    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return app->exec();
}
