//
//  Question.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

/// 問題
class Question: Entity {
  typealias Id = QuestionId

  let id: Id  // ID
  let no: UInt8  // 問題の番号。連番
  let choices: [KarutaNo]  // 選択肢の歌の番号
  let correctNo: KarutaNo  // 正解の歌の番号
  let state: QuestionState  // 問題の状態

  init(id: Id, no: UInt8, choices: [KarutaNo], correctNo: KarutaNo, state: QuestionState) {
    self.id = id
    self.no = no
    self.choices = choices
    self.correctNo = correctNo
    self.state = state
  }

  /// 問題の回答を開始する
  /// - Parameter startDate: 開始時間
  /// - Throws: すでに回答済だった場合
  /// - Returns: 開始後の問題
  func start(startDate: Date) throws -> Question {
    switch state {
    case .answered(_, _):
      throw DomainError(reason: "Question is already answered. no=\(no)", kind: .model)
    case .ready, .inAnswer(_):
      return Question(
        id: id, no: no, choices: choices, correctNo: correctNo,
        state: .inAnswer(startDate: startDate))
    }
  }

  /// 問題に回答する
  /// - Parameters:
  ///   - selectedNo: 選択された歌番号
  ///   - answerDate: 回答時間
  /// - Throws: 問題が開始されていなかった場合、問題が回答済の場合
  /// - Returns: 回答後の問題
  func verify(selectedNo: KarutaNo, answerDate: Date) throws -> Question {
    switch state {
    case .ready:
      throw DomainError(reason: "Question is not started. Call start. no=\(no)", kind: .model)
    case .inAnswer(let startDate):
      let answerSec = startDate.distance(to: answerDate)
      let judgement = QuestionJudgement(karutaNo: correctNo, isCorrect: correctNo == selectedNo)
      let result = QuestionResult(
        selectedKarutaNo: selectedNo, answerSec: answerSec, judgement: judgement)
      return Question(
        id: id, no: no, choices: choices, correctNo: correctNo,
        state: .answered(startDate: startDate, result: result))
    case .answered(_, _):
      throw DomainError(reason: "Question is already answered. no=\(no)", kind: .model)
    }
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Question, rhs: Question) -> Bool {
    return lhs.id == rhs.id
  }
}
