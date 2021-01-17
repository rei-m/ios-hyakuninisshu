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
    func initialize() -> Future<Void, DomainError>
    func findAll() -> Future<[Karuta], DomainError>
    func findAll(fromNo: KarutaNo, toNo: KarutaNo, kimarijis: [Kimariji], colors: [KarutaColor]) -> Future<[Karuta], DomainError>
    func findAll(karutaNos: [KarutaNo]) -> Future<[Karuta], DomainError>
}
