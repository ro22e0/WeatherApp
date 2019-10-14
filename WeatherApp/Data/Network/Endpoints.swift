//
//  Endpoints.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

struct Endpoints {
  static func forecasts(lat: Double, long: Double) -> GenericEndpoint<DataForecasts> {
    let parameters = [
      "_ll": "\(lat.rounded(place: 5)),\(long.rounded(place: 5))",
      "_auth": "ARtXQFYoVnRXegYxVCIBKFY+V2IPeVN0BXkDYFs+A34AawRlVTVcOlE/VyoPIFBmByoBYgswVWUCaQpyCnhfPgFrVztWPVYxVzgGY1R7ASpWeFc2Dy9TdAVuA2ZbKANhAGEEZFUoXDtROVcrDz5QZAcxAX4LK1VsAmQKagpnXzUBYFczVjZWNlc6BntUewEwVjFXZg8yU24FYQNsWzQDZABrBDNVYFw2UTpXKw8+UGIHNwFkCzxVawJjCmsKeF8jARtXQFYoVnRXegYxVCIBKFYwV2kPZA==",
      "_c": "c24d57cf23adda99bb98b2bda0f0b5ca"
    ]
    return GenericEndpoint(resource: "gfs/json", parameters: parameters, encoding: .url)
  }
}
