import QtQuick 2.2

Item {
	id: hanGee;
	signal ready;

	property Item packageManager;

	Loader {
		id: packageManagerLoader;
		source: './PackageManager/PackageManager.qml';
		asynchronous: true;
		onLoaded:{
			packageManager = packageManagerLoader.item;
		}
	}

	Connections {
		target: packageManagerLoader.item;

		onReady: {
			hanGee.ready();
		}
	}
}
