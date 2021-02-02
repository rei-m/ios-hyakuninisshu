//
//  ExamHistoryRepositoryImpl.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Combine
import CoreData
import Foundation

extension CDExamHistory {
  fileprivate func toModel() -> ExamHistory {
    let resultSummary = QuestionResultSummary(
      totalQuestionCount: UInt8(totalQuestionCount),
      correctCount: UInt8(correctCount),
      averageAnswerSec: averageAnswerSec
    )

    let cdExamHistoryQuestionJudgements: [CDExamHistoryQuestionJudgement] =
      questionJudgements?.array as? [CDExamHistoryQuestionJudgement] ?? []
    let questionJudgements = cdExamHistoryQuestionJudgements.map {
      QuestionJudgement(karutaNo: KarutaNo(UInt8($0.karutaNo)), isCorrect: $0.isCorrect)
    }

    return ExamHistory(
      id: ExamHistoryId.restore(id!), tookDate: tookDate!, resultSummary: resultSummary,
      questionJudgements: questionJudgements)
  }

  fileprivate func persistFromModel(examHistory: ExamHistory) {
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

  func findCollection() -> Future<ExamHistoryCollection, DomainError> {
    let publisher = Future<ExamHistoryCollection, DomainError> { promise in
      let fetchRequest: NSFetchRequest<CDExamHistory> = CDExamHistory.fetchRequest()
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tookDate", ascending: false)]

      let asyncFetch = NSAsynchronousFetchRequest<CDExamHistory>(fetchRequest: fetchRequest) {
        result in
        promise(.success(ExamHistoryCollection(result.finalResult?.map { $0.toModel() } ?? [])))
      }

      do {
        try self.container.newBackgroundContext().execute(asyncFetch)
      } catch let error {
        let domainError = DomainError(reason: error.localizedDescription, kind: .repository)
        promise(.failure(domainError))
      }
    }

    return publisher
  }

  func findLast() -> Future<ExamHistory?, DomainError> {
    let publisher = Future<ExamHistory?, DomainError> { promise in
      let fetchRequest: NSFetchRequest<CDExamHistory> = CDExamHistory.fetchRequest()
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tookDate", ascending: false)]
      fetchRequest.fetchLimit = 1

      let asyncFetch = NSAsynchronousFetchRequest<CDExamHistory>(fetchRequest: fetchRequest) {
        result in
        let cdExamHistory = result.finalResult?.first
        promise(.success(cdExamHistory?.toModel()))
      }

      do {
        try self.container.newBackgroundContext().execute(asyncFetch)
      } catch let error {
        let domainError = DomainError(reason: error.localizedDescription, kind: .repository)
        promise(.failure(domainError))
      }
    }

    return publisher
  }

  func add(_ examHistory: ExamHistory) -> Future<Void, DomainError> {
    let publisher = Future<Void, DomainError> { promise in
      DispatchQueue.global(qos: .userInteractive).async {
        do {
          let context = self.container.newBackgroundContext()
          let cdExamHistory = CDExamHistory(context: context)
          cdExamHistory.persistFromModel(examHistory: examHistory)
          examHistory.questionJudgements.forEach { judgement in
            let cdJudgement = CDExamHistoryQuestionJudgement(context: context)
            cdJudgement.isCorrect = judgement.isCorrect
            cdJudgement.karutaNo = Int16(judgement.karutaNo.value)
            cdJudgement.examHistory = cdExamHistory
          }

          try context.save()

          promise(.success(()))
        } catch {
          let domainError = DomainError(reason: error.localizedDescription, kind: .repository)
          promise(.failure(domainError))
        }
      }
    }

    return publisher
  }

  func delete(_ examHistories: [ExamHistory]) -> Future<Void, DomainError> {
    let publisher = Future<Void, DomainError> { promise in
      DispatchQueue.global(qos: .userInteractive).async {
        do {
          let context = self.container.newBackgroundContext()

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
          let domainError = DomainError(reason: error.localizedDescription, kind: .repository)
          promise(.failure(domainError))
        }
      }
    }

    return publisher
  }
}
