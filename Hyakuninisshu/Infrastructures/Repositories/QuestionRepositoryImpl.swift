//
//  QuestionRepositoryImpl.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import CoreData
import Combine

private extension CDQuestion {
    func toModel() -> Question {
        let correctNo = KarutaNo(UInt8(correct_karuta_no))
        guard let cdQuestionChoices: [CDQuestionChoice] = questionChoices?.array as? [CDQuestionChoice] else {
            fatalError("Convert CDQuestion to Model failed")
        }
        let choices = cdQuestionChoices.map { KarutaNo(UInt8($0.karuta_no)) }
        var state: QuestionState = .ready
        if (start_date != nil) {
            if (selected_karuta_no != 0) {
                let judgement = QuestionJudgement(karutaNo: correctNo, isCorrect: is_correct)
                let result = QuestionResult(selectedKarutaNo: KarutaNo(UInt8(selected_karuta_no)), answerSec: answer_time, judgement: judgement)
                state = .answered(startDate: start_date!, result: result)
            } else {
                state = .inAnswer(startDate: start_date!)
            }
        }
        return Question(id: QuestionId.restore(id!),
                        no: UInt8(no),
                        choices: choices,
                        correctNo: correctNo,
                        state: state)
    }
    
    func persistFromModel(question: Question) {
        id = question.id.value
        no = Int16(question.no)
        correct_karuta_no = Int16(question.correctNo.value)
        
        switch question.state {
        case .inAnswer(let startDate):
            start_date = startDate
        case .answered(let startDate, let result):
            start_date = startDate
            answer_time = result.answerSec
            is_correct = result.judgement.isCorrect
            selected_karuta_no = Int16(result.selectedKarutaNo.value)
        case .ready: break
        }
    }
}

class QuestionRepositoryImpl: QuestionRepository {

    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }

    func initialize(questions: [Question]) -> Future<Void, DomainError> {        
        let publisher = Future<Void, DomainError>{ promise in
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let context = self.container.newBackgroundContext()
                    
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDQuestion.fetchRequest()
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    deleteRequest.resultType = .resultTypeStatusOnly
                    try context.execute(deleteRequest)
                    
                   questions.forEach { question in
                        let cdQuestion = CDQuestion(context: context)
                        cdQuestion.persistFromModel(question: question)

                        question.choices.enumerated().forEach { (idx, karutaNo) in
                            let cdQuestionChoice = CDQuestionChoice(context: context)
                            cdQuestionChoice.karuta_no = Int16(karutaNo.value)
                            cdQuestionChoice.order = Int16(idx + 1)
                            cdQuestionChoice.question = cdQuestion
                        }
                    }
                    try context.save()

                    promise(.success(()))
                } catch {
                    promise(.failure(.repository(error.localizedDescription)))
                }
            }
        }

        return publisher
    }
    
    func findCollection() -> Future<QuestionCollection, DomainError> {
        let publisher = Future<QuestionCollection, DomainError>{ promise in
            let fetchRequest: NSFetchRequest<CDQuestion> = CDQuestion.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "no", ascending: true)]

            let asyncFetch = NSAsynchronousFetchRequest<CDQuestion>(fetchRequest: fetchRequest){ result in
                promise(.success(QuestionCollection(result.finalResult?.map { $0.toModel() } ?? [])))
            }

            do {
                try self.container.newBackgroundContext().execute(asyncFetch)
            } catch let error {
                promise(.failure(.repository(error.localizedDescription)))
            }
        }

        return publisher
    }
    
    func findByNo(no: UInt8) -> Future<Question, DomainError> {
        let publisher = Future<Question, DomainError>{ promise in
            let fetchRequest: NSFetchRequest<CDQuestion> = CDQuestion.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "%K = %d",
                "no",
                no
            )
            
            let asyncFetch = NSAsynchronousFetchRequest<CDQuestion>(fetchRequest: fetchRequest){ result in
                guard let cdQuestion = result.finalResult?.first else {
                    promise(.failure(.repository("Not found question. no=\(no)")))
                    return
                }
                                
                promise(.success(cdQuestion.toModel()))
            }

            do {
                try self.container.newBackgroundContext().execute(asyncFetch)
            } catch let error {
                promise(.failure(.repository(error.localizedDescription)))
            }
        }

        return publisher
    }
    
    func save(_ question: Question) -> Future<Void, DomainError> {
        let publisher = Future<Void, DomainError>{ promise in
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let fetchRequest: NSFetchRequest<CDQuestion> = CDQuestion.fetchRequest()
                    fetchRequest.predicate = NSPredicate(
                        format: "%K = %@",
                        "id",
                        question.id.value as CVarArg
                    )
                                        
                    let context = self.container.newBackgroundContext()

                    guard let cdQuestion = try context.fetch(fetchRequest).first else {
                        promise(.failure(.repository("Not found question. id=\(question.id.value)")))
                        return
                    }
                    cdQuestion.persistFromModel(question: question)
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(.repository(error.localizedDescription)))
                }
            }
        }

        return publisher
    }
}
