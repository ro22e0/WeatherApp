//
//  LocationWorkerProtocol.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

enum LocationError: Error {
  case authorizationDenied
  case workerError(Error)
}

protocol LocationWorkerDelegate: AnyObject {
  func worker(didUpdateLocation location: DataLocation)
  func worker(didFailWithError error: LocationError)
}

protocol LocationWorkerProtocol {
  var delegate: LocationWorkerDelegate? { get set }
  func startMonitoring()
  func stopMonitoring()
}
