"use strict";

var _apps = [
	{
		appName: 'User',
		activityName: 'com.android.contacts.activities.PeopleActivity',
		packageName: 'com.android.contacts',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.contacts.png')
	},
	{
		appName: 'Phone',
		activityName: 'com.android.dialer.DialtactsActivity',
		packageName: 'com.android.dialer',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.dialer.png')
	},
	{
		appName: 'Message',
		activityName: 'com.android.mms.ui.ConversationList',
		packageName: 'com.android.mms',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.mms.png')
	},
	{
		appName: 'Settings',
		activityName: 'com.android.settings.Settings',
		packageName: 'com.android.settings',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.settings.png')
	},
	{
		appName: 'Calculator',
		activityName: 'com.android.calculator2.Calculator',
		packageName: 'com.android.calculator2',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.calculator2.png')
	},
	{
		appName: 'Clock',
		activityName: 'com.android.deskclock.DeskClock',
		packageName: 'com.android.deskclock',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.deskclock.png')
	},
	{
		appName: 'Gallery',
		activityName: 'com.android.camera.GalleryPicker',
		packageName: 'com.android.gallery',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.gallery.png')
	},
	{
		appName: 'Camera',
		activityName: 'com.android.camera.Camera',
		packageName: 'com.android.camera',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.camera.png')
	},
	{
		appName: 'Music',
		activityName: 'com.android.music.MusicBrowserActivity',
		packageName: 'com.android.music',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.music.png')
	},
	{
		appName: 'Download',
		activityName: 'com.android.providers.downloads.ui.DownloadList',
		packageName: 'com.android.providers.downloads.ui',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.providers.downloads.ui.png')
	},
	{
		appName: 'Document',
		activityName: 'com.android.document.DocumentActivity',
		packageName: 'com.android.document',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.document.png')
	},
	{
		appName: 'Display',
		activityName: 'com.android.display.DisplayActivity',
		packageName: 'com.android.display',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.display.png')
	},
	{
		appName: 'Wireless',
		activityName: 'com.android.wireless.WirelessActivity',
		packageName: 'com.android.wireless',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.wireless.png')
	},
	{
		appName: 'Speech Recorder',
		activityName: 'com.android.speechrecorder.SpeechRecorderActivity',
		packageName: 'com.android.speechrecorder',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.speechrecorder.png')
	},
	{
		appName: 'TV',
		activityName: 'com.android.television.TelevisionActivity',
		packageName: 'com.android.television',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.television.png')
	},
	{
		appName: 'Map',
		activityName: 'com.android.map.MapActivity',
		packageName: 'com.android.map',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/com.android.map.png')
	},
	{
		appName: 'OwaNEXT',
		activityName: 'org.hangee.system.packagemanager.PackageManager',
		packageName: 'org.hangee.app.launcher',
		iconPath: Qt.resolvedUrl('sandbox/PackageManager/icons/org.hangee.app.launcher.png')
	}
];

var PackageManager = function() {
	var this = self;

/*
	// Loading PackageManager
	self._object = null;
	self.component = Qt.createComponent('PackageManager/PackageManager.qml');
	if (component.status === Component.Ready) {
		self._object = self.component.createObject();
	}
*/
};

PackageManager.prototype.getApps = function() {
	return _apps;

//	return this._object.getApps();
};

PackageManager.prototype.startApp = function(app) {
	console.log('Starting ' + app.appName);
};

PacjageManager.prototype.onEvent = function(callback) {
};
