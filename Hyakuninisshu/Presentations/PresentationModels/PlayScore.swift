//
//  LastExamResult.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/10.
//

import Foundation

/// 問題の結果
struct PlayScore {
  let tookDateText: String
  let score: Score
  let averageAnswerSecText: String

  init(tookDate: Date, score: Score, averageAnswerSec: Double) {
    self.tookDateText = Self.formatter.string(from: tookDate)
    self.score = score
    self.averageAnswerSecText = "\(averageAnswerSec)秒"
  }

  private static let formatter: DateFormatter = {
    let f = DateFormatter()
    f.timeStyle = .short
    f.dateStyle = .short
    f.locale = Locale(identifier: "ja_JP")
    return f
  }()
}
