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

    func start(startDate: Date) -> AnyPublisher<Play, PresentationError>
    func answer(answerDate: Date, selectedNo: UInt8) -> AnyPublisher<Bool, PresentationError>
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
    
    func start(startDate: Date) -> AnyPublisher<Play, PresentationError> {
        let publisher = self.questionRepository.findByNo(no: questionNo).flatMap { question in
            self.karutaRepository.findAll(karutaNos: question.choices).map { (question, $0) }
        }.flatMap { (question, choiceKarutas) -> AnyPublisher<(Question, [Karuta]), DomainError> in
            do {
                let started = try question.start(startDate: startDate)
                return self.questionRepository.save(started).map { _ in (started, choiceKarutas) }.eraseToAnyPublisher()
            } catch let error {
                return self.handleCatchError(error)
            }
        }.map { (question, choiceKarutas) -> Play in
            var choiceKarutaMap: [KarutaNo: Karuta] = [:]
            choiceKarutas.forEach { choiceKarutaMap[$0.no] = $0 }
            
            guard let correctKaruta = choiceKarutaMap[question.correctNo] else {
                preconditionFailure("Unexpected question. correctNo is missing.")
            }

            let correct = Material.fromKaruta(correctKaruta)
            let yomiFuda = YomiFuda.fromKamiNoKu(kamiNoKu: correctKaruta.kamiNoKu, style: self.kamiNoKu)
            let toriFudas = choiceKarutas.map { ToriFuda.fromShimoNoKu(shimoNoKu: $0.shimoNoKu, style: self.shimoNoKu) }
            
            return Play(no: question.no, yomiFuda: yomiFuda, toriFudas: toriFudas, correct: correct)
        }
        
        return publisher.mapError { PresentationError($0) }.eraseToAnyPublisher()
    }
    
    func answer(answerDate: Date, selectedNo: UInt8) -> AnyPublisher<Bool, PresentationError> {
        let publisher = self.questionRepository.findByNo(no: questionNo).flatMap { question -> AnyPublisher<Bool, DomainError> in
            do {
                let answered = try question.verify(selectedNo: KarutaNo(selectedNo), answerDate: answerDate)
                return self.questionRepository.save(answered).map { _ in
                    guard case .answered( _, let result) = answered.state else {
                        preconditionFailure("Unexpected question. state is not answered.")
                    }
                    return result.judgement.isCorrect
                }.eraseToAnyPublisher()
            } catch let error {
                return self.handleCatchError(error)
            }
        }

        return publisher.mapError { PresentationError($0) }.eraseToAnyPublisher()
    }
    
    private func handleCatchError<Output>(_ error: Error) -> AnyPublisher<Output, DomainError> {
        guard let error = error as? DomainError else {
            return Fail<Output, DomainError>(error: DomainError(reason: "unhandled", kind: .unhandled)).eraseToAnyPublisher()
        }
    
        return Fail<Output, DomainError>(error: error).eraseToAnyPublisher()
    }
}
