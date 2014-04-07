"use strict";

var _apps = [
	{ appName: 'Browser', activityName: 'com.android.browser.Browser', packageName: 'com.android.browser' },
	{ appName: 'Calculator', activityName: 'com.android.calculator.Calculator', packageName: 'com.android.calculator' },
	{ appName: 'Contact', activityName: 'com.android.contact.Contact', packageName: 'com.android.contact' },
	{ appName: 'Message', activityName: 'com.android.message.Message', packageName: 'com.android.message' },
	{ appName: 'Clock', activityName: 'com.android.clock.Clock', packageName: 'com.android.clock' }
];

var PackageManager = function() {
};

PackageManager.prototype.getApps = function() {
	return _apps;
};

PackageManager.prototype.startApp = function(app) {
};
