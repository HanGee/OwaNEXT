import QtQuick 2.0
import QtQuick.Controls 1.0
import "GridContainer"
import "../launcher.js" as HanGee

Item {
	id: gridContainer;
	property variant model: null;
	property bool layoutable: false;
	property var curItem: null;

	GridView {
		id: grid;
		interactive: false;
        anchors.fill: parent;
        cellWidth: width * 0.25;
        cellHeight: height * 0.22;
        model: parent.model;
		delegate: IconItem {}

		MouseArea {
			property int currentId: -1
			property int newIndex;
			property int index: grid.indexAt(mouseX, mouseY)

			id: loc
			anchors.fill: parent

			onClicked: {
                // Launch application
                var icon = icons.get(index);
                if (icon) {
                    HanGee.packageManager.startApp(icon.app);
                }
            }

			onPressAndHold: {
				var icon = icons.get(index);
				if (icon) {
					newIndex = index;
					currentId = icon.gridId;
				}

				gridContainer.layoutable = true;
				desktopView.interactive = false;

				// Disable effect on item
				if (curItem) {
					curItem.released();
					curItem = null;
				}
			}

			onPressed: {
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
				if (loc.currentId != -1 && index != -1 && index != newIndex) {
					icons.move(newIndex, index, 1);
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
