# EstimoteSDK wrapper for Cordova

Adds a thin wrapper around Estimote's native iBeacon and Nearables SDK. This plugin supports iOS 8 or later, and Android 4.4 or later.

This is a new project, and is not related to the phonegap-estimotebeacons. Because that project is basically abandoned, and have done some bad decisions in the past (like committing full static libraries), this projects is written for scratch.

It is a work in progress, and should not be used in production yet. It is missing a lot of functionality, and so we recommend you to use cordova-plugin-ibeacon until this projects gets more mature.

If you would like to contribute, please see our [Contribution guidelines](CONTRIBUTING.md).

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