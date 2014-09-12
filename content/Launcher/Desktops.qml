import QtQuick 2.3
import 'OwaNEXT' 1.0
import 'OwaNEXT/Component' 1.0

Item {

	OwaNEXT {
		id: owaNEXT;
	}

	Area {
		id: desktopTop;
		anchors.fill: parent;
		rows: 5;
		columns: 4

		onSubAreaOpened: {
			console.log('open', item.position);
			item.directory.open(this);
			item.directory.area.editing = true;

			this.state = 'openSubArea';
		}

		onSubAreaClosed: {

			this.state = '';
		}

		states: [
			State {
				name: 'openSubArea';

				PropertyChanges {
					target: desktopTop;
					scale: 2;
					opacity: 0;
				}
			},
			State {
				name: '';

				PropertyChanges {
					target: desktopTop;
					scale: 1;
					opacity: 1;
				}
			}
		]

		transitions: [
			Transition {
				PropertyAnimation {
					target: desktopTop;
					properties: 'scale'
					easing.type: Easing.OutBack;
					duration: 600;
				}

				PropertyAnimation {
					target: desktopTop;
					properties: 'opacity'
					easing.type: Easing.OutCubic;
					duration: 600;
				}
			}
		]
	}

	Item {
		id: subArea;
		anchors.fill: parent;
		opacity: 0;
		scale: 0;
		visible: false;
		z: 100;

		property var parentArea: null;

		MouseArea {
			anchors.fill: parent;

			onClicked: {
				subArea.state = 'close';
				subArea.parentArea.subAreaClosed();
			}
		}

		Rectangle {
			anchors.fill: parent;
			anchors.margins: 20;
			color: '#ee000000';
			radius: 10;

			Area {
				anchors.fill: parent;
				rows: 5;
				columns: 4
			}
		}

		onOpacityChanged: {
			if (opacity == 0)
				visible = false;
		}

		states: [
			State {
				name: 'open';

				PropertyChanges {
					target: subArea;
					opacity: 1;
					scale: 1;
					visible: true;
				}
			},
			State {
				name: 'close';

				PropertyChanges {
					target: subArea;
					scale: 0;
					opacity: 0;
				}
			}
		]

		transitions: [
			Transition {
				to: 'open';

				PropertyAnimation {
					target: subArea;
					properties: 'scale'
					easing.type: Easing.OutBack;
					duration: 400;
				}

				PropertyAnimation {
					target: subArea;
					properties: 'opacity'
					easing.type: Easing.OutBack;
					duration: 400;
				}
			},
			Transition {
				to: 'close';

				PropertyAnimation {
					target: subArea;
					properties: 'scale'
					easing.type: Easing.OutBack;
					duration: 400;
				}

				PropertyAnimation {
					target: subArea;
					properties: 'opacity'
					easing.type: Easing.OutBack;
					duration: 400;
				}
			}
		]

		function open(_parent) {
			parentArea = _parent;
			this.state = 'open';
		}

		function addItem(item) {
			parentArea.addItem(item);
		}
	}

	Repeater {
		model: AppList {
			filter: categoryLauncher;
			paginable: true;
			count: 6;
		}

		delegate: IconItem {
			Component.onCompleted: {
				desktopTop.addItem(this);
			}
		}
	}
}
