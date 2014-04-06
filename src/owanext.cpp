#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include "apis/packagemanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    /* Initializing APIs */
    PackageManager *packageManager = new PackageManager();
    engine.rootContext()->setContextProperty("packageManager", packageManager);

    /* Load QML file */
    engine.load(QUrl("qrc:///content/launcher/launcher.qml"));

    return app.exec();
}
