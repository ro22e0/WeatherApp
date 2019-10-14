//
//  ForecastsSceneVCFactory.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 14/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import UIKit

protocol ForecastSceneViewControllerFactory {
  func makeDaysForecastsListViewController() -> UIViewController
  func makeForecastDetailViewController(_ details: ForecastDetailsData) -> UIViewController
}
