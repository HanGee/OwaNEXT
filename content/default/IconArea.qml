import QtQuick 2.3
import 'OwaNEXT/Component' 1.0

Item {
	id: iconArea;

	DropArea {
		anchors.fill: parent;

		Apps {
			paginable: true;
			count: 6;
			template: IconItem {
			}
		}
	}
}
