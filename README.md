OwaNEXT
=======

OwaNEXT is next generation UI framework for HanGee project in order to make UI and create better user experience, it provides an easy way to build UI without knowing a lot of programming skills.


How to run example
---
OwaNEXT has an example application launcher to show how it work, you can found it in the directory `content/launcher`. The normal way of running launcher is to use QtCreator to open OwaNEXT project for building APK for Android.


Development with sandbox
---
Running application with OwaNEXT is not quite easy, it's always taking a lot time to build and deploy on Android. We must have mechanism to reduce testing time during development of application. Sandbox feature was made for solving this problem and making developer work more efficiently.

If you wanna run launcher in sandbox mode, taking off a line in launcher.qml:
```
import "launcher.js" as HanGee
```

Then adding a new line:
```
import "../sandbox/sandbox.js" as HanGee
```

Run it with qml viewer:
```
qml launcher.qml
```
