//
//  Score.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/02/16.
//

import Foundation

/// スコア表示用
struct Score {
  let denominator: UInt8
  let numerator: UInt8

  var text: String { "\(numerator) / \(denominator)" }
}
