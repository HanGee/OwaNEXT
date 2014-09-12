import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
	id: iconItem;
	Drag.active: false;
	Drag.hotSpot.x: Math.round(iconItem.width * 0.5);
	Drag.hotSpot.y: Math.round(iconLoader.item.height * 0.5);
	Drag.keys: [ 'iconItem' ];

	property var _parent: null;
	property var appInfo: null;
	property var type: 'icon';

	Loader {
		id: iconLoader;
		asynchronous: true;
		active: false;
		anchors.fill: parent;
		sourceComponent: Icon {
			id: icon;
			app: appInfo;

			onDragged: {
				iconItem.Drag.active = true;

				// Make item be able to be dragged
				drag.target = iconItem;

				console.log('Dragged');
			}

			onDropped: {
				iconItem.Drag.active = false;
				iconItem.Drag.drop();
				drag.target = null;
				console.log(iconItem.Drag.active);

				console.log('Dropped');
			}
		}
	}

	states: [
		State {
			when: _parent;

			ParentChange {
				target: iconItem;
				parent: _parent;
			}

			PropertyChanges {
				restoreEntryValues: false;
				parent: _parent;
			}

			StateChangeScript {
				script: {
					// clear;
					iconItem._parent = null;
				}
			}
		},
		State {
			when: iconItem.Drag.active;

			ParentChange {
				target: iconItem;
				parent: selection;
			}
		}
	]

	Behavior on x {
		enabled: !Drag.active
		NumberAnimation {
			duration: 400;
			easing.type: Easing.OutBack
			alwaysRunToEnd: true;
		}
	}

	Behavior on y {
		enabled: !Drag.active
		NumberAnimation {
			duration: 400;
			easing.type: Easing.OutBack
			alwaysRunToEnd: true;
		}
	}

	function reparent(_parent) {
		iconItem._parent = _parent;
	}

	Component.onCompleted: {

		if (iconItem.type == 'icon')
			iconLoader.active = true;
	}
}
