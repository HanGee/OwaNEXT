import QtQuick 2.0
import QtQuick.Controls 1.0
import 'OwaNEXT' 1.0

Item {
	id: gridContainer;
	property alias mouseArea: mouseArea;
	property alias dropArea: dropArea;
	property var model: null;
	property bool layoutable: false;
	property bool editing: false;

	OwaNEXT {
		id: owaNEXT;
	}

	GridView {
		id: grid;
		anchors.fill: parent;
		anchors.leftMargin: parent.width * 0.05;
		anchors.rightMargin: parent.width * 0.05;
		cellWidth: width * 0.25;
		cellHeight: height * 0.20;
		interactive: false;
		model: parent.model;
		//delegate: IconItem {}

		MouseArea {
			id: mouseArea;
			anchors.fill: parent;
			hoverEnabled: true;
		}

		DropArea {
			id: dropArea;
			anchors.fill: parent;
			anchors.leftMargin: parent.width * 0.15;
			anchors.rightMargin: parent.width * 0.15;
			property var curItem: null;
			property var curItemId: -1;

			onEntered: {
				curItem = null;

				// Exists already in this page
				for (var i = 0; i < model.count; i++) {
					var element = model.get(i);
					if (!element)
						continue;

					if (model.get(i).app.packageName == drag.source.packageName) {
						console.log('EXISTS');
						curItemId = i;
						curItem = drag.source;
						break;
					}
				}
/*
				// A new item is coming
				if (!curItem) {
					model.append({
						app: drag.source.main.elementInfo.app,
						owaNEXT: drag.source.main.elementInfo.owaNEXT
					});
					curItem = drag.source;
					curItemId = model.count - 1;
					curItem = model.get(curItemId);

					// Remove from old place
					drag.source.curParent.removeItem(drag.source);
					console.log('New Item');
				}
*/
				// Change parent to this container
				//drag.source.setContainer(gridContainer);

				// Switch to layouting mode
				editing = true;
				gridContainer.layoutable = true;
				desktopView.interactive = false;
			}
	/*
			onExited: {
				// Item was moved out, we need to remove empty place.
				//model.remove(curItemId);

				editing = false;
				desktopView.interactive = true;
			}
	*/
			onDropped: {
				editing = false;
				desktopView.interactive = true;
				console.log('F', drag.source.x, drag.source.y);
			}

			onPositionChanged: {
				console.log('DDDDD', drag.x, drag.y);

				// Moving in the same page
				for (var i = 0; i < model.count; i++) {
					var element = model.get(i);
					if (!element)
						continue;

					if (model.get(i).app.packageName == drag.source.packageName) {
						// Calculate mouse position
						var index = grid.indexAt(drag.x, drag.y);

						if (i != index && index != -1) {
							console.log('FROM ' + i + ' TO ' + index);
							model.move(i, index, 1);
							curItemId = index;
						}

						break;
					}
				}
			}
		}
	}

	signal blur;

	onBlur: {
	}

	function removeItem(item) {
		if (!model)
			return;

		for (var i = 0; i < model.count; i++) {
			var element = model.get(i);
			if (!element)
				continue;

			if (model.get(i).app.packageName == item.packageName) {
				model.remove(i);
				break;
			}
		}
	}
}
