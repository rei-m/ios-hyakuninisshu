//
//  QuestionRepositoryImpl.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import CoreData
import Combine

class QuestionRepositoryImpl: QuestionRepository {

    private let container: NSPersistentContainer

    private var questions: [Question] = []
    
    init(container: NSPersistentContainer) {
        self.container = container
    }

    func initialize(questions: [Question]) -> AnyPublisher<Void, RepositoryError> {
        self.questions = questions
        
        let publisher = Future<Void, RepositoryError>{ promise in
            promise(.success(()))
        }

        return publisher.eraseToAnyPublisher()
    }
    
    func findCollection() -> AnyPublisher<QuestionCollection, RepositoryError> {
        let publisher = Future<QuestionCollection, RepositoryError>{ promise in
            promise(.success(QuestionCollection(values: self.questions)))
        }

        return publisher.eraseToAnyPublisher()
    }
    
    func findByNo(no: Int) -> AnyPublisher<Question, RepositoryError> {
        let publisher = Future<Question, RepositoryError>{ promise in
            promise(.success(self.questions[no - 1]))
        }

        return publisher.eraseToAnyPublisher()
    }
    
    func save(_ question: Question) -> AnyPublisher<Void, RepositoryError> {
        questions[question.no - 1] = question
        let publisher = Future<Void, RepositoryError>{ promise in
            promise(.success(()))
        }

        return publisher.eraseToAnyPublisher()
    }
}
