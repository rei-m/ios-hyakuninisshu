//
//  MaterialTableModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation

protocol MaterialTableModelProtocol {
    func fetchKarutas(completion: @escaping (Result<[Karuta], Error>) -> Void)
}

class MaterialTableModel: MaterialTableModelProtocol {

    // MARK - Properties
    
    private let karutaRepository: KarutaRepositoryProtocol
    
    init(karutaRepository: KarutaRepositoryProtocol) {
        self.karutaRepository = karutaRepository
    }
    
    func fetchKarutas(completion: @escaping (Result<[Karuta], Error>) -> Void) {
//        queryService.getSearchResults(searchCompletion: completion)
    }
}
