import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
	id: iconItem;
	scale: 0;
	Drag.active: mouseArea.drag.active;
	Drag.hotSpot.x: iconItem.width >> 1;
	Drag.hotSpot.y: icon.height >> 1;
	Drag.keys: [ 'iconItem' ];

	property bool iconOnly: false;
	property bool isIcon: true;
	property bool initialized: false;
	property bool dragging: false;
	property bool hovered: false;
	property int position: -1;
	property var area: null;
	property var container: Item {
	}
	property alias directory: directory;

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
			height: isIcon ? iconImage.height : iconDir.height;

			Rectangle {
				id: iconDir;
				anchors.left: parent.left;
				anchors.right: parent.right;
				height: width;
				enabled: !isIcon;
				visible: !isIcon;
				color: '#222222';
				radius: 10;

				Item {
					visible: false;
					Directory {
						id: directory;
						anchors.fill: parent;

						onDropAreaExited: {
							console.log('DDDDDDDD1');
							directory.close();
						}

						onClosed: {
							console.log('DDDDDDDD2');
							iconItem.area.subAreaClosed(iconItem);
						}
					}
				}
			}

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
				enabled: isIcon;
				visible: isIcon;

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
					hovered = false;

					if (isIcon) {
						owaNEXT.packageManager.startApp(app);
					} else {
						directory.open(iconItem.area);

						// Fire event to notice other component
						iconItem.area.subAreaOpened(iconItem);
					}
				}

				onPressed: {
					hovered = true;
				}

				onPressAndHold: {
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

			StateChangeScript {
				script: {
					console.log(isIcon, app.appName, iconItem.position);
				}
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

	Behavior on x {
		enabled: !dragging && initialized
		NumberAnimation {
			duration: 400;
			easing.type: Easing.OutBack
			alwaysRunToEnd: true;
		}
	}

	Behavior on y {
		enabled: !dragging && initialized
		NumberAnimation {
			duration: 400;
			easing.type: Easing.OutBack
			alwaysRunToEnd: true;
		}
	}

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

	onInitializedChanged: {
		if (initialized)
			scale = 1;
	}

	function isGap(x, y) {
		return !icon.childAt(x, y);
	}
}
