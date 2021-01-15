//
//  DIContainer.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/15.
//

import Foundation
import CoreData

class DIContainer {
    let karutaRepository: KarutaRepository
    let questionRepository: QuestionRepository
    let examHistoryRepository: ExamHistoryRepository
    
    init(container: NSPersistentContainer) {
        self.karutaRepository = KarutaRepositoryImpl(container: container)
        self.questionRepository = QuestionRepositoryImpl(container: container)
        self.examHistoryRepository = ExamHistoryRepositoryImpl(container: container)
    }
}
