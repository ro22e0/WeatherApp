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

  private let manager: CLLocationManager
  weak var delegate: LocationWorkerDelegate?

  override init() {
    manager = CLLocationManager() // FIXME: interface

    super.init()

    manager.delegate = self
  }

  private func askAuthorization() {
    manager.requestWhenInUseAuthorization()
  }

  func startMonitoring() {
    self.askAuthorization()
    manager.startMonitoringSignificantLocationChanges()
  }

  func stopMonitoring() {
    manager.stopMonitoringSignificantLocationChanges()
  }
}

extension LocationWorker: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      startMonitoring()
    }
    else {
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
