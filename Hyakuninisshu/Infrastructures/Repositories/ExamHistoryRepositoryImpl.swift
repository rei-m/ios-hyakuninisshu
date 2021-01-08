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
    
    func findAll() -> AnyPublisher<[ExamHistory], RepositoryError> {
        let publisher = Future<[ExamHistory], RepositoryError>{ promise in
            promise(.success([]))
        }

        return publisher.eraseToAnyPublisher()
    }
    
    func findLast() -> AnyPublisher<ExamHistory?, RepositoryError> {
        let publisher = Future<ExamHistory?, RepositoryError>{ promise in
            promise(.success(nil))
        }

        return publisher.eraseToAnyPublisher()
    }
}
