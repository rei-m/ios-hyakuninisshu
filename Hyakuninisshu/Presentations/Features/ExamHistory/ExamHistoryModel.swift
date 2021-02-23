//
//  ExamHistoryModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/11.
//

import Combine
import Foundation

protocol ExamHistoryModelProtocol: AnyObject {
  func fetchScores() -> AnyPublisher<[PlayScore], PresentationError>
}

class ExamHistoryModel: ExamHistoryModelProtocol {
  private let examHistoryRepository: ExamHistoryRepository

  init(examHistoryRepository: ExamHistoryRepository) {
    self.examHistoryRepository = examHistoryRepository
  }

  func fetchScores() -> AnyPublisher<[PlayScore], PresentationError> {
    let publisher = examHistoryRepository.findCollection().map {
      examHistoryCollection -> [PlayScore] in
      return examHistoryCollection.values.map { examHistory in
        let score = Score(
          denominator: examHistory.score.totalQuestionCount,
          numerator: examHistory.score.correctCount)
        return PlayScore(
          tookDate: examHistory.tookDate, score: score,
          averageAnswerSec: examHistory.score.averageAnswerSec)
      }
    }
    return publisher.mapError { PresentationError($0) }.eraseToAnyPublisher()
  }
}
