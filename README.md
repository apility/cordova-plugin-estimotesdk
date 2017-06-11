# EstimoteSDK wrapper for Cordova

Adds a thin wrapper around Estimote's native iBeacon and Nearables SDK. This plugin supports iOS 8 or later, and Android 4.4 or later.

## Prerequisites

Requires CocoaPods for iOS support. This is a requirement, because we don't want to include the entire EstimoteSDK framework in the plugin.

```
sudo gem install cocoapods
pod setup
```

For Android, we use jcenter to pull the dependencies, this is already supported through Android Studio and Gradle.

## Setup

If you already have an older version of this plugin installed, please uninstall it first

```
cordova plugin rm cordova-plugin-estimotesdk
```

In your existing Cordova based project:

```
cordova plugin add cordova-plugin-estimotesdk
```

If you want to test out bleeding edge features, you can optinally pull the plugin from git:

```
cordova plugin add https://github.com/apility/cordova-plugin-estimotesdk
```