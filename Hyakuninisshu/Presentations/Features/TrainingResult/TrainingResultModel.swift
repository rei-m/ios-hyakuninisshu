//
//  TrainingResultModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import Foundation
import Combine

protocol TrainingResultModelProtocol: AnyObject {
    func fetchResult() -> AnyPublisher<TrainingResult, ModelError>
}

class TrainingResultModel: TrainingResultModelProtocol {

    private let questionRepository: QuestionRepository
    
    init(questionRepository: QuestionRepository) {
        self.questionRepository = questionRepository
    }
    
    func fetchResult() -> AnyPublisher<TrainingResult, ModelError> {
        let publisher = self.questionRepository.findCollection().map { questionCollection -> TrainingResult in
            let resultSummary = questionCollection.resultSummary()
            let score = resultSummary.score()
            let averageAnswerSecText = "\(round(resultSummary.averageAnswerSec*100)/100)秒"
            let canRestart = questionCollection.canRestart()
            let wrongKarutaNos = questionCollection.wrongKarutaNoCollection().values.map { $0.value }
            return TrainingResult(score: score, averageAnswerSecText: averageAnswerSecText, canRestart: canRestart, wrongKarutaNos: wrongKarutaNos)
        }

        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
