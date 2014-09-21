import QtQuick 2.0
import 'utils.js' as Utils

Item {
	id: core;
	signal ready;
	property bool initialized: false;
	property bool useSandbox: (typeof hangee == 'undefined') ? true : false;

	// APIs
	property Item packageManager: packageManager || null;

	Loader {
		id: sandbox;
		active: false;
		asynchronous: true;
		source: './sandbox/Sandbox.qml';
		onLoaded: {
			console.log('Initiailized Sandbox');
		}

		Connections {
			target: sandbox.item;

			onReady: {
				core.packageManager = sandbox.item.packageManager;
				core.initialized = true;
				core.ready();
			}
		}
	}

	Component.onCompleted: {

		// Initialized already
		if (Qt.application.OwaNEXT) {
			if (!Qt.application.OwaNEXT.core.initialized) {

				Qt.application.OwaNEXT.core.ready.connect(function() {
					core.packageManager = Qt.application.OwaNEXT.core.packageManager;
					core.useSandbox = Qt.application.OwaNEXT.core.useSandbox;
					core.initialized = true;
					core.ready();
				});
				return;
			}

			core.packageManager = Qt.application.OwaNEXT.core.packageManager;;
			core.useSandbox = Qt.application.OwaNEXT.core.useSandbox;
			core.initialized = true;

			Utils.setImmediate(function() {
				core.ready();
			});
			return;
		}

		Qt.application.OwaNEXT = {
			core: core
		};

		if (!useSandbox) {
			console.log('Enabled Real Mode');
			Utils.setImmediate(function() {
				core.ready();
			});
			return;
		}

		// Sandbox mode
		console.log('Enabled Sandbox Mode');
		sandbox.active = true;
	}
}
