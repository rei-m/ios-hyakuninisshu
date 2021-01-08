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
    func initialize(questions: [Question]) -> AnyPublisher<Void, RepositoryError>
    func findByNo(no: Int) -> AnyPublisher<Question, RepositoryError>
    func findCollection() -> AnyPublisher<QuestionCollection, RepositoryError>
    func save(_ question: Question) -> AnyPublisher<Void, RepositoryError>
}
