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
		var _apps = [];

		for (var i = 0; i < folderModel.count; i++) {
			var filepath = folderModel.get(i, 'filePath')
			var filename = folderModel.get(i, 'fileName');

			// Skip if it's a directory
			if (folderModel.isFolder(i))
				continue;

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
				app.appName = filename;
				app.activityName = filename;
				app.packageName = 'org.unknown.' + filename;
				app.iconPath = filepath + '/../../defaulticon.png'
			}

			// Add to list
			_apps.push({
				_filename: filename,
				appName: app.appName,
				activity: app.activityName,
				packageName: app.packageName,
				iconPath: app.iconPath
			});

			//console.log(app.appName + ': ' + app.activityName + ': ' + app.packageName);
		}

		return _apps;
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

	function updateModel() {
		var newApps = setupAppsInfo();

		if (apps.length > newApps.length) {
			// Removed package
			var diff = diffArray(apps, newApps)

			// Remove from array
			var index = apps.indexOf(diff[0]);
			if (index > -1)
				apps.splice(index, 1);

			packageRemoved(diff[0].packageName)
		} else if (apps.length < newApps.length) {
			// Added package
			var diff = diffArray(newApps, apps);

			// Add to array
			apps.push(diff[0]);

			packageAdded(diff[0].appName, diff[0].activityName,
						 diff[0].packageName, diff[0].iconPath)
		}
	}

	ListView {
		visible: false;
		model: FolderListModel {
			id: folderModel
			nameFilters: [ '*' ];
			folder: './apps';

			onModelReset: {
				// Reset application list
				apps = setupAppsInfo();

				if (!initialized) {
					initialized = true;

					// Fire ready event
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
	}
}
