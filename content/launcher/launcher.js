"use strict";

var isSandbox = (typeof(hangee) == "undefined");
if (isSandbox)
{
    Qt.include('../sandbox/sandbox.js');
}
else
{
    var packageManager = hangee.packageManager;
}
