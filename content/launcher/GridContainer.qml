import QtQuick 2.0
import QtQuick.Controls 1.0
import 'OwaNEXT' 1.0

Item {
	id: gridContainer;
	property variant model: null;
	property bool layoutable: false;
	property var curItem: null;
	property Item owaNEXT;

	OwaNEXT {
		id: owaNEXT;
	}

	GridView {
		id: grid;
		interactive: false;
		anchors.fill: parent;
		cellWidth: width * 0.25;
		cellHeight: height * 0.25;
		model: parent.model;
		delegate: IconItem {}

		MouseArea {
			property int currentId: -1
			property int newIndex;
			property int index: grid.indexAt(mouseX, mouseY)

			id: loc
			anchors.fill: parent
			propagateComposedEvents: true;

			onClicked: {
				// Launch application
				var icon = model.get(index);
				if (icon) {
					owaNEXT.packageManager.startApp(icon.app);
				}
			}

			onPressAndHold: {
				// Pick up icon
				var icon = model.get(index);
				if (icon) {
					newIndex = index;
					currentId = icon.gridId;
				}

				// Switch to layouting mode
				gridContainer.layoutable = true;
				desktopView.interactive = false;

				// Disable effect on item
				if (curItem) {
					curItem.released();
					curItem = null;
				}

				mouse.accepted = false;
			}

			onPressed: {
				// Pick up icon
				curItem = grid.itemAt(mouseX, mouseY);
				if (curItem)
					curItem.pressed();
			}

			onReleased: {
				currentId = -1;
				desktopView.interactive = true;

				// Disable effect on item
				if (curItem) {
					curItem.released();
					curItem = null;
				}
			}

			onExited: {
				gridContainer.blur();
			}

			onPositionChanged: {

				// Re-layout icons
				if (loc.currentId != -1 && index != -1 && index != newIndex) {
					model.move(newIndex, index, 1);
					newIndex = index;
				}
			}
		}

	}

	signal blur;

	onBlur: {

		// Disable effect on item
		if (curItem) {
			curItem.released();
			curItem = null;
		}
	}
}
