//
//  QuestionRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Combine
import CoreData
import Foundation

protocol QuestionRepository {
  func initialize(questions: [Question]) -> Future<Void, DomainError>
  func findByNo(no: UInt8) -> Future<Question, DomainError>
  func findCollection() -> Future<QuestionCollection, DomainError>
  func save(_ question: Question) -> Future<Void, DomainError>
}
