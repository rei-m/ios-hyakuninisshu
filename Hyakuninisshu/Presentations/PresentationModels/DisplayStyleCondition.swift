//
//  DisplayStyleCondition.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/28.
//

import Foundation

struct DisplayStyleCondition: KeyboardPickerItem, Equatable {
  let text: String
  let value: Int

  private static let DATA_SOURCE: [Int] = [0, 1]

  private static let TEXT_SOURCE: [String] = [
    "漢字と仮名で表示",
    "すべて仮名で表示",
  ]

  static let DATA: [Self] = Self.DATA_SOURCE.enumerated().map {
    return Self(text: TEXT_SOURCE[$0.offset], value: $0.element)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.value == rhs.value
  }
}
