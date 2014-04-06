import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0

Item {
	width: desktopView.width;
	height: desktopView.height;

	GridContainer {
		id: gridContainer;
		anchors.fill: parent;
		model: icons;

		ListModel {
			id: icons;
		}
	}

	signal blur();

	onBlur: gridContainer.blur();

	Component.onCompleted: {

		var desktopApps = apps[desktopId];
		for (var index in desktopApps) {
			var app = desktopApps[index];

			icons.append({
				gridId: index,
                icon: '../../Images/widget' + (parseInt(index) + 1) + '.png',
                label: app.appName,
                initialized: desktops.initialized,
                app: app
            });
		}

		desktops.initialized = true;
	}
}
