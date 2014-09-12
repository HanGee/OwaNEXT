import QtQuick 2.0
import QtGraphicalEffects 1.0
 
Item {
	id: main
	width: grid.cellWidth;
	height: grid.cellHeight;

	property var elementInfo;
	property int padding: 1;
	property bool picked: false;

	Item {
		id: item;
		property alias main: main;
		property alias iconItem: itemIcon;
		property Item curParent: gridContainer;
		property var packageName: app.packageName;
		parent: curParent.mouseArea;
		x: main.x;
		y: main.y;
		anchors.fill: main;

		Drag.active: dragArea.drag.active;
		Drag.hotSpot.x: itemIcon.center.x;
		Drag.hotSpot.y: itemIcon.center.y;

		Item {
			id: image;
			anchors.fill: item;

			Item {
				id: itemCaption;
				height: iconLabel.font.pixelSize * 3;
				anchors.left: image.left;
				anchors.right: image.right;
				anchors.bottom: image.bottom;

				Text {
					id: iconLabel;
					anchors.fill: itemCaption;
					horizontalAlignment: Text.AlignHCenter;
					font.pointSize: 9;
					color: 'white';
					text: app.appName;
					visible: item.state != 'active'
					wrapMode: Text.WordWrap;
					maximumLineCount: 2;
					style: Text.Raised;
					styleColor: '#44000000';
				}
			}

			Image {
				id: itemIcon;
				anchors.margins: padding;
				anchors.top: image.top;
				anchors.bottom: itemCaption.top;
				anchors.left: image.left;
				anchors.right: image.right;
				fillMode: Image.PreserveAspectFit;
				source: app.iconPath;
				cache: true;
				asynchronous: true;
				smooth: true;

				// Center position of icon of item
				property Item center: Item {
					x: (itemIcon.width >> 1) * item.scale * 0.6;
					y: (itemIcon.height >> 1) * item.scale * 0.6;
				}

				MouseArea {
					id: dragArea
					anchors.fill: parent

					onPressed: {
						console.log('PRESS');

						item.focus = true;
					}

					onClicked: {
						item.focus = false;
						owaNEXT.packageManager.startApp(app);
					}

					onPressAndHold: {
						// Switch to edit mode
						item.curParent.editing = true;

						// Make item be able to drag
						drag.target = item;

						picked = true;

						console.log('M', item.curParent.mouseArea.mouseX, item.curParent.mouseArea.mouseY);
						console.log('D', item.curParent.dropArea.drag.x, item.curParent.dropArea.drag.y);
					}

					onReleased: {
						picked = false;
						item.focus = false;
						drag.target = null;
						item.Drag.drop();
						console.log('DROP');

						// Disable edit mode
						item.curParent.editing = false;
					}

					onCanceled: {
						// Canceled by other events  
						item.focus = false;
					}
				}
			}
		}

		Behavior on x {
			enabled: !picked && gridContainer.layoutable;
			NumberAnimation {
				duration: 400;
				easing.type: Easing.OutBack
				alwaysRunToEnd: true;
			}
		}

		Behavior on y {
			enabled: !picked && gridContainer.layoutable;
			NumberAnimation {
				duration: 400;
				easing.type: Easing.OutBack
				alwaysRunToEnd: true;
			}
		}

		// Back to normal size
		SequentialAnimation on scale {
			NumberAnimation { to: 1; duration: 50 }
			running: !item.curParent.editing && item.state != 'active'
		}

		SequentialAnimation on scale {
			NumberAnimation { to: 1.02; duration: 50 }
			NumberAnimation { to: 0.98; duration: 90 }
			NumberAnimation { to: 1.0; duration: 50 }
			running: item.curParent.editing && item.state != 'active'
			loops: Animation.Infinite;
		}
/*
		SequentialAnimation on scale {
			NumberAnimation { to: 1; duration: 50 }
			running: !item.curParent.editing
			loops: Animation.Infinite;
			//alwaysRunToEnd: true;
		}
*/
/*
		SequentialAnimation on rotation {
			NumberAnimation { to:  2; duration: 50 }
			NumberAnimation { to: -2; duration: 90 }
			NumberAnimation { to:  0; duration: 50 }
			running: item.curParent.editing && item.state != 'active'
			loops: Animation.Infinite;
			alwaysRunToEnd: true;
		}
*/
		states: [
			State {
				name: 'normal'; when: !item.focus && !picked

				PropertyChanges {
					target: item;
					x: main.x;
					y: main.y;
					z: 0;
				}

				PropertyChanges {
					target: itemGlow;
					spread: 0.5;
					color: '#55000000';
				}
			},
			State {
				name: 'active'; when: picked
				PropertyChanges {
					target: item;
					x: item.curParent.mouseArea.mouseX - itemIcon.center.x;
					y: item.curParent.mouseArea.mouseY - itemIcon.center.y;
					scale: 1.5;
					z: 1;
				}
			},
			State {
				name: 'focus'; when: item.focus
				PropertyChanges {
					target: itemIcon;
					opacity: 0.5;
				}

				PropertyChanges {
					target: itemGlow;
					spread: 0.6;
					color: '#cceefff5';
				}
			}
		]

		transitions: [
			Transition {
				NumberAnimation {
					property: 'scale';
					duration: 100;
				}
			}
		]

		Glow {
			id: itemGlow;
			anchors.fill: image;
			source: image;
			radius: 4;
			samples: 8;
			color: '#55000000';
			cached: true;
		}

		NumberAnimation {
			target: item;
			id: addedEffect;
			property: 'scale';
			from: 0;
			to: 1;
			duration: 500;
			easing.type: Easing.OutCubic;
		}

		function setContainer(container) {

			// Do nothing if no need to change parent
			if (item.curParent == container)
				return;

			item.curParent = container;
			main.state = 'reparent';
			main.state = 'normal';
			console.log('REPARENT');
		}
	}

	states: [
		State {
			name: 'normal';
		},
		State {
			name: 'reparent';

			ParentChange {
				target: item;
				parent: item.curParent.mouseArea;
			}
		}
	]

	GridView.onAdd: {
		if (!initialized)
			addedEffect.running = true;
	}

	Component.onCompleted: {
		elementInfo = {
			app: app,
			owaNEXT: owaNEXT
		};
	}
}
