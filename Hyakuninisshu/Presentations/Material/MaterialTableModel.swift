//
//  MaterialTableModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation
import Combine

enum ModelError: Error {
    case unhandled
}

protocol MaterialTableModelProtocol: AnyObject {
    func fetchKarutas(completion: @escaping (Result<[Karuta], ModelError>) -> Void)
    func fetchKarutas2() -> AnyPublisher<[Material], ModelError>
}

class MaterialTableModel: MaterialTableModelProtocol {
    
    private let karutaRepository: KarutaRepositoryProtocol
    
    init(karutaRepository: KarutaRepositoryProtocol) {
        self.karutaRepository = karutaRepository
    }
    
    // TODO: 非同期で呼ばれることを想定してこのIFにしてる
    func fetchKarutas(completion: @escaping (Result<[Karuta], ModelError>) -> Void) {
        switch karutaRepository.findAll() {
        case .success(let karutas):
            completion(Result.success(karutas))
        case .failure(_):
            completion(Result.failure(ModelError.unhandled))
        }
    }
    
    func fetchKarutas2() -> AnyPublisher<[Material], ModelError> {
        return karutaRepository.findAll2().map { karutas in
            karutas.map { $0.toMaterial() }
        }.mapError { _ in
            ModelError.unhandled
        }.eraseToAnyPublisher()
    }
}
