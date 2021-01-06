//
//  TrainingResultModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import Foundation
import Combine

protocol TrainingResultModelProtocol: AnyObject {
    var kamiNoKu: DisplayStyleCondition { get }
    var shimoNoKu: DisplayStyleCondition { get }
    var animationSpeed: AnimationSpeedCondition { get }
    func fetchResult() -> AnyPublisher<TrainingResult, ModelError>
}

class TrainingResultModel: TrainingResultModelProtocol {
    let kamiNoKu: DisplayStyleCondition
    let shimoNoKu: DisplayStyleCondition
    let animationSpeed: AnimationSpeedCondition

    private let questionRepository: QuestionRepositoryProtocol
    
    init(
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        animationSpeed: AnimationSpeedCondition,
        questionRepository: QuestionRepositoryProtocol
    ) {
        self.kamiNoKu = kamiNoKu
        self.shimoNoKu = shimoNoKu
        self.animationSpeed = animationSpeed
        self.questionRepository = questionRepository
    }
    
    func fetchResult() -> AnyPublisher<TrainingResult, ModelError> {
        let publisher = self.questionRepository.findCollection().map { questionCollection -> TrainingResult in
            let resultSummary = questionCollection.resultSummary()
            let score = resultSummary.score()
            let averageAnswerSecText = "\(round(resultSummary.averageAnswerSec*100)/100)秒"
            let canRestart = questionCollection.canRestart()
            return TrainingResult(score: score, averageAnswerSecText: averageAnswerSecText, canRestart: canRestart)
        }

        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
