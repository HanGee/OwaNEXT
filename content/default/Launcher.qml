import QtQuick 2.0
import 'OwaNEXT' 1.0
import 'OwaNEXT/Component' 1.0

AppWindow {
	id: appWindow;
	visible: true;
	width: 320;
	height: 640;
	color: 'black';

	property bool editing: false;

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

		property int iconWidth: width / 4;
		property int iconHeight: height / 5;

		AppIcons {
			id: appIcons;
			places: [
				'desktop',
				'dock'
			];

			template: IconItem {
				width: homescreen.iconWidth;
				height: homescreen.iconHeight;
				keys: [ 'IconItem' ]

				onClicked: {
					owaNEXT.packageManager.startApp(app);
				}

				onPressAndHold: {
					appWindow.editing = true;

					// Start dragging
					this.startDrag();
				}

				onReleased: {
					appWindow.editing = false;

					// Stop dragging
					this.drop();
				}
			}

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

	Item {
		id: clipboard;
		anchors.fill: parent;
	}
}

