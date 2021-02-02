//
//  UIFontExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/29.
//

import Foundation
import UIKit

extension UIFont {
  enum FontNames: String {
    case hannari = "HannariMincho"
  }

  convenience init?(name: FontNames, size: CGFloat) {
    self.init(name: name.rawValue, size: size)
  }
}
