//
//  UIUserInterfaceStyleExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/31.
//

import Foundation
import UIKit

extension UIUserInterfaceStyle {
  var text: String {
    switch self {
    case .dark:
      return "ダーク"
    case .light:
      return "ライト"
    case .unspecified:
      return "システム設定に従う"
    @unknown default:
      fatalError("unknown UIUserInterfaceStyle. value=\(self)")
    }
  }
}
