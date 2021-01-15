//
//  ExamModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import Combine

protocol ExamModelProtocol: AnyObject {
    func fetchLastExamScore() -> AnyPublisher<PlayScore?, ModelError>
    func fetchExamKarutaNos() -> AnyPublisher<[UInt8], ModelError>
    func fetchPastExamsWrongKarutaNos() -> AnyPublisher<[UInt8], ModelError>
}

class ExamModel: ExamModelProtocol {
    private let karutaRepository: KarutaRepository
    private let examHistoryRepository: ExamHistoryRepository
    
    init(karutaRepository: KarutaRepository, examHistoryRepository: ExamHistoryRepository) {
        self.karutaRepository = karutaRepository
        self.examHistoryRepository = examHistoryRepository
    }

    func fetchLastExamScore() -> AnyPublisher<PlayScore?, ModelError> {
        let publisher = examHistoryRepository.findLast().map { examHistory -> PlayScore? in
            guard let examHistory = examHistory else {
                return nil
            }
            return PlayScore(tookDate: Date(), score: examHistory.resultSummary.score, averageAnswerSecText: "\(examHistory.resultSummary.averageAnswerSec)秒")
        }
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
    
    func fetchExamKarutaNos() -> AnyPublisher<[UInt8], ModelError> {
        let publisher = karutaRepository.findAll().map { $0.map { karuta in karuta.no.value } }
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
    
    func fetchPastExamsWrongKarutaNos() -> AnyPublisher<[UInt8], ModelError> {
        let publisher = examHistoryRepository.findCollection().map { $0.totalWrongKarutaNoCollection.values.map { karutaNo in karutaNo.value } }
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
