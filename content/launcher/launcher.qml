import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import QtQuick.Particles 2.0
import "modules"
import "modules/Effects"

ApplicationWindow {
	id: appWindow;
    color: 'black';
    visible: true;
//    width: 480
//    height: 800
	property var apps: [
/*
		[
            { appName: 'Fred' },
            { appName: 'Fred 2' },
            { appName: 'Fred 3' },
            { appName: 'Fred 4' },
            { appName: 'Fred 5' },
            { appName: 'Fred 6' }
		],
		[
            { appName: 'Fred' },
            { appName: 'Fred 2' },
            { appName: 'Fred 3' },
            { appName: 'Fred 4' },
            { appName: 'Fred 5' },
            { appName: 'Fred 6' }
		],
		[
            { appName: 'Fred' },
            { appName: 'Fred 2' },
            { appName: 'Fred 3' },
            { appName: 'Fred 4' },
            { appName: 'Fred 5' },
            { appName: 'Fred 6' }
		]
*/
    ];

    // Background
    Image {
        id: background;
        source: 'backgrounds/1.jpg';
        anchors.fill: parent;
		cache: true;
    }
/*
    FastBlur {
        anchors.fill: background;
        source: background;
        radius: 8;
		cached: true;
    }
*/
    Desktops {
        id: desktops;
        anchors.fill: parent;
    }

    Component.onCompleted: {
		// Getting applications
        var _apps = packageManager.getApps([ 'LAUNCHER' ]);

		// Create desktops and put apps
        var list = [];
        var i = 0;
        for (var index in _apps) {

            var app = _apps[index];
            list.push(app);

            i++;
            if (i == 16) {
                apps.push(list);
                list = [];
                i = 0;
            }
        }

        if (i < 16)
            apps.push(list);

        for (var index in apps) {

			desktops.addDesktop();
        }
    }
}
