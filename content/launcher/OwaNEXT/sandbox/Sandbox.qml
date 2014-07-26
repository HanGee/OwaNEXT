import QtQuick 2.2
import './PackageManager'

Item {
	id: hanGee;
	signal ready;

	property alias packageManager: packageManager;

	PackageManager {
		id: packageManager;
	}

	Connections {
		target: packageManager;

		onReady: {
			hanGee.ready();
		}
	}
}
