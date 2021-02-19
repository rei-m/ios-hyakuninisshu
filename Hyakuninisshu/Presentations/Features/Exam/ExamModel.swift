//
//  ExamModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Combine
import Foundation

protocol ExamModelProtocol: AnyObject {
  func fetchLastExamScore() -> AnyPublisher<PlayScore?, PresentationError>
  func fetchExamKarutaNos() -> AnyPublisher<[UInt8], PresentationError>
  func fetchPastExamsWrongKarutaNos() -> AnyPublisher<[UInt8], PresentationError>
}

class ExamModel: ExamModelProtocol {
  private let karutaRepository: KarutaRepository
  private let examHistoryRepository: ExamHistoryRepository

  init(karutaRepository: KarutaRepository, examHistoryRepository: ExamHistoryRepository) {
    self.karutaRepository = karutaRepository
    self.examHistoryRepository = examHistoryRepository
  }

  func fetchLastExamScore() -> AnyPublisher<PlayScore?, PresentationError> {
    let publisher = examHistoryRepository.findLast().map { examHistory -> PlayScore? in
      guard let examHistory = examHistory else {
        return nil
      }
      let resultSummary = examHistory.score
      let score = Score(
        denominator: resultSummary.totalQuestionCount, numerator: resultSummary.correctCount)
      return PlayScore(
        tookDate: examHistory.tookDate, score: score,
        averageAnswerSec: resultSummary.averageAnswerSec)
    }
    return publisher.mapError { PresentationError($0) }.eraseToAnyPublisher()
  }

  func fetchExamKarutaNos() -> AnyPublisher<[UInt8], PresentationError> {
    let publisher = karutaRepository.findAll().map { $0.map { karuta in karuta.no.value } }
    return publisher.mapError { PresentationError($0) }.eraseToAnyPublisher()
  }

  func fetchPastExamsWrongKarutaNos() -> AnyPublisher<[UInt8], PresentationError> {
    let publisher = examHistoryRepository.findCollection().map {
      $0.totalWrongKarutaNoCollection.values.map { karutaNo in karutaNo.value }
    }
    return publisher.mapError { PresentationError($0) }.eraseToAnyPublisher()
  }
}
