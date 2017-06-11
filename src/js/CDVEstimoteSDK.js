const exec = cordova.require('cordova/exec')

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

module.exports = {
  requestAlwaysAuthorization,
  requestWhenInUseAuthorization
}