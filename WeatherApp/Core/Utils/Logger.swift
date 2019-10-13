//
//  Logger.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 13/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import Foundation

struct Logger {
  private init() {}

  private enum LogStatus: String {
    case verbose = "🔬 Verbose"
    case debug = "💬 Debug"
    case info = "ℹ️ Info"
    case warning = "⚠️ Warning"
    case error = "‼️ Error"
    case fatal = "🔥 Fatal"
  }

  private static func log(
    _ message: String, status: LogStatus, fileName: String = #file, function: String = #function, line: Int = #line) {
    let file = fileName.components(separatedBy: "/").last ?? fileName

    #if DEBUG
    print("[\(status.rawValue)][\(file)]:\(line) \(function) -> \(message)")
    #endif
  }

  static func verbose(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    self.log(message, status: .verbose, fileName: file, function: function, line: line)
  }

  static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    self.log(message, status: .debug, fileName: file, function: function, line: line)
  }

  static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    self.log(message, status: .info, fileName: file, function: function, line: line)
  }

  static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    self.log(message, status: .warning, fileName: file, function: function, line: line)
  }

  static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    self.log(message, status: .error, fileName: file, function: function, line: line)
  }

  static func fatal(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    self.log(message, status: .fatal, fileName: file, function: function, line: line)
  }
}
