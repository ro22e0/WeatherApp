//
//  LocationWorker.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation
import CoreLocation

class LocationWorker: NSObject, LocationWorkerProtocol {

  private lazy var manager: CLLocationManager = {
    let manager = CLLocationManager() // FIXME: Interface(DI)
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.distanceFilter = 500
    return manager
  }()
  weak var delegate: LocationWorkerDelegate?

  override init() {
    super.init()
    manager.delegate = self
  }

  func startMonitoring() {
    manager.requestWhenInUseAuthorization()
  }

  func stopMonitoring() {
    manager.stopUpdatingLocation()
  }
}

extension LocationWorker: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.startUpdatingLocation()
    case .notDetermined:
      break
    default:
      delegate?.worker(didFailWithError: .authorizationDenied)
    }
  }

  func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
    if let lastLocation = locations.last {
      let location = DataLocation(
        lat: lastLocation.coordinate.latitude, long: lastLocation.coordinate.longitude)
      delegate?.worker(didUpdateLocation: location)
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if let error = error as? CLError, error.code == .denied {
      delegate?.worker(didFailWithError: .authorizationDenied)
      manager.stopMonitoringSignificantLocationChanges()
      return
    }
    delegate?.worker(didFailWithError: .workerError(error))
  }
}
