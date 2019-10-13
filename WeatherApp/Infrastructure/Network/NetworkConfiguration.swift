//
//  NetworkConfiguration.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

struct NetworkConfiguration: NetworkConfigurable {
  let baseURL: String
  let headers: [String : String]
  let timeout: TimeInterval

  init(baseURL: String, headers: [String: String] = [:], timeout: TimeInterval = 10) {
    self.baseURL = baseURL
    self.headers = headers
    self.timeout = timeout
  }
}

