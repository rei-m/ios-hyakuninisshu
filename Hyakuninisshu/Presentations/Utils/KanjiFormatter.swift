//
//  KanjiFormatter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/26.
//

import Foundation

class KanjiFormatter {
  private static let shared = KanjiFormatter()

  static func no(_ value: UInt8) -> String {
    return "\(Self.string(NSNumber(value: value)))番"
  }

  static func kimariji(_ value: UInt8) -> String {
    return "\(Self.string(NSNumber(value: value)))字決まり"
  }

  static func string(_ value: NSNumber) -> String {
    return Self.shared.formatter.string(from: value)!
  }

  private let formatter: NumberFormatter

  private init() {
    self.formatter = NumberFormatter()
    self.formatter.numberStyle = .spellOut
    self.formatter.locale = .init(identifier: "ja-JP")
  }
}
