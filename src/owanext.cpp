#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include "apis/packagemanager.h"

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
	QQmlApplicationEngine engine;
	QVariantMap hangee;

	/* Initializing APIs */
	PackageManager *packageManager = new PackageManager();
	packageManager->setEngine(&engine);

	hangee.insert("packageManager", QVariant::fromValue(packageManager));
	engine.rootContext()->setContextProperty("hangee", QVariant::fromValue(hangee));

	/* Load QML file */
	engine.load(QUrl("qrc:///content/launcher/launcher.qml"));

	return app.exec();
}
