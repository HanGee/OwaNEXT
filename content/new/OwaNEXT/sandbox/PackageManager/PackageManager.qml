import QtQuick 2.0
import Qt.labs.folderlistmodel 1.0

Item {
	id: manager
	property alias folder: appsModel.folder
	signal ready
	signal packageRemoved(string packageName)
	signal packageAdded(string appName, string activityName, string packageName, string iconPath)

	function getApps() {
		return appsModel.apps;
	}

	function startApp(app) {
		console.log('Starting App: ' + app.appName);
	}

	AppsModel {
		id: appsModel
		folder: './apps'

		onReady: {
			manager.ready();
		}

		onPackageRemoved: {
			manager.packageRemoved(packageName);
		}

		onPackageAdded: {
			manager.packageAdded(appName, activityName, packageName, iconPath);
		}
	}
}
