//
//  ForecastDetailsViewController.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 14/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import UIKit

class ForecastDetailsViewController: BaseViewController {
  private(set) var viewModel: ForecastDetailsViewModelProtocol!
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var windLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    bindToViewModel()
  }

  private func bindToViewModel() {
    viewModel.temperature.subscribe(on: self) { [weak self] new, _ in
      self?.tempLabel.text = new
    }
    viewModel.hour.subscribe(on: self) { [weak self] new, _ in
      self?.timeLabel.text = new
    }
    viewModel.humidity.subscribe(on: self) { [weak self] new, _ in
      self?.humidityLabel.text = new
    }
    viewModel.wind.subscribe(on: self) { [weak self] new, _ in
      self?.windLabel.text = new
    }
  }
}

extension ForecastDetailsViewController: ViewModelable {
  
  static func instance(with viewModel: ForecastDetailsViewModelProtocol) -> UIViewController {
    let vc = ForecastDetailsViewController() // TODO: init from nib
    vc.viewModel = viewModel
    return vc
  }
}
