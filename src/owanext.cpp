#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>

#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>

#include "apis/packagemanager.h"

PackageManager *g_packageManager = NULL;
void packageAdded(JNIEnv *env, jobject thiz, jstring appName, jstring packageName, jstring activityName);
void packageRemoved(JNIEnv *env, jobject thiz, jstring packageName);

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

    /* Register JNI function*/
    g_packageManager = packageManager;
    JNINativeMethod methods[] {{"packageAdded", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", reinterpret_cast<void *>(packageAdded)},
                               {"packageRemoved", "(Ljava/lang/String;)V", reinterpret_cast<void *>(packageRemoved)}};

    QAndroidJniEnvironment env;
    QAndroidJniObject javaClass("org/hangee/system/packagemanager/BroadcastManager");
    jclass objectClass = env->GetObjectClass(javaClass.object<jobject>());
    env->RegisterNatives(objectClass, methods, sizeof(methods) / sizeof(methods[0]));
    env->DeleteLocalRef(objectClass);


	/* Load QML file */
	engine.load(QUrl("qrc:///content/launcher/launcher.qml"));

	return app.exec();
}

void packageAdded(JNIEnv *env, jobject javaobj, jstring appName, jstring packageName, jstring activityName)
{
    const char *pszAppName = env->GetStringUTFChars(appName, 0);
    const char *pszPackageName = env->GetStringUTFChars(packageName, 0);
    const char *pszActivityName = env->GetStringUTFChars(activityName, 0);

    g_packageManager->emitPackageAdded(pszAppName, pszPackageName, pszActivityName);

    env->ReleaseStringUTFChars(packageName, pszPackageName);
    env->ReleaseStringUTFChars(appName, pszAppName);
    env->ReleaseStringUTFChars(activityName, pszActivityName);

}

void packageRemoved(JNIEnv *env, jobject javaobj, jstring packageName)
{
    const char *pszPackageName = env->GetStringUTFChars(packageName, 0);
    g_packageManager->emitPackageRemoved(pszPackageName);
    env->ReleaseStringUTFChars(packageName, pszPackageName);

}
