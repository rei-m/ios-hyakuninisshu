//
//  QuestionModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/31.
//

import Foundation
import Combine

protocol QuestionModelProtocol: AnyObject {
    var questionNo: UInt8 { get }
    var kamiNoKu: DisplayStyleCondition { get }
    var shimoNoKu: DisplayStyleCondition { get }
    func fetchPlay() -> AnyPublisher<Play, ModelError>
    func answer(selectedNo: UInt8) -> AnyPublisher<Bool, ModelError>
}

class QuestionModel: QuestionModelProtocol {
    let questionNo: UInt8
    let kamiNoKu: DisplayStyleCondition
    let shimoNoKu: DisplayStyleCondition

    private let karutaRepository: KarutaRepository
    private let questionRepository: QuestionRepository
    
    init(
        questionNo: UInt8,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        karutaRepository: KarutaRepository,
        questionRepository: QuestionRepository
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
        }.flatMap { (question, choiceKarutas) -> AnyPublisher<(Question, [Karuta]), DomainError> in
            let started = question.start(startDate: Date())
            return self.questionRepository.save(started).map { _ in (started, choiceKarutas) }.eraseToAnyPublisher()
        }.map { (question, choiceKarutas) -> Play in
            var choiceKarutaMap: [KarutaNo: Karuta] = [:]
            choiceKarutas.forEach { choiceKarutaMap[$0.no] = $0 }
            
            guard let correctKaruta = choiceKarutaMap[question.correctNo] else {
                // TODO
                fatalError()
            }
            
            let correct = Material.fromKaruta(correctKaruta)
            let yomiFuda = YomiFuda.fromKamiNoKu(kamiNoKu: correctKaruta.kamiNoKu, style: self.kamiNoKu)
            let toriFudas = choiceKarutas.map { ToriFuda.fromShimoNoKu(shimoNoKu: $0.shimoNoKu, style: self.shimoNoKu) }
            
            return Play(no: question.no, yomiFuda: yomiFuda, toriFudas: toriFudas, correct: correct)
        }
        
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
    
    func answer(selectedNo: UInt8) -> AnyPublisher<Bool, ModelError> {
        let publisher = self.questionRepository.findByNo(no: questionNo).flatMap { question -> AnyPublisher<Question, DomainError> in
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
