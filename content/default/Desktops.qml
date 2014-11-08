import QtQuick 2.3
import 'OwaNEXT/Component' 1.0

Item {
	id: desktops;

	IconArea {
		id: iconArea;
		anchors.fill: parent;

		Apps {
			paginable: true;
			count: 8;
			template: IconItem {
				width: iconArea.tileWidth;
				height: iconArea.tileHeight;
			}
		}
	}
}
