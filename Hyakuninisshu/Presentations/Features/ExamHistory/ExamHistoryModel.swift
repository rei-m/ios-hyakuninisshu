//
//  ExamHistoryModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/11.
//

import Foundation
import Combine

protocol ExamHistoryModelProtocol: AnyObject {
    func fetchScores() -> AnyPublisher<[PlayScore], ModelError>
}

class ExamHistoryModel: ExamHistoryModelProtocol {
    private let examHistoryRepository: ExamHistoryRepository
    
    init(examHistoryRepository: ExamHistoryRepository) {
        self.examHistoryRepository = examHistoryRepository
    }

    func fetchScores() -> AnyPublisher<[PlayScore], ModelError> {
        let publisher = examHistoryRepository.findCollection().map { examHistoryCollection -> [PlayScore] in
            return examHistoryCollection.values.map { examHistory in
                return PlayScore(tookDate: examHistory.tookDate, score: examHistory.resultSummary.score(), averageAnswerSecText: "\(round(examHistory.resultSummary.averageAnswerSec*100)/100)秒")
            }
        }
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
