//
//  TrainingStarterModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import Foundation
import Combine

protocol TrainingStarterModelProtocol: AnyObject {
    var kamiNoKuCondition: DisplayStyleCondition { get }
    var shimoNoKuCondition: DisplayStyleCondition { get }
    var animationSpeedCondition: AnimationSpeedCondition { get }
    func createQuestions() -> AnyPublisher<Int, ModelError>
}

class TrainingStarterModel: TrainingStarterModelProtocol {
    let rangeFromCondition: RangeCondition
    let rangeToCondition: RangeCondition
    let kimarijiCondition: KimarijiCondition
    let colorCondition: ColorCondition
    let kamiNoKuCondition: DisplayStyleCondition
    let shimoNoKuCondition: DisplayStyleCondition
    let animationSpeedCondition: AnimationSpeedCondition
    
    private let karutaRepository: KarutaRepositoryProtocol
    private let questionRepository: QuestionRepositoryProtocol
    
    init(
        rangeFromCondition: RangeCondition,
        rangeToCondition: RangeCondition,
        kimarijiCondition: KimarijiCondition,
        colorCondition: ColorCondition,
        kamiNoKuCondition: DisplayStyleCondition,
        shimoNoKuCondition: DisplayStyleCondition,
        animationSpeedCondition: AnimationSpeedCondition,
        karutaRepository: KarutaRepositoryProtocol,
        questionRepository: QuestionRepositoryProtocol
    ) {
        self.rangeFromCondition = rangeFromCondition
        self.rangeToCondition = rangeToCondition
        self.kimarijiCondition = kimarijiCondition
        self.colorCondition = colorCondition
        self.kamiNoKuCondition = kamiNoKuCondition
        self.shimoNoKuCondition = shimoNoKuCondition
        self.animationSpeedCondition = animationSpeedCondition
        self.karutaRepository = karutaRepository
        self.questionRepository = questionRepository
    }
    
    func createQuestions() -> AnyPublisher<Int, ModelError> {
        let allKarutaNoCollectionPublisher = karutaRepository.findAll().map { KarutaNoCollection(values: $0.map { $0.no }) }
        let targetKarutaNoCollectionPublisher = karutaRepository.findAll(
            fromNo: KarutaNo(rangeFromCondition.no),
            toNo: KarutaNo(rangeToCondition.no),
            kimarijis: kimarijiCondition.value == nil ? Kimariji.ALL : [Kimariji.valueOf(value: kimarijiCondition.value!)],
            colors: colorCondition.value == nil  ? KarutaColor.ALL : [KarutaColor.valueOf(value: colorCondition.value!)]
        ).map { KarutaNoCollection(values: $0.shuffled().map { $0.no }) }
        
        let questionsPublisher = allKarutaNoCollectionPublisher.zip(targetKarutaNoCollectionPublisher).map { (allKarutaNoCollection , targetKarutaNoCollection) -> [Question]? in
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
