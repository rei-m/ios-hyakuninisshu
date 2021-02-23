//
//  QuestionCollection.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import Foundation

/// 問題の集合
struct QuestionCollection {
  let values: [Question]

  init(_ values: [Question]) {
    self.values = values
  }

  /// 問題の結果を集約する
  /// - Throws: 未回答の問題が含まれていた場合
  /// - Returns: スコアと各問題の回答結果
  func aggregateResult() throws -> (QuestionResultScore, [QuestionJudgement]) {
    let questionCount = UInt8(values.count)
    if questionCount == 0 {
      return (
        QuestionResultScore(totalQuestionCount: 0, correctCount: 0, averageAnswerSec: 0), []
      )
    }

    var totalAnswerTimeSec: TimeInterval = 0
    var collectCount: UInt8 = 0
    var judgements: [QuestionJudgement] = []

    try values.forEach { question in
      guard case .answered(_, let result) = question.state else {
        throw DomainError(reason: "includes unanswered question.", kind: .model)
      }

      totalAnswerTimeSec += result.answerSec

      judgements.append(
        QuestionJudgement(karutaNo: question.correctNo, isCorrect: result.judgement.isCorrect))

      if result.judgement.isCorrect {
        collectCount += 1
      }
    }

    let averageAnswerSec = totalAnswerTimeSec / Double(questionCount)
    let roundedAverageAnswerSec = round(averageAnswerSec * 100) / 100

    let score = QuestionResultScore(
      totalQuestionCount: questionCount,
      correctCount: collectCount,
      averageAnswerSec: roundedAverageAnswerSec
    )

    return (score, judgements)
  }
}
