//
//  MaterialTableModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation

enum ModelError: Error {
    case unhandled
}

protocol MaterialTableModelProtocol: AnyObject {
    func fetchKarutas(completion: @escaping (Result<[Karuta], ModelError>) -> Void)
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
}
