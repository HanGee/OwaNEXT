import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import '../owanext/PackageManager'

Item {
	id: desktop;
	property int page: desktopId + 1;

	width: desktopView.width;
	height: desktopView.height;

	GridContainer {
		id: gridContainer;
		anchors.fill: parent;
		anchors.margins: 2;

		model: AppList {
			paginable: true;
			count: 16;
			page: desktop.page;
			filter: categoryLauncher;
		}
	}

	signal blur();

	onBlur: gridContainer.blur();

	Component.onCompleted: {

		desktops.initialized = true;
	}
}
