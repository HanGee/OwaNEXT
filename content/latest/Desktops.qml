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
/*
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
*/
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

	Repeater {
		model: AppList {
			filter: categoryLauncher;
			paginable: true;
			count: 6;
		}

		delegate: IconItem {
			appInfo: app;

			Component.onCompleted: {
				desktopTop.addItem(this);
			}
		}
	}
}
