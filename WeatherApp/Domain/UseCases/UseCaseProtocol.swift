//
//  UseCaseProtocol.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol UseCaseProtocol {
  associatedtype T: RepositoryProtocol
  init(repository: T)
}
