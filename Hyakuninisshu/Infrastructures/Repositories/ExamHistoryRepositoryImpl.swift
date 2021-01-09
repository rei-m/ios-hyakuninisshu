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
    }
    
    func findCollection() -> AnyPublisher<ExamHistoryCollection, RepositoryError> {
        let publisher = Future<ExamHistoryCollection, RepositoryError>{ promise in
            promise(.success(ExamHistoryCollection([])))
        }

        return publisher.eraseToAnyPublisher()
    }
    
    func findLast() -> AnyPublisher<ExamHistory?, RepositoryError> {
        let publisher = Future<ExamHistory?, RepositoryError>{ promise in
            promise(.success(nil))
        }

        return publisher.eraseToAnyPublisher()
    }

    func add(_ examHistory: ExamHistory)  -> AnyPublisher<Void, RepositoryError> {
        let publisher = Future<Void, RepositoryError>{ promise in
            self.examHistories.append(examHistory)
            promise(.success(()))
        }
        
        return publisher.eraseToAnyPublisher()
    }

    func delete(_ examHistories: [ExamHistory])  -> AnyPublisher<Void, RepositoryError> {
        let publisher = Future<Void, RepositoryError>{ promise in
            self.examHistories.remove(at: 0)
            promise(.success(()))
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
