import QtQuick 2.3
import 'OwaNEXT/Component' 1.0

Item {
	id: iconArea;
	property var model: null;
	property alias keys: dropArea.keys;
	property string placeName: 'desktop';
	property int columns: 4;
	property int rows: 5;
	property int tileWidth: iconArea.width / columns;
	property int tileHeight: iconArea.height / rows;

	DropArea {
		id: dropArea;
		anchors.fill: parent;

		GridView {
			id: tileContainer;
			anchors.fill: parent;
			cellWidth: tileWidth;
			cellHeight: tileHeight;
			model: {
				if (iconArea.model) {
					return iconArea.model.parts[iconArea.placeName];
				}

				return undefined;
			}

			moveDisplaced: Transition {
				NumberAnimation {
					properties: 'x,y';
					duration: 400;
					easing.type: Easing.OutBack;
				}
			}
		}

		onEntered: {
			// Change icon area
			drag.source.ref.placeChanged(placeName);
		}

		onPositionChanged: {
			console.log(11111);
		}
	}

	function indexAt(x, y) {
		var index = tileContainer.indexAt(x, y);
		if (index < 0 || index >= tileContainer.count)
			return -1;

		return index;
	}
}
