import QtQuick 2.3

Item {
	id: apps;

	property bool paginable: false;
	property int count: 6;
	property alias template: repeater.delegate;

	Repeater {
		id: repeater;
		model: AppList {
			filter: categoryLauncher;
			paginable: apps.paginable;
			count: apps.count;
		}
	}
}
