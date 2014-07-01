#ifndef PACKAGEMANAGER_H
#define PACKAGEMANAGER_H

#include <QtQml/QQmlApplicationEngine>
#include <QtAndroidExtras/QAndroidJniObject>
#include <QObject>
#include <QVariantMap>

class PackageManager : public QObject
{
	Q_OBJECT
public:
	explicit PackageManager(QObject *parent = 0);
	void setEngine(QQmlApplicationEngine *_engine);

	Q_INVOKABLE QVariantList getApps(QList<QString> categories);
	Q_INVOKABLE void startApp(QVariantMap app);

    void emitPackageAdded(QString packageName, QString appName, QString activityName);
    void emitPackageRemoved(QString packageName);

	QQmlApplicationEngine *engine;

signals:
    void packageListReady();
    void packageAdded(QString packageName, QString appName, QString activityName);
    void packageRemoved(QString packageName);

public slots:

};

#endif // PACKAGEMANAGER_H
