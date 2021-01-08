//
//  QuestionModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/31.
//

import Foundation
import Combine

protocol QuestionModelProtocol: AnyObject {
    var questionNo: Int { get }
    var kamiNoKu: DisplayStyleCondition { get }
    var shimoNoKu: DisplayStyleCondition { get }
    func fetchPlay() -> AnyPublisher<Play, ModelError>
    func answer(selectedNo: Int8) -> AnyPublisher<Bool, ModelError>
}

class QuestionModel: QuestionModelProtocol {
    let questionNo: Int
    let kamiNoKu: DisplayStyleCondition
    let shimoNoKu: DisplayStyleCondition

    private let karutaRepository: KarutaRepositoryProtocol
    private let questionRepository: QuestionRepositoryProtocol
    
    init(
        questionNo: Int,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        karutaRepository: KarutaRepositoryProtocol,
        questionRepository: QuestionRepositoryProtocol
    ) {
        self.questionNo = questionNo
        self.kamiNoKu = kamiNoKu
        self.shimoNoKu = shimoNoKu
        self.karutaRepository = karutaRepository
        self.questionRepository = questionRepository
    }
    
    // TODO
    func fetchPlay() -> AnyPublisher<Play, ModelError> {
        let publisher = self.questionRepository.findByNo(no: questionNo).flatMap { question in
            self.karutaRepository.findAll(karutaNos: question.choices).map { (question, $0) }
        }.flatMap { (question, choiceKarutas) -> AnyPublisher<(Question, [Karuta]), RepositoryError> in
            let started = question.start(startDate: Date())
            return self.questionRepository.save(started).map { _ in (started, choiceKarutas) }.eraseToAnyPublisher()
        }.map { (question, choiceKarutas) -> Play in
            var choiceKarutaMap: [Int8: Karuta] = [:]
            choiceKarutas.forEach { choiceKarutaMap[$0.no.value] = $0 }
            
            guard let yomiFuda = choiceKarutaMap[question.correctNo.value]?.toYomiFuda(style: self.kamiNoKu) else {
                // TODO
                fatalError()
            }
            guard let correct = choiceKarutaMap[question.correctNo.value]?.toMaterial() else {
                fatalError()
            }
            
            let toriFudas = choiceKarutas.map { $0.toToriFuda(style: self.shimoNoKu) }
            
            return Play(no: question.no, yomiFuda: yomiFuda, toriFudas: toriFudas, correct: correct)
        }
        
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
    
    func answer(selectedNo: Int8) -> AnyPublisher<Bool, ModelError> {
        let publisher = self.questionRepository.findByNo(no: questionNo).flatMap { question -> AnyPublisher<Question, RepositoryError> in
            let answered = question.verify(selectedNo: KarutaNo(selectedNo), answerDate: Date())
            return self.questionRepository.save(answered).map { _ in answered }.eraseToAnyPublisher()
        }.map { answered -> Bool in
            guard case .answered( _, let result) = answered.state else {
                // TODO
                fatalError("error")
            }
            return result.judgement.isCorrect
        }

        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
