import QtQuick 2.3

Item {
	id: apps;

	property bool paginable: false;
	property int count: 6;
	property Component template: Item {}

	AppList {
		id: applist;
		filter: categoryLauncher;
		paginable: apps.paginable;
		count: apps.count;

		onReady: {
			for (var index = 0; index < applist.count; index++) {
				var item = template.createObject(apps.parent, {
					app: applist.apps[index]
				});

			}
		}
	}
}
