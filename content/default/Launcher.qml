import QtQuick 2.0
import 'OwaNEXT' 1.0

AppWindow {
	visible: true;
	width: 320;
	height: 640;
	color: 'black';

	OwaNEXT {
		id: owaNEXT;

		onReady: {
			console.log('READY');
		}
	}

	Splash {
		id: splash;
		anchors.fill: parent;
		opacity: 0;
		visible: (!opacity) ? false : true;

		// Only show 10 seconds
		Timer {
			interval: 8000;
			running: true;

			onTriggered: {
				splash.opacity = 0;
			}
		}

		Behavior on opacity {
			NumberAnimation {
				duration: 800;
				easing.type: Easing.OutCubic;
			}
		}
	}

	Item {
		id: homescreen;
		visible: false;
		anchors.fill: parent;

		Dock {
			id: dock;
			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.bottom: parent.bottom;
			height: parent.height * 0.15;
		}

		Desktops {
			id: desktops;
			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.top: parent.top;
			anchors.bottom: dock.top;
		}

		states: [
			State {
				when: !splash.visible;

				PropertyChanges {
					target: homescreen;
					visible: true;
				}
			}
		]
	}
}

