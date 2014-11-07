import QtQuick 2.3
import 'OwaNEXT/Component' 1.0

Item {
	id: iconArea;

	DropArea {
		anchors.fill: parent;

		Grid {
			id: tileContainer;
			anchors.fill: parent;
			columns: 4;
			rows: 5;
			horizontalItemAlignment: Grid.AlignHCenter;

			property int tileWidth: iconArea.width / columns;
			property int tileHeight: iconArea.height / rows;

			Apps {
				paginable: true;
				count: 6;
				template: IconItem {
					width: tileContainer.tileWidth;
					height: tileContainer.tileHeight;
				}
			}

		}
	}
}
