//
//  AnswerModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import Combine

protocol AnswerModelProtocol: AnyObject {
    func aggregateTrainingResult() -> AnyPublisher<TrainingResult, ModelError>
    func saveExamHistory() -> AnyPublisher<ExamResult, ModelError>
}

class AnswerModel: AnswerModelProtocol {
    private let karutaRepository: KarutaRepository
    private let questionRepository: QuestionRepository
    private let examHistoryRepository: ExamHistoryRepository

    init(karutaRepository: KarutaRepository, questionRepository: QuestionRepository, examHistoryRepository: ExamHistoryRepository) {
        self.karutaRepository = karutaRepository
        self.questionRepository = questionRepository
        self.examHistoryRepository = examHistoryRepository
    }
    
    func aggregateTrainingResult() -> AnyPublisher<TrainingResult, ModelError> {
        let publisher = self.questionRepository.findCollection().map { questionCollection -> TrainingResult in
            let resultSummary = questionCollection.resultSummary()
            let score = resultSummary.score()
            let averageAnswerSecText = "\(round(resultSummary.averageAnswerSec*100)/100)秒"
            let canRestart = questionCollection.canRestart()
            let wrongKarutaNos = questionCollection.wrongKarutaNoCollection().values.map { $0.value }
            return TrainingResult(score: score, averageAnswerSecText: averageAnswerSecText, canRestart: canRestart, wrongKarutaNos: wrongKarutaNos)
        }

        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
    
    func saveExamHistory() -> AnyPublisher<ExamResult, ModelError> {
        let publisher = self.questionRepository.findCollection().map { questionCollection -> ExamHistory in
            let resultSummary = questionCollection.resultSummary()
            var wrongKarutaNpSet: Set<KarutaNo> = Set()
            questionCollection.wrongKarutaNoCollection().values.forEach { wrongKarutaNpSet.insert($0) }
            let questionJudgements = KarutaNo.LIST.map { QuestionJudgement(karutaNo: $0, isCorrect: wrongKarutaNpSet.contains($0)) }
            return ExamHistory(id: ExamHistoryId(), tookDate: Date(), resultSummary: resultSummary, questionJudgements: questionJudgements)
        }.flatMap { examHistory in self.examHistoryRepository.add(examHistory).map { _ in examHistory }.eraseToAnyPublisher() }.zip(self.karutaRepository.findAll()).map { (examHistory, karutas) -> ExamResult in
            let score = examHistory.resultSummary.score()
            let averageAnswerSecText = "\(round(examHistory.resultSummary.averageAnswerSec*100)/100)秒"
            let judgements: [(Material, Bool)] = karutas.enumerated().map { (Material.fromKaruta($0.element), examHistory.questionJudgements[$0.offset].isCorrect) }
            return ExamResult(score: score, averageAnswerSecText: averageAnswerSecText, judgements: judgements)
        }
        
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
