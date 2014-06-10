#include <QAndroidJniEnvironment>
#include <QQuickImageProvider>
#include <QImage>
#include <QBitmap>
#include <QPixmap>
#include <QByteArray>
#include <QDebug>
#include <android/bitmap.h>
#include "packagemanager.h"

// Image provider
class PackageManagerImageProvider : public QQuickImageProvider {
public:
	PackageManagerImageProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap)
	{
	}

	QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
	{
		QAndroidJniEnvironment env;
		QAndroidJniObject packageName = QAndroidJniObject::fromString(id);
		QAndroidJniObject bitmap = QAndroidJniObject::callStaticObjectMethod("org/hangee/system/packagemanager/PackageManager",
			"getAppIcon",
			"(Ljava/lang/String;)Landroid/graphics/Bitmap;",
			packageName.object<jstring>());

		jobject bitmapObj = bitmap.object<jobject>();
		AndroidBitmapInfo info;
		int ret;
		void *bitmapPixels;

		// Getting bitmap information
		if ((ret = AndroidBitmap_getInfo(env, bitmapObj, &info)) < 0) {
			QPixmap pixmap;
			return pixmap;
		}

		// Lock bitmap and get its pixels
		if ((ret = AndroidBitmap_lockPixels(env, bitmapObj, &bitmapPixels)) < 0) {
			QPixmap pixmap;
			return pixmap;
		}

		// Configuring result size
		QSize resultSize = QSize(requestedSize.width() > 0 ? requestedSize.width() : info.width,
				requestedSize.height() > 0 ? requestedSize.height() : info.height);
		if (size)
			*size = resultSize;


		// Find the format of pixels data
		QImage::Format format = QImage::Format_MonoLSB;
		switch(info.format) {
		case ANDROID_BITMAP_FORMAT_RGBA_8888:
			format = QImage::Format_RGBA8888_Premultiplied;
			break;

		case ANDROID_BITMAP_FORMAT_RGB_565:
			format = QImage::Format_RGB16;
			break;

		case ANDROID_BITMAP_FORMAT_RGBA_4444:
			format = QImage::Format_ARGB4444_Premultiplied;
			break;

		case ANDROID_BITMAP_FORMAT_A_8:
			format = QImage::Format_Indexed8;
			break;
			
		}

		// Convert pixels to pixmap
		QImage qimage((const uchar *)bitmapPixels, info.width, info.height, format);
		QPixmap pixmap = QPixmap::fromImage(qimage);

		// Unlock pixels
		AndroidBitmap_unlockPixels(env, bitmapObj);

		return pixmap.scaled(resultSize, Qt::KeepAspectRatio);
	}
};

PackageManager::PackageManager(QObject *parent) :
	QObject(parent)
{
}

void PackageManager::setEngine(QQmlApplicationEngine *_engine)
{
	engine = _engine;

	engine->addImageProvider(QString("PackageManager"), new PackageManagerImageProvider);
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

		// Icon path
		appInfo.insert("iconPath", QString("image://PackageManager/" + packageNameObj.toString()));

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

void PackageManager::emitPackageAdded(QString packageName, QString appName, QString activityName)
{
    emit packageAdded(packageName, appName, activityName);
}

void PackageManager::emitPackageRemoved(QString packageName)
{
    emit packageRemoved(packageName);
}
