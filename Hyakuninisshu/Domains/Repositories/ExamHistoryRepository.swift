//
//  ExamHistoryRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import CoreData
import Combine

protocol ExamHistoryRepository {
    func findCollection() -> AnyPublisher<ExamHistoryCollection, RepositoryError>
    func findLast() -> AnyPublisher<ExamHistory?, RepositoryError>
    func add(_ examHistory: ExamHistory)  -> AnyPublisher<Void, RepositoryError>
    func delete(_ examHistories: [ExamHistory])  -> AnyPublisher<Void, RepositoryError>
}
