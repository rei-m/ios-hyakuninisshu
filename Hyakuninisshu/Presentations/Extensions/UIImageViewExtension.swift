//
//  UIImageViewExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/11.
//

import Foundation
import UIKit

extension UIImageView {
  /// 歌の画像をセットする
  /// - Parameter no: 歌番号
  func setKarutaImage(no: UInt8) {
    self.image = UIImage(named: "Karuta\(no)")
  }
}
