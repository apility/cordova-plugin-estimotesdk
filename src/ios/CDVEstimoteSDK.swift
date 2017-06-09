//
//  CDVEstimoteSDK.swift
//  cordova-plugin-estimotesdk
//
//  Created by Thomas Alrek on 9/Jun/2017.
//  Copyright 2017 Aplity AS and contributors. All rights reserved.
//

@objc(CDVEstimoteSDK) class CDVEstimoteSDK : CDVPlugin, ESTBeaconManagerDelegate, CLLocationManagerDelegate {
    
  let tag = "CDVEstimoteSDK";
  
  var callBackId : String?;
  
  var appIdSetup = false;
  var authorizedInUse = false;
  var authorizedBackground = false;
  
  var beaconManager : ESTBeaconManager!;
  var locationManager : CLLocationManager!;

  /**
   * Initializer for this plugin
   */
  override func pluginInitialize() {
    self.log("pluginInitialize");
    
    self.beaconManager = ESTBeaconManager();
    self.locationManager = CLLocationManager();
    
    self.beaconManager.delegate = self;
    self.locationManager.delegate = self

    if let config = Bundle.main.infoDictionary?["CDVEstimoteSDK"] as? [String : String] {
      if let appId = config["AppID"], let appToken = config["AppToken"] {
        if !self.setupAppID(appId: appId, appToken: appToken) {
          self.log("Unable to setup App ID and or App Token, please verify your info.plist");
        }
      }
    }
  }
  
  /**
   * Log a message to Xcode console
   */
  func log(_ message: String) {
      debugPrint("\(self.tag): \(message)");
  }
  
  /**
   * Setup App ID and App Token for Estimote Cloud
   */
  @discardableResult
  func setupAppID(appId: String, appToken: String) -> Bool {
    if ((!appId.isEmpty && appId != "-") || (!appToken.isEmpty && appToken != "-")) && !self.appIdSetup {
      ESTConfig.setupAppID(appId, andAppToken: appToken);
      self.appIdSetup = true
      return true;
    }
    return false;
  }
  
  /**
   * Enable analytics for ranging (only works if App ID and Token is already setup)
   */
  func enableRangingAnalytics () {
    if self.appIdSetup {
      ESTAnalyticsManager.enableRangingAnalytics(true);
    }
  }

  /**
   * Enable analytics for monitoring (only works if App ID and Token is already setup)
   */
  func enableMonitoringAnalytics () {
    if self.appIdSetup {
      ESTAnalyticsManager.enableMonitoringAnalytics(true);
    }
  }
  
  // Delegate handlers
  
  /**
   * Delegate to handle CoreLocation authorization status change
   */
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    debugPrint("Authorization status changed, new status:");
    debugPrint(status);
    if self.callBackId != nil {
        var response = false
        if status == .authorizedAlways {
          response = true;
          self.authorizedBackground = true;
        }
        if status == .authorizedWhenInUse {
          response = true;
          self.authorizedInUse = true;
        }
        let pluginResult = CDVPluginResult(
          status: response ? CDVCommandStatus_OK : CDVCommandStatus_ERROR,
          messageAs: response
        )
        self.commandDelegate!.send(
          pluginResult,
          callbackId: self.callBackId
        )
        self.callBackId = nil;
    }
  }
  
  // Cordova methods, these are called from the JS side of the plugin
  
  /**
   * Requests permission to use location services whenever the app is running.
   */
  @objc(requestAlwaysAuthorization:)
  func requestAlwaysAuthorization(command: CDVInvokedUrlCommand) {
    self.log("requestAlwaysAuthorization");
    
    let status = self.beaconManager.isAuthorizedForMonitoring();
    if status {
      self.log("Already authorized for Always authorization");
      self.commandDelegate!.send(
        CDVPluginResult(
          status: CDVCommandStatus_OK,
          messageAs: true
        ),
        callbackId: command.callbackId
      );
    } else {
      self.callBackId = command.callbackId;
      self.beaconManager.requestAlwaysAuthorization();
    }
  }
  
  /**
   * Requests permission to use location services while the app is in the foreground.
   */
  @objc(requestWhenInUseAuthorization:)
  func requestWhenInUseAuthorization(command: CDVInvokedUrlCommand) {
    self.log("requestWhenInUseAuthorization");
  
    let status = self.beaconManager.isAuthorizedForRanging();
    if status {
      self.commandDelegate!.send(
        CDVPluginResult(
          status: CDVCommandStatus_OK,
          messageAs: true
        ),
        callbackId: command.callbackId
      );
    } else {
      self.callBackId = command.callbackId;
      self.beaconManager.requestWhenInUseAuthorization();
    }
  }

}