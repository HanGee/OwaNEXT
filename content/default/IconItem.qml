import QtQuick 2.3

Item {
	id: iconItem;

	property var app: null;
	property var keys: [];

	signal clicked(var mgr);
	signal pressAndHold(var mgr);
	signal released(var mgr);

	Drag.active: mouseArea.drag.active;
	Drag.hotSpot.x: width >> 1;
	Drag.hotSpot.y: icon.height >> 1;
	Drag.keys: keys;

	Column {
		id: content;
		anchors.fill: parent;
		anchors.topMargin: parent.height * 0.1;
		anchors.leftMargin: parent.width >> 3;
		anchors.rightMargin: parent.width >> 3;

		Item {
			id: icon;
			anchors.left: parent.left;
			anchors.right: parent.right;
			height: iconImage.height;

			Image {
				id: iconImage;
				anchors.left: parent.left;
				anchors.right: parent.right;
				source: {
					if (app.iconPath)
						return app.iconPath;

					return '';
				}
				fillMode: Image.PreserveAspectFit;
				cache: true;
				asynchronous: true;
				smooth: true;

				MouseArea {
					id: mouseArea;
					anchors.fill: iconImage;

					onClicked: iconItem.clicked(this);
					onPressAndHold: iconItem.pressAndHold(this);
					onReleased: iconItem.released(this);
				}
			}
		}

		Text {
			id: label;
			anchors.left: parent.left;
			anchors.right: parent.right;
			horizontalAlignment: Text.AlignHCenter;
			font.pointSize: 9;
			color: '#ffffff';
			text: {
				if (app.appName)
					return app.appName;

				return '';
			}
			wrapMode: Text.WordWrap;
			maximumLineCount: 2;
			style: Text.Raised;
			styleColor: '#44000000';
//			visible: !iconOnly;
		}
	}

	SequentialAnimation on scale {
		NumberAnimation { to: 1.02; duration: 40 }
		NumberAnimation { to: 0.98; duration: 90 }
		NumberAnimation { to: 1.0; duration: 40 }
		running: iconItem.state == 'movable'
		loops: Animation.Infinite;
	}

	transitions: [
		Transition {
			to: 'picked';

			PropertyAnimation {
				target: iconItem;
				properties: 'scale';
				duration: 300;
				easing.type: Easing.OutBack
				alwaysRunToEnd: true;
			}
		},
		Transition {
			from: 'picked';

			PropertyAnimation {
				target: iconItem;
				properties: 'scale';
				duration: 300;
				easing.type: Easing.OutBack
				alwaysRunToEnd: true;
			}

			PropertyAnimation {
				target: iconItem;
				properties: 'x,y';
				duration: 400;
				easing.type: Easing.OutBack
				alwaysRunToEnd: true;
			}
		}
	]

	states: [
		State {
			name: 'picked';
			when: iconItem.Drag.active;

			PropertyChanges {
				target: iconItem;
				scale: 1.2;
			}

			PropertyChanges {
				target: label;
				visible: false;
			}
		},
		State {
			name: 'movable';
			when: appWindow.editing && !iconItem.picked;
		}
	]
}
