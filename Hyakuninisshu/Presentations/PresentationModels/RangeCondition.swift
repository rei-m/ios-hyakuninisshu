//
//  RangeFromCondition.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/27.
//

import Foundation

/// 出題条件 - 歌番号
struct RangeCondition: KeyboardPickerItem, Equatable {
  let text: String
  let no: UInt8

  private static let FROM_DATA_SOURCE: [UInt8] = [1, 11, 21, 31, 41, 51, 61, 71, 81, 91]
  private static let TO_DATA_SOURCE: [UInt8] = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]

  static let FROM_DATA: [RangeCondition] = RangeCondition.FROM_DATA_SOURCE.map {
    RangeCondition(text: KanjiFormatter.no($0), no: $0)
  }

  static let TO_DATA: [RangeCondition] = RangeCondition.TO_DATA_SOURCE.map {
    RangeCondition(text: KanjiFormatter.no($0), no: $0)
  }

  static func == (lhs: RangeCondition, rhs: RangeCondition) -> Bool {
    return lhs.no == rhs.no
  }
}
