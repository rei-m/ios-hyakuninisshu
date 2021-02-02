//
//  UserDefaultsExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/30.
//

import Foundation
import UIKit

extension UserDefaults {
  var darkMode: UIUserInterfaceStyle {
    guard let v = value(forKey: "DarkMode") as? Int else {
      return UIUserInterfaceStyle.unspecified
    }

    guard let result = UIUserInterfaceStyle(rawValue: v) else {
      return UIUserInterfaceStyle.unspecified
    }

    return result
  }

  func setDarkMode(_ value: UIUserInterfaceStyle) {
    setValue(value.rawValue, forKey: "DarkMode")
  }
}
