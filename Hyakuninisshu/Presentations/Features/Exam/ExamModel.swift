//
//  ExamModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import Combine

protocol ExamModelProtocol: AnyObject {
    func fetchLastExamResult() -> AnyPublisher<LastExamResult?, ModelError>
    func fetchQuestionKarutaNos() -> AnyPublisher<[Int8], ModelError>
}

class ExamModel: ExamModelProtocol {
    private let karutaRepository: KarutaRepository
    private let examHistoryRepository: ExamHistoryRepository
    
    init(karutaRepository: KarutaRepository, examHistoryRepository: ExamHistoryRepository) {
        self.karutaRepository = karutaRepository
        self.examHistoryRepository = examHistoryRepository
    }

    func fetchLastExamResult() -> AnyPublisher<LastExamResult?, ModelError> {
        let publisher = examHistoryRepository.findLast().map { examHistory -> LastExamResult? in
            guard let examHistory = examHistory else {
                return nil
            }
            return LastExamResult(score: examHistory.resultSummary.score(), averageAnswerSecText: "\(round(examHistory.resultSummary.averageAnswerSec*100)/100)秒")
        }
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
    
    func fetchQuestionKarutaNos() -> AnyPublisher<[Int8], ModelError> {
        let publisher = karutaRepository.findAll().map { $0.map { karuta in karuta.no.value } }
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
