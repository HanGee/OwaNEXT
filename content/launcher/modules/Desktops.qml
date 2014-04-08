import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0

Item {
	id: desktops;

	property variant model: null;
	property bool initialized: false;

	// Pagination on the bottom
	Item {
        id: paginationBar;
		anchors.bottom: desktopView.bottom;
		anchors.left: desktopView.left;
		anchors.right: desktopView.right;
		height: 50;

        ListView {
            id: pagination;
			orientation: ListView.Horizontal;
			anchors.horizontalCenter: paginationBar.horizontalCenter;
			interactive: false;
			focus: true;
            width: desktops.width * 0.1 * model.count;
            contentWidth: desktops.width * 0.1;
			highlightRangeMode: ListView.ApplyRange;
			snapMode: ListView.SnapToItem;
			model: ListModel {}
			delegate: Item {
                width: desktops.width * 0.1;
				height: paginationBar.height;

				Rectangle {
					color: 'white';
					width: parent.width * 0.3;
					height: width;
					radius: width * 0.5;
					anchors.centerIn: parent;
					opacity: 0.2;
				}
			}

			highlight: Item {
				y: pagination.currentItem.y;
				width: pagination.currentItem.width;
				height: width;

				Rectangle {
					id: paginationDot;
					width: parent.width * 0.3;
					height: width;
					radius: width * 0.5;
					anchors.centerIn: parent;
					color: 'white';
				}

				RectangularGlow {
					anchors.fill: paginationDot;
					glowRadius: 8;
					spread: 0.5;
					color: '#ffffffff';
					cached: true;
					cornerRadius: paginationDot.radius + glowRadius
				}
			}
		}
	}

	// Desktops for application icons
	ListView {
		id: desktopView;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.top: parent.top;
		anchors.bottom: parent.bottom;
		contentWidth: desktops.width;
		contentHeight: desktops.height;
		highlightRangeMode: ListView.StrictlyEnforceRange
		orientation: ListView.Horizontal;
		snapMode: ListView.SnapOneItem;
        cacheBuffer: desktopView.width * model.count;
		maximumFlickVelocity: desktopView.width * 6;
		flickDeceleration: maximumFlickVelocity * 0.6;
        model: ListModel {}
		delegate: Desktop {}

		onFlickStarted: {
			desktopView.currentItem.blur();
		}

		onMovementStarted: {
			desktopView.currentItem.blur();
		}

		onCurrentIndexChanged: {
			pagination.currentIndex = currentIndex;
		}
	}

	function addDesktop() {

		// Create a new desktop
		desktopView.model.append({
			desktopId: desktopView.model.count
		});

		// Add desktop to pagination
		pagination.model.append({
			desktopId: pagination.model.count
		})
	}
}
