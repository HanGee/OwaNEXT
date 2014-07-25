import QtQuick 2.0
import QtQuick.Controls 1.0
import 'owanext/hangee.js' as HanGee
import 'owanext/PackageManager'
import 'components'

ApplicationWindow {
	visible: true;
	width: 320;
	height: 480;
	color: 'black';

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

	Connections {
		target: HanGee.core;

		onReady: {
			console.log('HanGee Ready');
			desktops.count = Math.ceil(HanGee.packageManager.getApps([ 'LAUNCHER' ]).length / 16);
		}
	}
}

