import QtQuick 2

Item {
	id: subArea;
	anchors.fill: parent;
	opacity: 0;
	scale: 0;
	visible: false;
	z: 100;

	property alias area: area;
	property var parentArea: null;
	signal dropAreaExited(Item source);
	signal closed(Item area);

	MouseArea {
		anchors.fill: parent;

		onClicked: {
			close();
		}
	}

	DropArea {
		anchors.fill: parent;
		keys: [ 'iconItem' ];
		onEntered: {
			subArea.area.dropAreaExited(drag.source);
			subArea.dropAreaExited(drag.source);
		}
	}

	Rectangle {
		anchors.fill: parent;
		anchors.margins: parent.width * 0.05;
		color: '#ee000000';
		radius: 10;

		Area {
			id: area;
			anchors.fill: parent;
			rows: 5;
			columns: 4
			iconOnly: true;
		}
	}

	onOpacityChanged: {
		if (opacity == 0)
			visible = false;
	}

	states: [
		State {
			name: 'open';

			PropertyChanges {
				target: subArea;
				opacity: 1;
				scale: 1;
				visible: true;
			}
		},
		State {
			name: 'close';

			PropertyChanges {
				target: subArea;
				scale: 0;
				opacity: 0;
				visible: true;
			}

			StateChangeScript {
				script: {
					// Fire event
					subArea.closed(subArea);
				}
			}
		}
	]

	transitions: [
		Transition {
			to: 'open';

			PropertyAnimation {
				target: subArea;
				properties: 'scale'
				easing.type: Easing.OutBack;
				duration: 400;
			}

			PropertyAnimation {
				target: subArea;
				properties: 'opacity'
				easing.type: Easing.OutBack;
				duration: 400;
			}
		},
		Transition {
			to: 'close';

			PropertyAnimation {
				target: subArea;
				properties: 'scale'
				easing.type: Easing.OutBack;
				duration: 400;
			}

			PropertyAnimation {
				target: subArea;
				properties: 'opacity'
				easing.type: Easing.OutBack;
				duration: 400;
			}
		}
	]

	function open(_parent) {
		parentArea = _parent;
		subArea.state = 'open';
	}

	function close() {
		subArea.state = 'close';
	}

	function addItem(item) {
		parentArea.addItem(item);
	}
}
