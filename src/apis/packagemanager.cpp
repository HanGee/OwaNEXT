#include <QAndroidJniEnvironment>
#include "packagemanager.h"

PackageManager::PackageManager(QObject *parent) :
	QObject(parent)
{
}

QVariantList PackageManager::getApps(QList<QString> categories)
{
	QVariantList appList;
	QAndroidJniEnvironment env;

	// Initializing category filter
	jobjectArray jCategories = (jobjectArray)env->NewObjectArray(categories.length(), env->FindClass("java/lang/String"), NULL);
	for (int i = 0; i < categories.length(); i++) {
		jstring s = env->NewStringUTF((char *)categories.at(i).toLocal8Bit().data());
		env->SetObjectArrayElement(jCategories, i, s);
	}

	// Invoke method
	QAndroidJniObject retObj = QAndroidJniObject::callStaticObjectMethod("org/hangee/system/packagemanager/PackageManager",
		"getApps",
		"([Ljava/lang/String;)Ljava/util/ArrayList;",
		jCategories);


	// Getting application list
	jint size = retObj.callMethod<jint>("size");
	for (int i = 0; i < size; i++) {

		QVariantMap appInfo;

		// Getting ResolveInfo
		QAndroidJniObject jInfo = retObj.callObjectMethod("get", "(I)Ljava/lang/Object;", i);

		// App name
		QAndroidJniObject fieldName = QAndroidJniObject::fromString("appName");
		QAndroidJniObject appNameObj = jInfo.callObjectMethod("get",
			"(Ljava/lang/Object;)Ljava/lang/Object;",
			fieldName.object<jobject>());
		appInfo.insert("appName", appNameObj.toString());

		// Package name
		QAndroidJniObject fieldPackageName = QAndroidJniObject::fromString("packageName");
		QAndroidJniObject packageNameObj = jInfo.callObjectMethod("get",
			"(Ljava/lang/Object;)Ljava/lang/Object;",
			fieldPackageName.object<jobject>());
		appInfo.insert("packageName", packageNameObj.toString());

		// Activity name
		QAndroidJniObject fieldActivityName = QAndroidJniObject::fromString("activityName");
		QAndroidJniObject activityNameObj = jInfo.callObjectMethod("get",
			"(Ljava/lang/Object;)Ljava/lang/Object;",
			fieldActivityName.object<jobject>());
		appInfo.insert("activityName", activityNameObj.toString());

		appList.append(QVariant(appInfo));
	}

	return appList;
}

void PackageManager::startApp(QVariantMap app)
{
	// Launch app
	QAndroidJniObject packageName = QAndroidJniObject::fromString(app.value("packageName").toString());
	QAndroidJniObject activityName = QAndroidJniObject::fromString(app.value("activityName").toString());
	QAndroidJniObject::callStaticMethod<void>("org/hangee/system/packagemanager/PackageManager",
		"startApp",
		"(Ljava/lang/String;Ljava/lang/String;)V",
		packageName.object<jstring>(),
		activityName.object<jstring>());
}
