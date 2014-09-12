import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import 'OwaNEXT/Component' 1.0

Item {
	id: desktop;
	property int page: desktopId + 1;

	width: desktopView.width;
	height: desktopView.height;

	GridContainer {
		id: gridContainer;
		anchors.fill: parent;

		model: iconModel.parts['desktop.' + desktopId]
/*
		model: AppList {
			paginable: true;
			count: 20;
			page: desktop.page;
			filter: categoryLauncher;
		}
*/
	}

	// Pagination panel
	Item {
		anchors.fill: parent;
		visible: gridContainer.editing;

		Rectangle {
			color: '#ffffff';
			opacity: 0.15;
			width: parent.width * 0.10;
			radius: width * 0.5;
			scale: 0;
			anchors.left: parent.left;
			anchors.top: parent.top;
			anchors.bottom: parent.bottom;
			anchors.margins: 10;

			SequentialAnimation on scale {
				NumberAnimation {
					from: 0;
					to: 1;
					duration: 200;
					easing.type: Easing.OutQuad;
				}
				running: gridContainer.editing;
				alwaysRunToEnd: true;
			}

			SequentialAnimation on scale {
				NumberAnimation {
					from: 1;
					to: 0;
					duration: 200;
					easing.type: Easing.OutQuad;
				}
				running: !gridContainer.editing;
				alwaysRunToEnd: true;
			}

			DropArea {
				anchors.fill: parent;

				onEntered: {
					console.log('LLLLLLLLL 0');
				}

				onPositionChanged: {
					if (desktopId > 0)
						desktopView.currentIndex = desktopId - 1;
//					console.log('LLLLLLLLL');
				}
			}
		}

		Rectangle {
			color: '#ffffff';
			opacity: 0.15;
			width: parent.width * 0.10;
			radius: width * 0.5;
			scale: 0;
			anchors.right: parent.right;
			anchors.top: parent.top;
			anchors.bottom: parent.bottom;
			anchors.margins: 10;

			SequentialAnimation on scale {
				NumberAnimation {
					from: 0;
					to: 1;
					duration: 200;
					easing.type: Easing.OutQuad;
				}
				running: gridContainer.editing;
				alwaysRunToEnd: true;
			}

			SequentialAnimation on scale {
				NumberAnimation {
					from: 1;
					to: 0;
					duration: 200;
					easing.type: Easing.OutQuad;
				}
				running: !gridContainer.editing;
				alwaysRunToEnd: true;
			}

			DropArea {
				anchors.fill: parent;

				onEntered: {
					console.log('RRRRRRRRR 0');
				}

				onPositionChanged: {
					if (desktopId < desktopView.count - 1)
						desktopView.currentIndex = desktopId + 1;

//					console.log('RRRRRRRRR');
				}
			}
		}

	}

	signal blur();

	onBlur: gridContainer.blur();

	Component.onCompleted: {

		desktops.initialized = true;
	}
}
