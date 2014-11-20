import QtQuick 2.3
import QtQml.Models 2.1

Item {

	property var places: [];
	property var models: {
		return {};
	}

	AppList {
		id: appList;
		filter: categoryLauncher;
		paginable: false;

		onReady: {
			for (var index = 0; index < applist.count; index++) {
				var item = template.createObject(apps.parent, {
					app: applist.apps[index]
				});

			}
		}
	}

	Component.onCompleted: {
	}
}
