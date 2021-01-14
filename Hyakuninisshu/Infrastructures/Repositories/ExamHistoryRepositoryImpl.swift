//
//  ExamHistoryRepositoryImpl.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import CoreData
import Combine

private extension CDExamHistory {
    func toModel() -> ExamHistory {
        let resultSummary = QuestionResultSummary(
            totalQuestionCount: Int(totalQuestionCount),
            correctCount: Int(correctCount),
            averageAnswerSec: averageAnswerSec
        )
        
        guard let cdExamHistoryQuestionJudgements: [CDExamHistoryQuestionJudgement] = questionJudgements?.array as? [CDExamHistoryQuestionJudgement] else {
            fatalError("invalid")
        }
        
        return ExamHistory(id: ExamHistoryId.restore(id!), tookDate: tookDate!, resultSummary: resultSummary, questionJudgements: cdExamHistoryQuestionJudgements.map { QuestionJudgement(karutaNo: KarutaNo(Int8($0.karutaNo)), isCorrect: $0.isCorrect) })
    }
 
    func persistentFromModel(examHistory: ExamHistory) {
        id = examHistory.id.value
        correctCount = Int16(examHistory.resultSummary.correctCount)
        averageAnswerSec = examHistory.resultSummary.averageAnswerSec
        totalQuestionCount = Int16(examHistory.resultSummary.totalQuestionCount)
        tookDate = examHistory.tookDate
    }
}

class ExamHistoryRepositoryImpl: ExamHistoryRepository {
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func findCollection() -> Future<ExamHistoryCollection, RepositoryError> {
        let publisher = Future<ExamHistoryCollection, RepositoryError>{ promise in
            let fetchRequest: NSFetchRequest<CDExamHistory> = CDExamHistory.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tookDate", ascending: false)]
            let asyncFetch = NSAsynchronousFetchRequest<CDExamHistory>(fetchRequest: fetchRequest){ result in
                promise(.success(ExamHistoryCollection(result.finalResult?.map { $0.toModel() } ?? [])))
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
    
    func findLast() -> Future<ExamHistory?, RepositoryError> {
        let publisher = Future<ExamHistory?, RepositoryError>{ promise in
            let fetchRequest: NSFetchRequest<CDExamHistory> = CDExamHistory.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tookDate", ascending: false)]
            fetchRequest.fetchLimit = 1
            let asyncFetch = NSAsynchronousFetchRequest<CDExamHistory>(fetchRequest: fetchRequest){ result in
                let cdExamHistory = result.finalResult?.first
                promise(.success(cdExamHistory?.toModel()))
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

    func add(_ examHistory: ExamHistory)  -> Future<Void, RepositoryError> {
        let publisher = Future<Void, RepositoryError>{ promise in
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let context = self.container.viewContext
                    let cdExamHistory = CDExamHistory(context: context)
                    cdExamHistory.persistentFromModel(examHistory: examHistory)
                    examHistory.questionJudgements.forEach { judgement in
                        let cdJudgement = CDExamHistoryQuestionJudgement(context: context)
                        cdJudgement.isCorrect = judgement.isCorrect
                        cdJudgement.karutaNo = Int16(judgement.karutaNo.value)
                        cdJudgement.examHistory = cdExamHistory
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
        
        return publisher    }

    func delete(_ examHistories: [ExamHistory])  -> Future<Void, RepositoryError> {
        let publisher = Future<Void, RepositoryError>{ promise in
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let context = self.container.viewContext
            
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDQuestion.fetchRequest()
                    fetchRequest.predicate = NSPredicate(
                        format: "%K IN %@",
                        "id",
                        examHistories.map { $0.id.value }
                    )
                    
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    deleteRequest.resultType = .resultTypeStatusOnly
                    try context.execute(deleteRequest)

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
