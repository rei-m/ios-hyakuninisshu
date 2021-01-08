//
//  MaterialTableModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation
import Combine

public enum ModelError: Error {
    case unhandled
}

protocol MaterialTableModelProtocol: AnyObject {
    func fetchKarutas() -> AnyPublisher<[Material], ModelError>
}

class MaterialTableModel: MaterialTableModelProtocol {
    
    private let karutaRepository: KarutaRepository
    
    init(karutaRepository: KarutaRepository) {
        self.karutaRepository = karutaRepository
    }

    func fetchKarutas() -> AnyPublisher<[Material], ModelError> {
        return karutaRepository.findAll().map { karutas in
            karutas.map { Material.fromKaruta($0) }
        }.mapError { _ in
            ModelError.unhandled
        }.eraseToAnyPublisher()
    }
}
