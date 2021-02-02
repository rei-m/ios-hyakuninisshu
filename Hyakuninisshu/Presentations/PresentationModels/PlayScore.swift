//
//  LastExamResult.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/10.
//

import Foundation

struct PlayScore {
  let tookDate: Date
  let tookDateText: String
  let score: String
  let averageAnswerSecText: String

  init(tookDate: Date, score: String, averageAnswerSecText: String) {
    self.tookDate = tookDate
    self.tookDateText = Self.formatter.string(from: tookDate)
    self.score = score
    self.averageAnswerSecText = averageAnswerSecText
  }

  private static let formatter: DateFormatter = {
    let f = DateFormatter()
    f.timeStyle = .short
    f.dateStyle = .short
    f.locale = Locale(identifier: "ja_JP")
    return f
  }()
}
