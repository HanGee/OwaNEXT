import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
	id: iconItem;
//	scale: 0;

	property var app: {}
	property bool iconOnly: false;

	signal dragged(var drag);
	signal dropped(var drag);

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

				BrightnessContrast {
					id: iconBrightness;
					anchors.fill: parent;
					source: icon;
					brightness: 0;
				}
			}

			MouseArea {
				id: mouseArea;
				anchors.fill: icon;

				onClicked: {
//					hovered = false;

					owaNEXT.packageManager.startApp(app);
				}

				onPressed: {
//					hovered = true;
				}

				onPressAndHold: {

					// Fire event
					iconItem.dragged(drag);

					return;

					// Make item be able to be dragged
					drag.target = iconItem;

					// Set dragging state and default position
					dragging = true;
					iconItem.x = (container.width - iconItem.width) * 0.5 + container.x;
					iconItem.y = container.y;

					// Set edit mode to desktop
					area.editing = true;

					selection.pick(iconItem);
				}

				onReleased: {
					iconItem.dropped(drag);
					return;

					hovered = false;

					// Leave edit mode
					area.editing = false;

					// Leave drag mode
					dragging = false;
					iconItem.Drag.drop();
					drag.target = null;
				}

				onCanceled: {
					hovered = false;
					dragging = false;
					area.editing = false;
					drag.target = null;
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
			visible: !iconOnly;
		}
	}
/*
	states: [
		State {
			name: 'reparent';

			ParentChange {
				target: iconItem;
				parent: area;
			}
		},
		// Workaround: Make dragged item to be on top
		State {
			when: area.editing && !hovered && !dragging;
			extend: 'reparent';

			PropertyChanges {
				target: iconItem;
				z: 0;
				x: (container.width - iconItem.width) * 0.5 + container.x;
				y: container.y;
			}
		},
		State {
			name: 'normal';
			when: !dragging && !hovered && (area != null);
			extend: 'reparent';

			PropertyChanges {
				target: iconItem;
				z: 0;
				x: (container.width - iconItem.width) * 0.5 + container.x;
				y: container.y;
			}
		},
		State {
			name: 'active';
			when: !dragging && hovered;
			extend: 'reparent';

			PropertyChanges {
				target: iconItem;
				z: 0;
				x: (container.width - iconItem.width) * 0.5 + container.x;
				y: container.y;
			}

			PropertyChanges {
				target: iconBrightness;
				brightness: -0.25;
			}

		},
		State {
			name: 'dragging';
			when: dragging;
			extend: 'reparent';

			PropertyChanges {
				target: label;
				visible: false;
			}

			PropertyChanges {
				target: iconItem;
				z: 1;
			}

		}
	]
*/
/*

	Behavior on width {
		enabled: dragging
		NumberAnimation {
			duration: 200;
			easing.type: Easing.OutBack
			alwaysRunToEnd: true;
		}
	}

	Behavior on height {
		enabled: dragging
		NumberAnimation {
			duration: 200;
			easing.type: Easing.OutBack
			alwaysRunToEnd: true;
		}
	}

	Behavior on scale {
		enabled: !initialized
		NumberAnimation {
			duration: 400;
			easing.type: Easing.OutBack
			alwaysRunToEnd: true;
		}
	}

	// Back to normal state
	SequentialAnimation on scale {
		NumberAnimation { to: 1; duration: 50 }
		running: area && !area.editing && iconItem.state != 'dragging'
	}

	SequentialAnimation on scale {
		NumberAnimation { to: 1.02; duration: 50 }
		NumberAnimation { to: 0.98; duration: 90 }
		NumberAnimation { to: 1.0; duration: 50 }
		running: area && area.editing && iconItem.state != 'dragging'
		loops: Animation.Infinite;
	}
*/
}
