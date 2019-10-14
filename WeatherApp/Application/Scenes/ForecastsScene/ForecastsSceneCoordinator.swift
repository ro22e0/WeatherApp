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
  case showForecastDetails(ForecastDetailsData)
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
      let vc = makeDaysForecastsListViewController()
      mainController = UINavigationController(rootViewController: vc)
      
    case .showForecastDetails(let data):
      let vc = makeForecastDetailViewController(data)
      mainController?.show(vc, sender: nil)
    }
  }
}

extension ForecastsSceneCoordinator: ForecastSceneViewControllerFactory {
  func makeDaysForecastsListViewController() -> UIViewController {
    DaysForecastListViewController.instance(with:
      WeatherApp.shared.defaultContainer.makeForecastsListViewModel(self))
  }

  func makeForecastDetailViewController(_ details: ForecastDetailsData) -> UIViewController {
    return ForecastDetailsViewController.instance(with: ForecastDetailsViewModel(details: details)
    )
  }
}

private extension WeatherApp.Container {
  func makeForecastsListViewModel(_ coordinator: Coordinator) -> ForecastsListViewModel {
    ForecastsListViewModel(coordinator: coordinator,
                           forecastsUseCase: makeForecastsUseCase(),
                           locationUseCase: makeLocationUseCase())
  }

  private func makeForecastsUseCase() -> DayForecastsUseCaseProtocol {
    let repository = ForecastsRepository(service: dependencies.service)
    return DayForecastsUseCase(repository: repository)
  }

  private func makeLocationUseCase() -> LocationUseCaseProtocol {
    return LocationUseCase(worker: dependencies.locationWorker)
  }
}
