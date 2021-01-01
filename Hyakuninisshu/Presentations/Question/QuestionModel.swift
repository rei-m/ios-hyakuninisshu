//
//  QuestionModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/31.
//

import Foundation
import Combine

protocol QuestionModelProtocol: AnyObject {
    func fetchPlay() -> AnyPublisher<Play, ModelError>
}

class QuestionModel: QuestionModelProtocol {
    let questionCount: Int
    let questionNo: Int
    let kamiNoKu: DisplayStyleCondition
    let shimoNoKu: DisplayStyleCondition
    let animationSpeed: AnimationSpeedCondition

    private let karutaRepository: KarutaRepositoryProtocol
    private let questionRepository: QuestionRepositoryProtocol
    
    init(
        questionCount: Int,
        questionNo: Int,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        animationSpeed: AnimationSpeedCondition,
        karutaRepository: KarutaRepositoryProtocol,
        questionRepository: QuestionRepositoryProtocol
    ) {
        self.questionCount = questionCount
        self.questionNo = questionNo
        self.kamiNoKu = kamiNoKu
        self.shimoNoKu = shimoNoKu
        self.animationSpeed = animationSpeed
        self.karutaRepository = karutaRepository
        self.questionRepository = questionRepository
    }
    
    func fetchPlay() -> AnyPublisher<Play, ModelError> {
        let publisher = self.questionRepository.findByNo(no: questionNo).flatMap { question in
            self.karutaRepository.findAll(karutaNos: question.choices).map { (question, $0) }
        }.map { (question, choiceKarutas) -> Play in
            var choiceKarutaMap: [Int8: Karuta] = [:]
            choiceKarutas.forEach { choiceKarutaMap[$0.no.value] = $0 }
            
            guard let yomiFuda = choiceKarutaMap[question.correctNo.value]?.toYomiFuda(style: self.kamiNoKu) else {
                // TODO
                fatalError()
            }
            
            let toriFudas = choiceKarutas.map { $0.toToriFuda(style: self.shimoNoKu) }

            return Play(no: question.no, totalCount: self.questionCount, yomiFuda: yomiFuda, toriFudas: toriFudas)
        }
        
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
