//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 12/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let coordinator = ForecastsSceneCoordinator()
    coordinator.route(to: ForecastsListRoute.idle)

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = coordinator.mainController
    self.window = window
    window.makeKeyAndVisible()
  }
}

