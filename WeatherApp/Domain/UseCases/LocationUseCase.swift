//
//  LocationUseCase.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol LocationUseCaseProtocol: UseCaseProtocol {
  func run(request: LocationRequest)
}

class LocationRequest {
  let location: Observable<(Location?, LocationError?)>

  init(_ observable: Observable<(Location?, LocationError?)>) {
    location = observable
  }
}

class LocationUseCase: LocationUseCaseProtocol {

  private var location: Observable<(Location?, LocationError?)>?
  private var worker: LocationWorkerProtocol

  init(worker: LocationWorkerProtocol) {
    self.worker = worker
    self.worker.delegate = self
  }

  func run(request: LocationRequest) {
    location = request.location
    worker.startMonitoring()
  }
}

extension LocationUseCase: LocationWorkerDelegate {
  func worker(didUpdateLocation location: DataLocation) {
    let location = Location(locality: "", latitude: location.lat, longitude: location.long)
    self.location?.value = (location, nil)
  }

  func worker(didFailWithError error: LocationError) {
    self.location?.value = (nil, error)
  }
}
