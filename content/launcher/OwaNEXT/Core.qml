import QtQuick 2.0

Item {
	id: core;
	signal ready;
	property bool useSandbox: (typeof hangee == 'undefined') ? true : false;

	// APIs
	property Item packageManager: packageManager || null;

	Loader {
		id: sandbox;
		onLoaded: {
			console.log('Initiailized Sandbox');
		}
	}

	Component.onCompleted: {

		if (!useSandbox) {
			core.ready();
			return;
		}

		// Sandbox mode
		console.log('Using OwaNEXT Sandbox Mode');
		sandbox.source = './sandbox/Sandbox.qml';
		sandbox.item.ready.connect(function() {
			core.packageManager = sandbox.item.packageManager;
			core.ready();
		});
	}
}
