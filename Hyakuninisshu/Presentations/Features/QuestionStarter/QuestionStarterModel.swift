//
//  TrainingStarterModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import Combine
import Foundation

protocol QuestionStarterModelProtocol: AnyObject {
  func createQuestions() -> AnyPublisher<Int, PresentationError>
}

class QuestionStarterModel: QuestionStarterModelProtocol {

  private static let CHOICE_COUNT = 4

  private let karutaNos: [UInt8]
  private let karutaRepository: KarutaRepository
  private let questionRepository: QuestionRepository

  init(
    karutaNos: [UInt8],
    karutaRepository: KarutaRepository,
    questionRepository: QuestionRepository
  ) {
    self.karutaNos = karutaNos
    self.karutaRepository = karutaRepository
    self.questionRepository = questionRepository
  }

  func createQuestions() -> AnyPublisher<Int, PresentationError> {
    let targetKarutaNoCollection = KarutaNoCollection(karutaNos.shuffled().map { KarutaNo($0) })

    let allKarutaNoCollectionPublisher = karutaRepository.findAll().map {
      KarutaNoCollection($0.map { $0.no })
    }

    let questionsPublisher = allKarutaNoCollectionPublisher.map {
      allKarutaNoCollection -> [Question]? in
      let createQuestionsService = CreateQuestionsService(allKarutaNoCollection)
      return createQuestionsService?.execute(
        targetKarutaNoCollection: targetKarutaNoCollection, choiceCount: Self.CHOICE_COUNT)
    }.mapError { PresentationError($0) }

    return questionsPublisher.flatMap { questions -> AnyPublisher<Int, PresentationError> in
      guard let questions = questions else {
        let error = PresentationError(reason: "Failed question creation.", kind: .unhandled)
        return Fail<Int, PresentationError>(error: error).eraseToAnyPublisher()
      }

      return self.questionRepository.initialize(questions: questions).map { _ in
        questions.count
      }.mapError { PresentationError($0) }.eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
}
