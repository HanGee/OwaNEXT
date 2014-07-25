import QtQuick 2.0
import QtGraphicalEffects 1.0
 
Item {
	id: main
	width: grid.cellWidth;
	height: grid.cellHeight;

	property int padding: 3;

	Item {
		id: item;
		parent: loc;
		x: main.x;
		y: main.y;
		anchors.fill: main;

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
					font.pointSize: 10;
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

				Rectangle {
					id: active_layer;
					anchors.fill: parent;
					color: 'transparent';
					radius: 5;
					visible: item.state == 'active'
				}
			}
		}

		Behavior on x {
			enabled: (item.state != 'active' && gridContainer.layoutable);
			NumberAnimation {
				duration: 400;
				easing.type: Easing.OutBack
			}
		}

		Behavior on y {
			enabled: (item.state != 'active' && gridContainer.layoutable);
			NumberAnimation {
				duration: 400;
				easing.type: Easing.OutBack
			}
		}

		SequentialAnimation on rotation {
			NumberAnimation { to:  2; duration: 50 }
			NumberAnimation { to: -2; duration: 90 }
			NumberAnimation { to:  0; duration: 50 }
			running: loc.currentId != -1 && item.state != 'active'
			loops: Animation.Infinite;
			alwaysRunToEnd: true;
		}

		states: State {
			name: 'active'; when: loc.currentId == gridId
			PropertyChanges {
				target: item;
				x: loc.mouseX - (itemIcon.width >> 1);
				y: loc.mouseY - (itemIcon.height >> 1);
				scale: 1.5;
				z: 10
			}
		}

		transitions: Transition {
			NumberAnimation {
				property: 'scale';
				duration: 100;
				easing.type: Easing.OutQuad;
			}
		}

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
	}

	GridView.onAdd: {
		if (!initialized)
			addedEffect.running = true;
	}

	signal pressed();
	signal released();

	onPressed: {
		itemIcon.opacity = 0.5;
		itemGlow.spread = 0.6;
		itemGlow.color = '#cceefff5';
	}

	onReleased: {
		itemIcon.opacity = 1;
		itemGlow.spread = 0.5;
		itemGlow.color = '#55000000';
	}
}
