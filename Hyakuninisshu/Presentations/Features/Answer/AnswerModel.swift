//
//  AnswerModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Combine
import Foundation

protocol AnswerModelProtocol: AnyObject {
  func aggregateTrainingResult(finishDate: Date) -> AnyPublisher<TrainingResult, PresentationError>
  func aggregateExamResultAndSaveExamHistory(finishDate: Date) -> AnyPublisher<
    ExamResult, PresentationError
  >
}

class AnswerModel: AnswerModelProtocol {
  private let karutaRepository: KarutaRepository
  private let questionRepository: QuestionRepository
  private let examHistoryRepository: ExamHistoryRepository

  init(
    karutaRepository: KarutaRepository, questionRepository: QuestionRepository,
    examHistoryRepository: ExamHistoryRepository
  ) {
    self.karutaRepository = karutaRepository
    self.questionRepository = questionRepository
    self.examHistoryRepository = examHistoryRepository
  }

  func aggregateTrainingResult(finishDate: Date) -> AnyPublisher<TrainingResult, PresentationError>
  {
    let publisher = self.questionRepository.findCollection().flatMap {
      questionCollection -> AnyPublisher<TrainingResult, DomainError> in
      do {
        let (resultSummary, judgements) = try questionCollection.aggregateResult()
        let playScore = PlayScore(
          tookDate: finishDate, score: resultSummary.score,
          averageAnswerSecText: "\(resultSummary.averageAnswerSec)秒")
        let wrongKarutaNos = judgements.filter { !$0.isCorrect }.map { $0.karutaNo.value }
        let trainingResult = TrainingResult(
          score: playScore, canRestart: resultSummary.canRestart, wrongKarutaNos: wrongKarutaNos)
        return Just<TrainingResult>(trainingResult).setFailureType(to: DomainError.self)
          .eraseToAnyPublisher()
      } catch let error {
        return self.handleCatchError(error)
      }
    }

    return publisher.mapError { PresentationError($0) }.eraseToAnyPublisher()
  }

  func aggregateExamResultAndSaveExamHistory(finishDate: Date) -> AnyPublisher<
    ExamResult, PresentationError
  > {
    let publisher = self.questionRepository.findCollection().flatMap {
      questionCollection -> AnyPublisher<ExamHistory, DomainError> in
      do {
        let (resultSummary, questionJudgements) = try questionCollection.aggregateResult()
        let examHistory = ExamHistory(
          id: ExamHistoryId.create(), tookDate: Date(), resultSummary: resultSummary,
          questionJudgements: questionJudgements)

        return self.examHistoryRepository.add(examHistory).flatMap {
          _ -> AnyPublisher<ExamHistoryCollection, DomainError> in
          return self.examHistoryRepository.findCollection().eraseToAnyPublisher()
        }.flatMap { examHistoryCollection -> AnyPublisher<ExamHistory, DomainError> in
          let overflowed = examHistoryCollection.overflowed
          if overflowed.isEmpty {
            return Just<ExamHistory>(examHistory).setFailureType(to: DomainError.self)
              .eraseToAnyPublisher()
          }
          return self.examHistoryRepository.delete(overflowed).map { _ -> ExamHistory in examHistory
          }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
      } catch let error {
        return self.handleCatchError(error)
      }
    }.zip(self.karutaRepository.findAll()).map { (examHistory, karutas) -> ExamResult in
      let correctKauraNoSet: Set<KarutaNo> = Set(
        examHistory.questionJudgements.filter { $0.isCorrect }.map { $0.karutaNo })

      let judgements: [(Material, Bool)] = karutas.map {
        (Material.fromKaruta($0), correctKauraNoSet.contains($0.no))
      }

      let playScore = PlayScore(
        tookDate: finishDate, score: examHistory.resultSummary.score,
        averageAnswerSecText: "\(examHistory.resultSummary.averageAnswerSec)秒")

      return ExamResult(score: playScore, judgements: judgements)
    }

    return publisher.mapError { PresentationError($0) }.eraseToAnyPublisher()
  }

  private func handleCatchError<Output>(_ error: Error) -> AnyPublisher<Output, DomainError> {
    guard let error = error as? DomainError else {
      return Fail<Output, DomainError>(error: DomainError(reason: "unhandled", kind: .unhandled))
        .eraseToAnyPublisher()
    }

    return Fail<Output, DomainError>(error: error).eraseToAnyPublisher()
  }
}
