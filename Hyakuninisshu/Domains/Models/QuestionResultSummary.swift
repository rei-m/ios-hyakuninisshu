//
//  QuestionResultSummary.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import Foundation

struct QuestionResultSummary: ValueObject {
  let totalQuestionCount: UInt8
  let correctCount: UInt8
  let averageAnswerSec: Double
  let score: String
  let canRestart: Bool

  init(totalQuestionCount: UInt8, correctCount: UInt8, averageAnswerSec: Double) {
    self.totalQuestionCount = totalQuestionCount
    self.correctCount = correctCount
    self.averageAnswerSec = averageAnswerSec
    self.score = "\(correctCount) / \(totalQuestionCount)"
    self.canRestart = correctCount < totalQuestionCount
  }
}
