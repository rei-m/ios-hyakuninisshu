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
    func findCollection() -> Future<ExamHistoryCollection, RepositoryError>
    func findLast() -> Future<ExamHistory?, RepositoryError>
    func add(_ examHistory: ExamHistory) -> Future<Void, RepositoryError>
    func delete(_ examHistories: [ExamHistory]) -> Future<Void, RepositoryError>
}
