import QtQuick 2.0
import QtQuick.Controls 1.0

ListModel {
	id: icons;

	property Item owaNEXT;
	property int filter: 0;

	// Category enumeration
	property int categoryLauncher: 1;

	property bool paginable: false;
	property int count: 16;
	property int page: 1;
	property var apps: [];

	function updateApps() {
		var filters = [];

		// Handling category
		if ((filter & categoryLauncher))
			filters.push('LAUNCHER');

		// Getting app list
		//apps = HanGee.packageManager.getApps(filters);
		apps = owaNEXT.packageManager.getApps(filters);

		if (paginable) {
			var index = 0;
			for (var i = (page - 1) * count; (i < apps.length) && (index < count); i++, index++) {
				var app = apps[i];

				// Whether icon exists or not
				var item = icons.get(index) || null;
				if (item) {
					if (item.app.packageName == app.packageName)
						continue;
				}

				icons.append({
					gridId: index,
					app: app,
					startApp: function() {
						owaNEXT.packageManager.startApp(app);
					}
				});
			}

			return;
		}

		// No need to do pagination
		for (var index in apps) {
			var app = apps[index];

			// Whether icon exists or not
			var item = icons.get(index) || null;
			if (item) {
				if (item.app.packageName == app.packageName)
					continue;
			}

			icons.append({
				gridId: index,
				app: app
			});
		}
	}
	
	Component.onCompleted: {

		// Using Internal API
		var component = Qt.createComponent('../Core.qml');
		owaNEXT = component.createObject(parent);
		owaNEXT.ready.connect(function() {

			// Package added
			owaNEXT.packageManager.packageAdded.connect(function() {
				updateApps();
			});

			// Package removed
			owaNEXT.packageManager.packageRemoved.connect(function(packageName) {

				for (var i = 0; i < icons.count; i++) {
					var item = icons.get(i) || null;
					if (!item)
						continue;

					if (item.app.packageName == packageName) {
						console.log(packageName);
						icons.remove(i);
						break;
					}
				}
			});

			updateApps();
		});

	}
}
