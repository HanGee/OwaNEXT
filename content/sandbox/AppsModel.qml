import QtQuick 2.2
import Qt.labs.folderlistmodel 2.1

Item {
    id: appsModel
    property var apps: new Array()
    property var previousApps: new Array()
    property alias folder: folderModel.folder
    signal appsListChanged
    signal packageAdded(string appName, string activityName, string packageName, string iconPath)
    signal packageRemoved(string appName)

    function setupAppsInfo() {
        apps.length = []

        for (var i = 0; i < folderModel.count; i++) {
            var filepath = folderModel.get(i, "filePath")
            var foldername = folderModel.get(i, "fileName");
            var componentQML =  filepath+ "/" + foldername + ".qml"
            var component = Qt.createComponent(componentQML);
            if (component.status == Component.Ready)
            {
                var app = component.createObject();
                app.iconPath = filepath + "/" + app.iconPath;

            }
            else
            {
                var app;
                app.activityName = foldername;
                app.packageName = "org.unknown." + foldername;
                app.iconPath = filepath + "/../../defaulticon.png"
            }

            apps.push({
                          appName: foldername,
                          activity: app.activityName,
                          packageName: app.packageName,
                          iconPath: app.iconPath
                      })
            console.log(foldername + ":" + app.activityName + ":" + app.packageName);
        }
    }

    function diffArray(param1, param2) {
        if (param1.length < param2.length) {
            return [];
        }

        return param1.filter(function (x) {
            for (var i = 0; i < param2.length; i++) {
                if (param2[i].appName === x.appName)
                    return false;
            }
            return true;
        })
    }

    function updateModel(action) {
        if (action === "RESET") {
            setupAppsInfo()
            appsListChanged()
            return
        }

        if (action === "INSERTED") {

            previousApps = []
            previousApps = apps.slice()
            setupAppsInfo()

            if (previousApps.length > apps.length) {
                var diff = diffArray(previousApps, apps)
                packageRemoved(diff[0].appName)
            } else if (previousApps.length < apps.length) {
                var diff = diffArray(apps, previousApps);
                packageAdded(diff[0].appName, diff[0].activityName,
                             diff[0].packageName, diff[0].iconPath)
            }
        }
    }

    ListView {
        FolderListModel {
            id: folderModel
            nameFilters: ["*."]
            folder: "./apps"
            onModelReset: {
                appsModel.updateModel("RESET")
            }

            onRowsInserted: {
                appsModel.updateModel("INSERTED")
            }
        }

        model: folderModel
    }
}
