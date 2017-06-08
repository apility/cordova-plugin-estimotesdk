@objc(CDVEstimoteSDK) class CDVEstimoteSDK : CDVPlugin, ESTBeaconManagerDelegate {

    let beaconManager = ESTBeaconManager();
    let hasPermission = false;

    override init() {
        super.init()
        self.beaconManager.delegate = self
        debugPrint("init");
    }
    
    /*
     * Requests permission to use location services whenever the app is running.
     */
    @objc(requestAlwaysAuthorization:)
    func requestAlwaysAuthorization(command: CDVInvokedUrlCommand) {

        debugPrint("requestAlwaysAuthorization");

        let pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: true
        );
        
        if (!self.beaconManager.isAuthorizedForMonitoring()) {
            self.beaconManager.requestAlwaysAuthorization()
        }
        
        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
    
    /*
     * Requests permission to use location services while the app is in the foreground.
     */
    @objc(requestWhenInUseAuthorization:)
    func requestWhenInUseAuthorization(command: CDVInvokedUrlCommand) {

        debugPrint("requestWhenInUseAuthorization");

        let pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: true
        );
        
        if (!self.beaconManager.isAuthorizedForMonitoring() && !self.beaconManager.isAuthorizedForRanging()) {
            self.beaconManager.requestWhenInUseAuthorization()
        }
        
        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }

}