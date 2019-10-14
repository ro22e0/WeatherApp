//
//  DaysForecastListViewController.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 14/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import UIKit

class DaysForecastListViewController: BaseViewController {
  private(set) var viewModel: ForecastsListViewModelProtocol!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .red
  }
}

extension DaysForecastListViewController: ViewModelable {
  static func instance(with viewModel: ForecastsListViewModelProtocol) -> UIViewController {
    let vc = DaysForecastListViewController()
    vc.viewModel = viewModel
    return vc
  }
}
