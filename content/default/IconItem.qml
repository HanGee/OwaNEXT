import QtQuick 2.3

Item {

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
}
