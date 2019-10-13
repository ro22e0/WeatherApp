//
//  ForecastsSceneCoordinator.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import UIKit

enum ForecastsListRoute: RoutableScene {
  case idle
  case showForecastDetail(_ detail: String)
}

class ForecastsSceneCoordinator: Coordinator {
  var mainController: UIViewController?

  init() {
    self.mainController = nil
  }

  func route(to route: RoutableScene) {
    guard let route = route as? ForecastsListRoute else { return }
    switch route {
    case .idle:
      break
    case .showForecastDetail(_):
      break
    }
  }
}
