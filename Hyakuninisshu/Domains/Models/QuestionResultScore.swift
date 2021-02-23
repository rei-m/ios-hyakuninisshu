//
//  QuestionResultSummary.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import Foundation

/// 問題結果の集合のスコア
struct QuestionResultScore: ValueObject {
  let totalQuestionCount: UInt8
  let correctCount: UInt8
  let averageAnswerSec: Double
  let canRestart: Bool

  init(totalQuestionCount: UInt8, correctCount: UInt8, averageAnswerSec: Double) {
    self.totalQuestionCount = totalQuestionCount
    self.correctCount = correctCount
    self.averageAnswerSec = averageAnswerSec
    self.canRestart = correctCount < totalQuestionCount
  }
}
