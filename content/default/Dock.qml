import QtQuick 2.3

Item {
	id: dock;

	Rectangle {
		anchors.fill: parent;
		color: '#22ffffff';
	}

	IconArea {
		anchors.fill: parent;
		keys: [ 'IconItem' ]
		placeName: 'dock';
		model: appIcons;
		rows: 1;
	}
}
