import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import QtQuick.Particles 2.0
import "modules"
import "modules/Effects"
import "launcher.js" as HanGee

ApplicationWindow {
    id: appWindow
    color: 'black'
    visible: true
    property var apps: []

    // Background
    Image {
        id: background
        source: 'backgrounds/1.jpg'
        anchors.fill: parent
        cache: true
        asynchronous: true
    }

    Desktops {
        id: desktops
        anchors.fill: parent
    }

    Connections {
        target: HanGee.packageManager
        onPackageListReady:
        {
            loadAppsToDesktop();
        }

        onPackageAdded: {
            console.log("[QML] Package Added:" + packageName + "[" + appName
                        + "] - " + activityName)
            apps = []
            desktops.removeAllApps()
            loadAppsToDesktop()
        }

        onPackageRemoved: {
            console.log("[QML] Package Removed:" + packageName)
            apps = []
            desktops.removeAllApps()
            loadAppsToDesktop()
        }
    }

    Component.onCompleted: {
        if (HanGee.isSandbox) {
            width = 480
            height = 800
        } else {
            loadAppsToDesktop()
        }
    }

    function loadAppsToDesktop() {
        // Getting applications
        var _apps = HanGee.packageManager.getApps(['LAUNCHER'])

        // Create desktops and put apps
        var list = []
        var i = 0
        for (var index in _apps) {

            var app = _apps[index]
            list.push(app)

            i++
            if (i == 16) {
                apps.push(list)
                list = []
                i = 0
            }
        }

        if (i < 16)
            apps.push(list)

        for (var index in apps) {

            desktops.addDesktop()
        }
    }
}
