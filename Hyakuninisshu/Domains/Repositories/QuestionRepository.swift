//
//  QuestionRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation
import CoreData

protocol QuestionRepositoryProtocol {
    func initialize(questions: [Question]) -> Result<Void, RepositoryError>
    
//    func count() -> Result<Int, RepositoryError>
//
//    func findById(id: QuestionId) -> Result<Question, RepositoryError>
//
//    func findByNo(no: Int) -> Result<Question, RepositoryError>
}

class QuestionRepository: QuestionRepositoryProtocol {

    private let container: NSPersistentContainer

    private var questions: [Question] = []
    
    init(container: NSPersistentContainer) {
        self.container = container
    }

    func initialize(questions: [Question]) -> Result<Void, RepositoryError> {
        self.questions = questions
        return Result.success(())
    }
}
