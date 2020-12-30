//
//  TrainingStarterModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import Foundation

protocol TrainingStarterModelProtocol: AnyObject {
    var kamiNoKuCondition: DisplayStyleCondition { get }
    var shimoNoKuCondition: DisplayStyleCondition { get }
    var animationSpeedCondition: AnimationSpeedCondition { get }
    func createQuestions() -> Int
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
    
    func createQuestions() -> Int {
        let allKarutaNoCollectionResult = karutaRepository.findAll().map { KarutaNoCollection(values: $0.map { $0.no }) }

        let targetKarutaNoCollectionResult = karutaRepository.findAllWithCondition(
            fromNo: KarutaNo(rangeFromCondition.no),
            toNo: KarutaNo(rangeToCondition.no),
            kimarijis: kimarijiCondition.value == nil ? Kimariji.ALL : [Kimariji.valueOf(value: kimarijiCondition.value!)],
            colors: colorCondition.value == nil  ? KarutaColor.ALL : [KarutaColor.valueOf(value: colorCondition.value!)]
        ).map { KarutaNoCollection(values: $0.shuffled().map { $0.no }) }

        guard case .success(let allKarutaNoCollection) = allKarutaNoCollectionResult else {
            // TODO
            fatalError("error")
        }
        
        guard case .success(let targetKarutaNoCollection) = targetKarutaNoCollectionResult else {
            // TODO
            fatalError("error")
        }
        
        guard let createQuestionsService = CreateQuestionsService(allKarutaNoCollection) else {
            // TODO
            fatalError("error")
        }
        
        guard let questions = createQuestionsService.execute(targetKarutaNoCollection: targetKarutaNoCollection, choiceSize: 4) else {
            // TODO
            return 0
        }

        switch questionRepository.initialize(questions: questions) {
        case .success:
            return questions.count
        case .failure(let e):
            dump(e)
            fatalError("error")
        }
    }
}
