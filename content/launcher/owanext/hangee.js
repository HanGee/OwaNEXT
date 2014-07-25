"use strict";

// Using sandbox if no native APIs was detected
if (typeof hangee == 'undefined') {
	//Qt.include('./sandbox/sandbox.js');
	var component = Qt.createComponent('./sandbox/sandbox.qml');
	if (component.status === Component.Ready) {
		var hangee = null;
		var core = hangee = component.createObject();
	}

	console.log(component.errorString());
}

var packageManager = hangee.packageManager;
