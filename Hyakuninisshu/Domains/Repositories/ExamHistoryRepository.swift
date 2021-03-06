//
//  ExamHistoryRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Combine
import CoreData
import Foundation

protocol ExamHistoryRepository {
  func findCollection() -> Future<ExamHistoryCollection, DomainError>
  func findLast() -> Future<ExamHistory?, DomainError>
  func add(_ examHistory: ExamHistory) -> Future<Void, DomainError>
  func delete(_ examHistories: [ExamHistory]) -> Future<Void, DomainError>
}
