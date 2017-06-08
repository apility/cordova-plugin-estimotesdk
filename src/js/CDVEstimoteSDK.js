const exec = cordova.require('cordova/exec')

const requestAlwaysAuthorization = () => {
  return new Promise((resolve, reject) => {
    exec(result => {
      console.log('Success: ' + result)
      resolve(result)
    }, error => {
      console.log('Success: ' + error)
      reject(error)
    }, 'CDVEstimoteSDK', 'requestAlwaysAuthorization')
  })
}

const requestWhenInUseAuthorization = () => {
  return new Promise((resolve, reject) => {
    exec(result => {
      console.log('Success: ' + result)
      resolve(result)
    }, error => {
      console.log('Success: ' + error)
      reject(error)
    }, 'CDVEstimoteSDK', 'requestWhenInUseAuthorization')
  })
}

module.exports = {
  requestAlwaysAuthorization,
  requestWhenInUseAuthorization
}