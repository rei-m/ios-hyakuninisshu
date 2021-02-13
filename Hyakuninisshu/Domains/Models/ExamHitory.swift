//
//  ExamHitory.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation

/// 力試し履歴
class ExamHistory: Entity {
  typealias Id = ExamHistoryId

  let id: Id
  let tookDate: Date
  let score: QuestionResultScore
  let questionJudgements: [QuestionJudgement]

  init(
    id: Id, tookDate: Date, score: QuestionResultScore,
    questionJudgements: [QuestionJudgement]
  ) {
    self.id = id
    self.tookDate = tookDate
    self.score = score
    self.questionJudgements = questionJudgements
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: ExamHistory, rhs: ExamHistory) -> Bool {
    return lhs.id == rhs.id
  }
}
