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

    func initialize(questions: [Question]) -> Future<Void, RepositoryError> {
        self.questions = questions
        
        let publisher = Future<Void, RepositoryError>{ promise in
            promise(.success(()))
        }

        return publisher
    }
    
    func findCollection() -> Future<QuestionCollection, RepositoryError> {
        let publisher = Future<QuestionCollection, RepositoryError>{ promise in
            promise(.success(QuestionCollection(values: self.questions)))
        }

        return publisher
    }
    
    func findByNo(no: Int) -> Future<Question, RepositoryError> {
        let publisher = Future<Question, RepositoryError>{ promise in
            promise(.success(self.questions[no - 1]))
        }

        return publisher
    }
    
    func save(_ question: Question) -> Future<Void, RepositoryError> {
        questions[question.no - 1] = question
        let publisher = Future<Void, RepositoryError>{ promise in
            promise(.success(()))
        }

        return publisher
    }
}
