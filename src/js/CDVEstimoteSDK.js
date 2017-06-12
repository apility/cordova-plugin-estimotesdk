const exec = cordova.require('cordova/exec')

const setupAppID = (appId, appToken) => {
  return new Promise((resolve, reject) => {
    if (!appId || !appToken) {
      reject(false)
    }
    exec(resolve, reject, 'CDVEstimoteSDK', 'setupAppID', [appId, appToken])
  })
}

const requestAlwaysAuthorization = () => {
  return new Promise((resolve, reject) => {
    exec(resolve, reject, 'CDVEstimoteSDK', 'requestAlwaysAuthorization')
  })
}

const requestWhenInUseAuthorization = () => {
  return new Promise((resolve, reject) => {
    exec(resolve, reject, 'CDVEstimoteSDK', 'requestWhenInUseAuthorization')
  })
}

const reqisterForTelemetry = () => {
  return new Promise((resolve, reject) => {
    exec(resolve, reject, 'CDVEstimoteSDK', 'reqisterForTelemetry')
  })
}

const startRangingBeacons = () => {
  return new Promise((resolve, reject) => {
    exec(resolve, reject, 'CDVEstimoteSDK', 'startRangingBeacons')
  })
}

module.exports = {
  setupAppID,
  requestAlwaysAuthorization,
  requestWhenInUseAuthorization,
  reqisterForTelemetry,
  startRangingBeacons
}