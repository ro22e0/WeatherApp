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
  var numberOfSections: Int { get }
}

typealias ForecastsListViewModelProtocol =
  ForecastsListViewModelInput & ForecastsListViewModelOutput


class ForecastsListViewModel: ViewModel, ForecastsListViewModelProtocol {

  // MARK: - Output properties
  var items: Observable<[MoviesListItemViewModelProtocol]>
  var error: Observable<String>
  var numberOfSections: Int

  private var location: Observable<(Location?, LocationError?)> = Observable((nil, nil))

  private let coordinator: Coordinator

  private let forecastsUseCase: DayForecastsUseCaseProtocol
  private let locationUseCase: LocationUseCaseProtocol

  init(coordinator: Coordinator,
       forecastsUseCase: DayForecastsUseCaseProtocol, locationUseCase: LocationUseCaseProtocol) {
    self.coordinator = coordinator
    self.forecastsUseCase = forecastsUseCase
    self.locationUseCase = locationUseCase

    items = Observable([])
    error = Observable("")
    numberOfSections = 0
  }

  private func bind() {
    location.subscribe(on: self) { [weak self] new, old in
      guard let self = self else { return }

      if let error = new.1 {
        self.handle(error: error)
      }
      if let location = new.0 {
        self.load(for: location)
      }
    }
  }

  private func userLocation() {
    self.locationUseCase.run(request: LocationRequest(location))
  }

  private func load(for location: Location) {
    let request = ForecastsRequest(location:
      Location(locality: "Paris", latitude: 48.85341, longitude: 2.3488))

    forecastsUseCase.run(request: request) { [weak self] result in
      guard let self = self else { return }

      switch result {

      case .success(let forecasts):
        self.numberOfSections = forecasts.count
        // TODO: bind with items
        break
      case .failure(let error):
        self.handle(error: error)
      }
    }
  }

  private func handle(error: Error) {}
}

// MARK: - Input (view events)
extension ForecastsListViewModel {

  func viewDidLoad() {}

  func didSelect(item: MoviesListItemViewModelProtocol) {
    coordinator.route(to: ForecastsListRoute.showForecastDetail)
  }

  //  func didSelect(item: MoviesListItemViewModel) {
  //    route.value = .showMovieDetail(title: item.title,
  //                                   overview: item.overview,
  //                                   posterPlaceholderImage: item.posterImage.value,
  //                                   posterPath: item.posterPath)
  //  }
}
