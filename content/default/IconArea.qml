import QtQuick 2.3

Item {
	id: iconArea;

	property alias model: tileContainer.model;
	property alias delegate: tileContainer.delegate;
	property int iconSize: 4;
	property int tileWidth: iconArea.width / tileContainer.columns;
	property int tileHeight: iconArea.height / tileContainer.rows;
	property alias keys: dropArea.keys;

	DropArea {
		id: dropArea;
		anchors.fill: parent;

		GridView {
			id: tileContainer;
			anchors.fill: parent;
			cellWidth: tileWidth;
			cellHeight: tileHeight;

			property int columns: 4;
			property int rows: 5;

			moveDisplaced: Transition {
				NumberAnimation {
					properties: 'x,y';
					duration: 400;
					easing.type: Easing.OutBack;
				}
			}
		}
	}

	function indexAt(x, y) {
		var index = tileContainer.indexAt(x, y);
		if (index < 0 || index >= tileContainer.count)
			return -1;

		return index;
	}
}
