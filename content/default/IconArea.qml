import QtQuick 2.3

Item {
	id: iconArea;

	default property alias children: tileContainer.children;
	property int iconSize: 4;
	property int tileWidth: iconArea.width / tileContainer.columns;
	property int tileHeight: iconArea.height / tileContainer.rows;

	DropArea {
		anchors.fill: parent;

		Grid {
			id: tileContainer;
			anchors.fill: parent;
			columns: 4;
			rows: 5;
			horizontalItemAlignment: Grid.AlignHCenter;
		}
	}
}
