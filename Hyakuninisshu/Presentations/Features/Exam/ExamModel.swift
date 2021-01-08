//
//  ExamModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import Combine

protocol ExamModelProtocol: AnyObject {
    func fetchQuestionKarutaNos() -> AnyPublisher<[Int8], ModelError>
}

class ExamModel: ExamModelProtocol {
    private let karutaRepository: KarutaRepositoryProtocol

    init(karutaRepository: KarutaRepositoryProtocol) {
        self.karutaRepository = karutaRepository
    }

    func fetchQuestionKarutaNos() -> AnyPublisher<[Int8], ModelError> {
        let publisher = karutaRepository.findAll().map { $0.map { karuta in karuta.no.value } }
        return publisher.mapError { _ in ModelError.unhandled }.eraseToAnyPublisher()
    }
}
