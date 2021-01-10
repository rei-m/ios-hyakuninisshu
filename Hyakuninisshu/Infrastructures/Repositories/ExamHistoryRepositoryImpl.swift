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
    
    func findCollection() -> Future<ExamHistoryCollection, RepositoryError> {
        let publisher = Future<ExamHistoryCollection, RepositoryError>{ promise in
            promise(.success(ExamHistoryCollection([])))
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
