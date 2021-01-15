//
//  MaterialTableModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation
import Combine

protocol MaterialTableModelProtocol: AnyObject {
    func fetchKarutas() -> AnyPublisher<[Material], PresentationError>
}

class MaterialTableModel: MaterialTableModelProtocol {
    
    private let karutaRepository: KarutaRepository
    
    init(karutaRepository: KarutaRepository) {
        self.karutaRepository = karutaRepository
    }

    func fetchKarutas() -> AnyPublisher<[Material], PresentationError> {
        return karutaRepository.findAll().map { karutas in
            karutas.map { Material.fromKaruta($0) }
        }.mapError {
            PresentationError.unhandled($0)
        }.eraseToAnyPublisher()
    }
}
