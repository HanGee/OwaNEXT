import QtQuick 2.0
import QtQuick.Controls 1.0
import 'OwaNEXT' 1.0

AppWindow {
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

	Dock {
		id: dock;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;
		height: parent.height * 0.15;
	}

	Desktops {
		id: desktops;
		//anchors.fill: parent;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.top: parent.top;
		anchors.bottom: dock.top;
	}
}

