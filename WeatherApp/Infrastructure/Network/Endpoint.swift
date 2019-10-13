//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

class Endpoint: Requestable {
  let resource: String
  let method: HttpMethod
  let parameters: Parameters
  let encoding: Encoding

  init(resource: String, method: HttpMethod = .get,
       parameters: Parameters = [:], encoding: Encoding = .json) {
    self.resource = resource
    self.method = method
    self.parameters = parameters
    self.encoding = encoding
  }
}
