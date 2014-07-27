import QtQuick 2.2
import Qt.labs.folderlistmodel 2.1
import '../../utils.js' as Utils

Item {
	id: appsModel
	property var apps: new Array()
	property var previousApps: new Array()
	property alias folder: folderModel.folder
	property bool initialized: false;

	signal ready
	signal packageAdded(string appName, string activityName, string packageName, string iconPath)
	signal packageRemoved(string packageName)

	function setupAppsInfo() {
		apps = [];

		for (var i = 0; i < folderModel.count; i++) {
			var filepath = folderModel.get(i, 'filePath')
			var foldername = folderModel.get(i, 'fileName');

			// Skip if it's not QML file
			var namePart = filepath.match(/[^\\]*\.(\w+)$/);
			if (namePart[1] != 'qml')
				continue;

			// Loading App from QML file
			var component = Qt.createComponent(filepath);
			if (component.status == Component.Ready) {
				var app = component.createObject();
				app.iconPath = filepath + '/../' + app.iconPath;

			} else {
				var app = {};
				app.appName = foldername;
				app.activityName = foldername;
				app.packageName = 'org.unknown.' + foldername;
				app.iconPath = filepath + '/../../defaulticon.png'
			}

			// Add to list
			apps.push({
				_filename: foldername,
				appName: app.appName,
				activity: app.activityName,
				packageName: app.packageName,
				iconPath: app.iconPath
			})

			//console.log(app.appName + ': ' + app.activityName + ': ' + app.packageName);
		}
	}

	function diffArray(param1, param2) {
		if (param1.length < param2.length) {
			return [];
		}

		return param1.filter(function (x) {
			for (var i = 0; i < param2.length; i++) {
				if (param2[i]._filename === x._filename)
					return false;
			}

			return true;
		})
	}

	function updateModel(action) {
		previousApps = [];
		previousApps = apps.slice();
		setupAppsInfo();

		if (previousApps.length > apps.length) {
			// Removed package
			var diff = diffArray(previousApps, apps)
			packageRemoved(diff[0].packageName)
		} else if (previousApps.length < apps.length) {
			// Added package
			var diff = diffArray(apps, previousApps);
			packageAdded(diff[0].appName, diff[0].activityName,
						 diff[0].packageName, diff[0].iconPath)
		}
	}

	ListView {
		FolderListModel {
			id: folderModel
			nameFilters: [ '*.qml' ]
			folder: './apps'
			onModelReset: {
				// Reset application list
				setupAppsInfo();

				if (!initialized) {
					initialized = true;
					Utils.setImmediate(function() {
						appsModel.ready();
					});
					return;
				}
			}

			onRowsInserted: {
				appsModel.updateModel();
			}
		}

		model: folderModel
	}
}
