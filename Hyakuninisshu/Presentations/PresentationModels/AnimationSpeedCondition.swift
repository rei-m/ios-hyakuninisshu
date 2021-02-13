//
//  DisplayStyleCondition.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/28.
//

import Foundation

/// 出題条件 - 読み札の表示速
struct AnimationSpeedCondition: KeyboardPickerItem, Equatable {
  let text: String
  let value: Double

  private static let DATA_SOURCE: [Double] = [0, 1, 0.6, 0.3]

  private static let TEXT_SOURCE: [String] = [
    "なし",
    "おそめ",
    "ふつう",
    "はやめ",
  ]

  static let DATA: [Self] = Self.DATA_SOURCE.enumerated().map {
    return Self(text: TEXT_SOURCE[$0.offset], value: $0.element)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.value == rhs.value
  }
}
