//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 12/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    if #available(iOS 13.0, *) {}
    else {
      let coordinator = ForecastsSceneCoordinator()
      coordinator.route(to: ForecastsListRoute.idle)

      window = UIWindow(frame: UIScreen.main.bounds)
      window?.rootViewController = coordinator.mainController
      window?.makeKeyAndVisible()
    }
    
    return true
  }

  // MARK: UISceneSession Lifecycle

  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

