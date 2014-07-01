"use strict";

var component = Qt.createComponent("../sandbox/PackageManager.qml");
console.log(component.errorString());
if (component.status === Component.Ready)
{
    console.log("create object");
    var packageManager = component.createObject();
    packageManager.getApps();
}

