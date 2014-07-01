import QtQuick 2.0
import Qt.labs.folderlistmodel 1.0
import "../sandbox"

Item {
    id:manager
    property alias folder:appsModel.folder
    signal packageListReady
    signal packageRemoved(string packageName)
    signal packageAdded(string appName, string activityName, string packageName, string iconPath)
    function getApps()
    {
        return appsModel.apps;
    }

    AppsModel {
        id: appsModel
        folder:"/Users/diro/project/OwaNEXT/content/sandbox/apps"
        onAppsListChanged:
        {
            packageListReady();
        }
        onPackageRemoved:
        {
            manager.packageRemoved(appName);
        }
        onPackageAdded:
        {
            console.log("[test module] package added")
            manager.packageAdded(appName, activityName, packageName, iconPath);
        }
    }

}
