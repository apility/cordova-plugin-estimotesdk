//
//  CDVEstimoteSDK.swift
//  cordova-plugin-estimotesdk
//
//  Created by Thomas Alrek on 9/Jun/2017.
//  Copyright 2017 Aplity AS and contributors. All rights reserved.
//

@objc(CDVEstimoteSDK) class CDVEstimoteSDK : CDVPlugin, ESTBeaconManagerDelegate, CLLocationManagerDelegate {
    
  // --- Apple CoreLocation manager ----
  var locationManager : CLLocationManager!;

  // ---- EstimoteSDK client managers ----
  var beaconManager : ESTBeaconManager!;
  var deviceManager : ESTDeviceManager!;
  var nearableManager : ESTNearableManager!;
  var eddystoneManager : ESTEddystoneManager!;
  var secureBeaconManager : ESTSecureBeaconManager!;
  
  var authorizedAlways = false;
  var authorizedWhenInUse = false;
  var beaconRegion : CLBeaconRegion!;
  
  // ---- Array to hold CDVCommand callbacks ----
  var callbackQueue : [String?]!;

  /**
   * Initializer for this plugin
   */
  override func pluginInitialize() {    
    self.beaconManager = ESTBeaconManager();
    self.deviceManager = ESTDeviceManager();
    self.locationManager = CLLocationManager();
    
    self.beaconManager.delegate = self;
    self.locationManager.delegate = self
    
    self.callbackQueue = Array<String?>();
    self.callbackQueue.append(nil);

    self.authorizedWhenInUse = CLLocationManager.authorizationStatus() == .authorizedWhenInUse ? true : false
    self.authorizedAlways = CLLocationManager.authorizationStatus() == .authorizedAlways ? true : false
    self.authorizedWhenInUse = self.authorizedAlways ? true : self.authorizedWhenInUse;
    
    if self.authorizedWhenInUse {
      self.beaconManager.requestWhenInUseAuthorization();
    }
    
    if self.authorizedAlways {
      self.beaconManager.requestAlwaysAuthorization();
    }

    if let config = Bundle.main.infoDictionary?["CDVEstimoteSDK"] as? [String : String] {
      if let appId = config["AppID"], let appToken = config["AppToken"] {
        self.setupAppID(appId: appId, appToken: appToken);
      }
    }
  }
  
  /**
   * Setup App ID and App Token for Estimote Cloud
   */
  @discardableResult
  func setupAppID(appId: String, appToken: String) -> Bool {
    if ((!appId.isEmpty && appId != "-") || (!appToken.isEmpty && appToken != "-")) {
      ESTConfig.setupAppID(appId, andAppToken: appToken);
      return true;
    }
    return false;
  }
  
  /**
   * Enable analytics for ranging (only works if App ID and Token is already setup)
   */
  func enableRangingAnalytics () {
    ESTAnalyticsManager.enableRangingAnalytics(true);
  }

  /**
   * Enable analytics for monitoring (only works if App ID and Token is already setup)
   */
  func enableMonitoringAnalytics () {
    ESTAnalyticsManager.enableMonitoringAnalytics(true);
  }
  
  // ---- Delegate handlers ----
  
  /**
   * Delegate to handle CoreLocation authorization status change
   */
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    var response = false;
    if let callback = self.callbackQueue.first {
      self.callbackQueue.remove(at: 0);
      if callback != nil {
        switch status {
        case .authorizedAlways:
          self.authorizedAlways = true;
          response =  true;
        case .authorizedWhenInUse:
          self.authorizedWhenInUse = true;
          response =  true;
        case .denied: fallthrough
        case .notDetermined: fallthrough
        case .restricted:
          response = false;
        }
        self.commandDelegate!.send(
          CDVPluginResult(
            status: response ? CDVCommandStatus_OK : CDVCommandStatus_ERROR,
            messageAs: response
          ),
          callbackId: callback!
        )
      }
    }
  }
  
  // ---- Cordova methods, these are called from the JS side of the plugin ----
  
  @objc(setupAppID:)
  func setupAppID(command: CDVInvokedUrlCommand) {
    let appId = command.arguments[0] as? String ?? "";
    let appToken = command.arguments[1] as? String ?? "";
    let status = self.setupAppID(appId: appId, appToken: appToken)
    self.commandDelegate!.send(
        CDVPluginResult(
            status: status ? CDVCommandStatus_OK : CDVCommandStatus_ERROR,
            messageAs: status
        ),
      callbackId: command.callbackId!
    )
  }

  /**
   * Requests permission to use location services whenever the app is running.
   */
  @objc(requestAlwaysAuthorization:)
  func requestAlwaysAuthorization(command: CDVInvokedUrlCommand) {
    if self.authorizedAlways || self.beaconManager.isAuthorizedForMonitoring() {
      self.callbackQueue.append(nil);
      self.beaconManager.requestAlwaysAuthorization();
      self.commandDelegate!.send(
        CDVPluginResult(
          status: CDVCommandStatus_OK,
          messageAs: true
        ),
        callbackId: command.callbackId!
      );
    } else {
        self.callbackQueue.append((command.callbackId! as String?)!);
        self.beaconManager.requestAlwaysAuthorization();
      }
    }
  
  /**
   * Requests permission to use location services while the app is in the foreground.
   */
  @objc(requestWhenInUseAuthorization:)
  func requestWhenInUseAuthorization(command: CDVInvokedUrlCommand) {
    if self.authorizedWhenInUse || self.beaconManager.isAuthorizedForRanging() {
      self.callbackQueue.append(nil);
      self.beaconManager.requestWhenInUseAuthorization();
      self.commandDelegate!.send(
        CDVPluginResult(
          status: CDVCommandStatus_OK,
          messageAs: true
        ),
        callbackId: command.callbackId
      );
    } else {
      debugPrint(command.callbackId);
      self.callbackQueue.append((command.callbackId! as String?)!);
      self.beaconManager.requestWhenInUseAuthorization();
    }
  }

  @objc(reqisterForTelemetry:)
  func reqisterForTelemetry(command: CDVInvokedUrlCommand) {
    let telemetry = ESTTelemetryNotificationSystemStatus() {_ in }
    self.deviceManager.register(forTelemetryNotification: telemetry);
    self.commandDelegate!.send(
      CDVPluginResult(
        status: CDVCommandStatus_OK,
        messageAs: true
      ),
      callbackId: command.callbackId
    );
  }
  
  @objc(startRangingBeacons:)
  func startRangingBeacons(command: CDVInvokedUrlCommand) {
    self.beaconManager.startRangingBeacons(in: self.beaconRegion);
    self.commandDelegate!.send(
      CDVPluginResult(
        status: CDVCommandStatus_OK,
        messageAs: true
      ),
      callbackId: command.callbackId
    );
  }

}