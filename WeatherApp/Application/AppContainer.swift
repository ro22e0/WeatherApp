//
//  AppContainer.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 14/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

class WeatherApp {
  class Container {
    struct Dependencies {
      let service: NetworkServiceProvider
      let locationWorker: LocationWorkerProtocol
    }

    let dependencies: Dependencies

    init(dependencies: Dependencies) {
      self.dependencies = dependencies
    }
  }

  private init() {}
  static let `shared` = WeatherApp()

  lazy var defaultContainer = { () -> WeatherApp.Container in
    let configuration = NetworkConfiguration(baseURL: "https://www.infoclimat.fr/public-api/")
    let session = AlamofireSession(configurable: configuration)
    let network = Network(sessionable: session)
    let service = NetworkService(provider: network)
    let worker = LocationWorker()

    return Container(dependencies:
      Container.Dependencies(service: service, locationWorker: worker))
  }()
}
