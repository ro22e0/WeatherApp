//
//  ForecastsListViewModel.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol ForecastsListViewModelInput {
  func viewDidLoad()
  func didSelect(item: MoviesListItemViewModelProtocol)
}

protocol ForecastsListViewModelOutput {
  var items: Observable<[MoviesListItemViewModelProtocol]> { get }
  var error: Observable<String> { get }
  var isEmpty: Bool { get }
}

typealias ForecastsListViewModelProtocol =
  ForecastsListViewModelInput & ForecastsListViewModelOutput
