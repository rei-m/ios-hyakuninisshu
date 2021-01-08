//
//  TrainingStarterModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import Foundation
import Combine

protocol QuestionStarterModelProtocol: AnyObject {
    func createQuestions() -> AnyPublisher<Int, ModelError>
}

class QuestionStarterModel: QuestionStarterModelProtocol {
    let karutaNos: [Int8]
    
    private let karutaRepository: KarutaRepository
    private let questionRepository: QuestionRepository
    
    init(
        karutaNos: [Int8],
        karutaRepository: KarutaRepository,
        questionRepository: QuestionRepository
    ) {
        self.karutaNos = karutaNos
        self.karutaRepository = karutaRepository
        self.questionRepository = questionRepository
    }
    
    func createQuestions() -> AnyPublisher<Int, ModelError> {
        let targetKarutaNoCollection = KarutaNoCollection(values: karutaNos.shuffled().map { KarutaNo($0) })
        let allKarutaNoCollectionPublisher = karutaRepository.findAll().map { KarutaNoCollection(values: $0.map { $0.no }) }
        let questionsPublisher = allKarutaNoCollectionPublisher.map { allKarutaNoCollection -> [Question]? in
            guard let createQuestionsService = CreateQuestionsService(allKarutaNoCollection) else {
                // TODO
                fatalError("error")
            }
            return createQuestionsService.execute(targetKarutaNoCollection: targetKarutaNoCollection, choiceSize: 4)
        }.flatMap { questions -> AnyPublisher<Int, RepositoryError> in
            guard let questions = questions else {
                return Just(0).mapError { _ in RepositoryError.unhandled }.eraseToAnyPublisher()
            }
            
            return self.questionRepository.initialize(questions: questions).map { _ in
                questions.count
            }.eraseToAnyPublisher()
        }
        
        return questionsPublisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
