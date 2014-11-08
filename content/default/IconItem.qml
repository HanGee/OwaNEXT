import QtQuick 2.3

Item {
	id: iconItem;

	property var app: null;
	property var keys: [];
	property alias item: iconObject;

	signal clicked(var mgr);
	signal pressAndHold(var mgr);
	signal released(var mgr);

	Item {
		id: iconObject;
		width: iconItem.width;
		height: iconItem.height;

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
			running: iconObject.state == 'movable'
			loops: Animation.Infinite;
		}

		transitions: [
			Transition {
				ParentAnimation {
					target: iconObject;

					NumberAnimation {
						properties: 'x,y,scale';
						duration: 400;
						easing.type: Easing.OutBack
					}
				}
			}
		]

		states: [
			State {
				name: 'picked';
				when: iconObject.Drag.active;

				PropertyChanges {
					target: label;
					visible: false;
				}

				ParentChange {
					target: iconObject;
					parent: homescreen;
					x: iconItem.x;
					y: iconItem.y;
					scale: 1.2;
				}
			},
			State {
				name: 'movable';
				when: appWindow.editing && !iconObject.Drag.active;
			}
		]
	}

	function startDrag() {
		iconObject.Drag.active = true;
		mouseArea.drag.target = iconObject;
	}

	function drop() {
		iconObject.Drag.drop();
		mouseArea.drag.target = null;
	}
}
