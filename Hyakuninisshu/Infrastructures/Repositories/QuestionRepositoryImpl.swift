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
        let correctNo = KarutaNo(Int8(correct_karuta_no))
        guard let cdQuestionChoices: [CDQuestionChoice] = questionChoices?.array as? [CDQuestionChoice] else {
            fatalError("invalid")
        }
        let choices = cdQuestionChoices.map { KarutaNo(Int8($0.karuta_no)) }
        var state: QuestionState = .ready
        if (start_date != nil) {
            if (selected_karuta_no != 0) {
                let judgement = QuestionJudgement(karutaNo: correctNo, isCorrect: is_correct)
                let result = QuestionResult(selectedKarutaNo: KarutaNo(Int8(selected_karuta_no)), answerMillSec: answer_time, judgement: judgement)
                state = .answered(startDate: start_date!, result: result)
            } else {
                state = .inAnswer(startDate: start_date!)
            }
        }
        return Question(id: QuestionId.restore(id!),
                        no: Int(no),
                        choices: choices,
                        correctNo: correctNo,
                        state: state)
    }
    
    func persistentFromModel(question: Question) {
        id = question.id.value
        no = Int16(question.no)
        correct_karuta_no = Int16(question.correctNo.value)
        
        switch question.state {
        case .inAnswer(let startDate):
            start_date = startDate
        case .answered(let startDate, let result):
            start_date = startDate
            answer_time = result.answerMillSec
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

    func initialize(questions: [Question]) -> Future<Void, RepositoryError> {        
        let publisher = Future<Void, RepositoryError>{ promise in
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let context = self.container.viewContext
                    
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDQuestion.fetchRequest()
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    deleteRequest.resultType = .resultTypeStatusOnly
                    try context.execute(deleteRequest)
                    
                    let _ = questions.map { question in
                        let cdQuestion = CDQuestion(context: context)
                        cdQuestion.persistentFromModel(question: question)

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
                    let nserror = error as NSError
                    // TODO
                    print(nserror)
                    
                    promise(.failure(.io))
                }
            }
        }

        return publisher
    }
    
    func findCollection() -> Future<QuestionCollection, RepositoryError> {
        let publisher = Future<QuestionCollection, RepositoryError>{ promise in
            let fetchRequest: NSFetchRequest<CDQuestion> = CDQuestion.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "no", ascending: true)]

            let asyncFetch = NSAsynchronousFetchRequest<CDQuestion>(fetchRequest: fetchRequest){ result in
                guard let cdQuestions = result.finalResult else {
                    return
                }
                promise(.success(QuestionCollection(values: cdQuestions.map { $0.toModel() })))
            }

            do {
                let backgroundContext = self.container.newBackgroundContext()
                try backgroundContext.execute(asyncFetch)
            } catch let error {
                let nserror = error as NSError
                // TODO
                print(nserror)
                promise(.failure(.io))
            }
        }

        return publisher
    }
    
    func findByNo(no: Int) -> Future<Question, RepositoryError> {
        let publisher = Future<Question, RepositoryError>{ promise in
            let fetchRequest: NSFetchRequest<CDQuestion> = CDQuestion.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "%K = %d",
                "no",
                no
            )
            
            let asyncFetch = NSAsynchronousFetchRequest<CDQuestion>(fetchRequest: fetchRequest){ result in
                guard let cdQuestion = result.finalResult?.first else {
                    // TODO: not found
                    return
                }
                                
                promise(.success(cdQuestion.toModel()))
            }

            do {
                let backgroundContext = self.container.newBackgroundContext()
                try backgroundContext.execute(asyncFetch)
            } catch let error {
                let nserror = error as NSError
                // TODO
                print(nserror)
                promise(.failure(.io))
            }
        }

        return publisher
    }
    
    func save(_ question: Question) -> Future<Void, RepositoryError> {
        let publisher = Future<Void, RepositoryError>{ promise in
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let fetchRequest: NSFetchRequest<CDQuestion> = CDQuestion.fetchRequest()
                    fetchRequest.predicate = NSPredicate(
                        format: "%K = %@",
                        "id",
                        question.id.value as CVarArg
                    )
                                        
                    let context = self.container.viewContext
                    guard let cdQuestion = try context.fetch(fetchRequest).first else {
                        fatalError("unko")
                    }
                    cdQuestion.persistentFromModel(question: question)
                    try context.save()
                    promise(.success(()))
                } catch {
                    let nserror = error as NSError
                    // TODO
                    print(nserror)
                    
                    promise(.failure(.io))
                }
            }
        }

        return publisher
    }
}
