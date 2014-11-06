import QtQuick 2.0

Item {
	id: area;
	property int columns: 3;
	property int rows: 2;
	property int cellWidth: width / columns;
	property int cellHeight: height / rows;
	property bool editing: false;
	property var itemMap: {
		return {};
	}
	property var containers: [];
	property var items: [];

	GridView {
		id: gridLayout;
		anchors.fill: parent;
		cellWidth: area.cellWidth;
		cellHeight: area.cellHeight;

		model: area.columns * area.rows;
		delegate: Item {
			id: container;
			width: gridLayout.cellWidth;
			height: gridLayout.cellHeight;

			Rectangle {
				anchors.fill: parent;
				anchors.margins: 1;
				color: 'white';
				opacity: 0.2;
			}

			Component.onCompleted: {
				itemMap[area.containers.length] = false;
				area.containers.push(this);
			}
		}
	}

	DropArea {
		anchors.fill: parent;
		keys: [ 'iconItem' ];

		onEntered: {
			console.log('ENTERED');
			if (drag.source.parent != area)
				addItem(drag.source);
			//console.log(drag.source);
		}

		onDropped: {
			console.log("DROPPPPPPPPPPED");
		}
	}

	function addItem(item, index) {

		var _index = (index == null) ? items.length : index;
		var itemObj = {
			position: _index,
			obj: item
		};
		items.push(itemObj);

		item.reparent(area);
		item.width = Qt.binding(function() { return area.cellWidth; });
		item.height = Qt.binding(function() { return area.cellHeight; });
		item.x = Qt.binding(function() { return area.containers[itemObj.position].x; });
		item.y = Qt.binding(function() { return area.containers[itemObj.position].y; });
	}

}
