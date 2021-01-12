//
//  QuestionRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation
import CoreData
import Combine

protocol QuestionRepository {
    func initialize(questions: [Question]) -> Future<Void, RepositoryError>
    func findByNo(no: Int) -> Future<Question, RepositoryError>
    func findCollection() -> Future<QuestionCollection, RepositoryError>
    func save(_ question: Question) -> Future<Void, RepositoryError>
}
