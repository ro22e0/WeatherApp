//
//  Observable.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 12/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

protocol ObservableProvider {
  associatedtype Value
  typealias ObserverBlock<T> = (_ new: T, _ old: T) -> Void

  init(_ value: Value)

  var value: Value { get set }

  func subscribe(on observer: AnyObject, with block: @escaping ObserverBlock<Value>)
  func unsubscribe(_ observer: AnyObject)
}

class Observable<Value>: ObservableProvider {

  private typealias Observer = (observer: AnyObject, block: ObserverBlock<Value>)
  private var observers = [Observer]()

  var value: Value {
    didSet {
      notifyAll(value, oldValue)
    }
  }

  required init(_ value: Value) {
    self.value = value
  }

  func subscribe(on observer: AnyObject, with block: @escaping ObserverBlock<Value>) {
    observers.append((observer, block))
    DispatchQueue.main.async {
      block(self.value, self.value)
    }
  }

  func unsubscribe(_ observer: AnyObject) {
    observers = observers.filter { $0.observer !== observer }
  }

  private func notifyAll(_ new: Value, _ old: Value) {
    observers.forEach { ob in
      DispatchQueue.main.async {
        ob.block(new, old)
      }
    }
  }
}
