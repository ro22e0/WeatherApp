//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import UIKit

protocol Coordinator {
  var mainController: UIViewController? { get }
  func route(to route: RoutableScene)
}
