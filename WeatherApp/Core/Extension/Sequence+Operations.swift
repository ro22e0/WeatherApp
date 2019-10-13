//
//  Sequence+Operations.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

extension Sequence {
  func orderBy<V>(_ attribute: KeyPath<Element, V>, condition: (V, V) -> Bool) -> [Element] {
    sorted { e1, e2 in
      condition(e1[keyPath: attribute], e2[keyPath: attribute])
    }
  }

  func groupBy<V, K: Hashable>(_ attribute: KeyPath<Element, V>, format: (V) -> K) -> [K: [Element]] {
    var grouped: [K: [Element]] = [:]

    for value in self {
      let a = format(value[keyPath: attribute])
      if grouped[a] == nil {
        grouped[a] = [value]
      }
      else {
        grouped[a]?.append(value)
      }
    }

    return grouped
  }
}
