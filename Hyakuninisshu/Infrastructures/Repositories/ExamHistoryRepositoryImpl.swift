//
//  ExamHistoryRepositoryImpl.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import CoreData
import Combine

class ExamHistoryRepositoryImpl: ExamHistoryRepository {
    private let container: NSPersistentContainer

    private var examHistories: [ExamHistory] = []
    
    init(container: NSPersistentContainer) {
        self.container = container
        
        // TODO
        let questionJudgements = KarutaNo.LIST.map { QuestionJudgement(karutaNo: $0, isCorrect: true) }
        let dummy = ExamHistory(id: ExamHistoryId(), tookDate: Date(), resultSummary: QuestionResultSummary(totalQuestionCount: 100, correctCount: 100, averageAnswerSec: 3.6), questionJudgements: questionJudgements)
        examHistories.append(dummy)
    }
    
    func findCollection() -> Future<ExamHistoryCollection, RepositoryError> {
        let publisher = Future<ExamHistoryCollection, RepositoryError>{ promise in
            promise(.success(ExamHistoryCollection(self.examHistories)))
        }

        return publisher
    }
    
    func findLast() -> Future<ExamHistory?, RepositoryError> {
        let publisher = Future<ExamHistory?, RepositoryError>{ promise in
            promise(.success(self.examHistories.last))
        }

        return publisher
    }

    func add(_ examHistory: ExamHistory)  -> Future<Void, RepositoryError> {
        let publisher = Future<Void, RepositoryError>{ promise in
            self.examHistories.append(examHistory)
            promise(.success(()))
        }
        
        return publisher    }

    func delete(_ examHistories: [ExamHistory])  -> Future<Void, RepositoryError> {
        let publisher = Future<Void, RepositoryError>{ promise in
            self.examHistories.remove(at: 0)
            promise(.success(()))
        }
        
        return publisher
    }
}
