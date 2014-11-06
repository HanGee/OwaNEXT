import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.2
import 'utils.js' as Utils

ApplicationWindow {
	id: window;

	toolBar: ToolBar {
		visible: (typeof hangee == 'undefined') ? true : false;
		height: window.height * 0.05
		style: ToolBarStyle {

			padding {
				left: 8
				right: 8
				top: 3
				bottom: 3
			}

			background: Rectangle {
				implicitWidth: 100
				implicitHeight: 40
				color: '#000';
				opacity: 0.2;
			}
		}

		Text {
			anchors.right: parent.right;
			color: '#4aa7d9';

			text: {
				var hour = String("00" + new Date().getHours()).slice(-2);
				var minute = String("00" + new Date().getMinutes()).slice(-2);
				return hour + ':' + minute;
			}
		}
	}
}
