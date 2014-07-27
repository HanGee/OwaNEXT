"use strict";

var setImmediate = function(fn) {

	var obj = Qt.createQmlObject('import QtQuick 2.0; Timer { running: false; }', Qt.application);
	obj.triggered.connect(function() {
		// Kill itself
		obj.destroy();
		fn();
	});
	obj.repeat = false;
	obj.interval = 10;
	obj.running = true;
};
