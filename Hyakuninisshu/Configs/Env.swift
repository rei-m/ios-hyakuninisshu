//
//  Env.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/02/06.
//

import Foundation

class Env {
  static let shared = Env()

  enum EnvKey: String {
    case adUnitId = "AD_UNIT_ID"
    case gADApplicationIdentifier = "GAD_APPLICATION_IDENTIFIER"
    case testDeviceIdentifier = "TEST_DEVICE_IDENTIFIER"
  }

  func configure() {
    var resource = ".env"
    #if DEBUG
      resource = ".debug.env"
    #endif

    guard let path = Bundle.main.path(forResource: resource, ofType: nil) else {
      fatalError("Not found: '.env'.\nPlease create .env file.")
    }
    let url = URL(fileURLWithPath: path)
    do {
      let data = try Data(contentsOf: url)
      let str = String(data: data, encoding: .utf8) ?? "Empty File"
      let clean = str.replacingOccurrences(of: "\"", with: "").replacingOccurrences(
        of: "'", with: "")
      let envVars = clean.components(separatedBy: "\n")
      for envVar in envVars {
        /// TODO: キーのチェックまでしたほうがいいかな
        let keyVal = envVar.components(separatedBy: "=")
        if keyVal.count == 2 {
          setenv(keyVal[0], keyVal[1], 1)
        }
      }
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  func value(_ key: EnvKey) -> String? {
    return ProcessInfo.processInfo.environment[key.rawValue]
  }

  private init() {
  }
}
