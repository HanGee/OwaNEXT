import QtQuick 2.3
import 'OwaNEXT/Component' 1.0

Item {
	id: desktops;

	IconArea {
		id: iconArea;
		anchors.fill: parent;
		keys: [ 'IconItem' ]
		placeName: 'desktop';
		model: appIcons;
		/*
		model: AppList {
			paginable: true;
			count: 8;
		}
		*/
/*
		delegate: IconItem {
			width: iconArea.tileWidth;
			height: iconArea.tileHeight;
			keys: [ 'IconItem' ]

			onClicked: {
				owaNEXT.packageManager.startApp(app);
			}

			onPressAndHold: {
				appWindow.editing = true;

				// Start dragging
				this.startDrag();
			}

			onReleased: {
				appWindow.editing = false;

				// Stop dragging
				this.drop();
			}

			onSlippingRequested: {
				var from = iconArea.indexAt(source.x, source.y);
				var target = iconArea.indexAt(this.x, this.y);

				// Cannot figure out correct position
				if (from == -1 || target == -1)
					return;

				// No change
				if (from == target)
					return;

				iconArea.model.move(from, target, 1);
				var x = iconArea.model.get(target);
				console.log(x);
			}
		}
*/
	}
}
