//
//  ColorCondition.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/28.
//

import Foundation

struct ColorCondition: KeyboardPickerItem, Equatable {
  let text: String
  let value: String?

  private static let DATA_SOURCE: [String?] = [
    nil,
    KarutaColor.blue.rawValue,
    KarutaColor.pink.rawValue,
    KarutaColor.yellow.rawValue,
    KarutaColor.green.rawValue,
    KarutaColor.orange.rawValue,
  ]

  private static let TEXT_SOURCE: [String] = [
    "指定しない",
    "青色",
    "桃色",
    "黄色",
    "緑色",
    "橙色",
  ]

  static let DATA: [Self] = Self.DATA_SOURCE.enumerated().map {
    return Self(text: TEXT_SOURCE[$0.offset], value: $0.element)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.value == rhs.value
  }
}
