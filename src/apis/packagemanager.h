#ifndef PACKAGEMANAGER_H
#define PACKAGEMANAGER_H

#include <QtAndroidExtras/QAndroidJniObject>
#include <QObject>
#include <QVariantMap>

class PackageManager : public QObject
{
	Q_OBJECT
public:
	QAndroidJniObject packageManager;
	explicit PackageManager(QObject *parent = 0);
	Q_INVOKABLE QVariantList getApps(QList<QString> categories);
	Q_INVOKABLE void startApp(QVariantMap app);

signals:

public slots:

};

#endif // PACKAGEMANAGER_H
