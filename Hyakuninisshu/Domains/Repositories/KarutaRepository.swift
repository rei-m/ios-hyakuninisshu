//
//  KarutaRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import CoreData
import Combine

protocol KarutaRepository {
    func initialize() -> AnyPublisher<Void, RepositoryError>
    func findAll() -> AnyPublisher<[Karuta], RepositoryError>
    func findAll(fromNo: KarutaNo, toNo: KarutaNo, kimarijis: [Kimariji], colors: [KarutaColor]) -> AnyPublisher<[Karuta], RepositoryError>
    func findAll(karutaNos: [KarutaNo]) -> AnyPublisher<[Karuta], RepositoryError>
}
