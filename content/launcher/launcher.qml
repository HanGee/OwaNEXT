import QtQuick 2.0
import QtQuick.Controls 1.0
import 'OwaNEXT' 1.0

ApplicationWindow {
	visible: true;
	width: 320;
	height: 480;
	color: 'black';

	OwaNEXT {
		id: owaNEXT;

		onReady: {
			console.log('READY');
			desktops.count = Math.ceil(owaNEXT.packageManager.getApps([ 'LAUNCHER' ]).length / 16);
			console.log(owaNEXT.packageManager.getApps([ 'LAUNCHER' ]).length);
		}
	}

	Image {
		anchors.fill: parent;
		source: 'images/background.jpg';
		cache: true;
		fillMode: Image.PreserveAspectCrop;
		smooth: true;
		asynchronous: true;
	}

	Desktops {
		id: desktops;
		anchors.fill: parent;
	}
}

