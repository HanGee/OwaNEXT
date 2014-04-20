QT += quick androidextras

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/src/android

LIBS += -ljnigraphics

OTHER_FILES += \
	src/android/src/org/hangee/system/packagemanager/PackageManager.java \
	src/android/AndroidManifest.xml \
	content/launcher/launcher.qml \
	content/launcher/launcher.js \
	content/launcher/applauncher.qml \
	content/launcher/modules/Desktop.qml \
	content/launcher/modules/Desktops.qml \
	content/launcher/modules/GridContainer.qml \
	content/launcher/modules/GridContainer/IconItem.qml \
	content/launcher/backgrounds/1.jpg \
	content/launcher/Images/widget1.png \
	content/launcher/Images/widget2.png \
	content/launcher/Images/widget3.png \
	content/launcher/Images/widget4.png \
	content/launcher/Images/widget5.png \
	content/launcher/Images/widget6.png \
	content/launcher/Images/widget7.png \
	content/launcher/Images/widget8.png \
	content/launcher/Images/widget9.png \
	content/launcher/Images/widget10.png \
	content/launcher/Images/widget11.png \
	content/launcher/Images/widget12.png \
	content/launcher/Images/widget13.png

RESOURCES += \
	OwaNEXT.qrc

SOURCES += \
	src/owanext.cpp \
	src/apis/packagemanager.cpp

HEADERS += \
	src/apis/packagemanager.h
