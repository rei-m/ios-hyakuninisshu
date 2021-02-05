//
//  MaterialModel.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/02/05.
//

import Combine
import Foundation

protocol MaterialModelProtocol: AnyObject {
  func fetchKarutas() -> AnyPublisher<[Material], PresentationError>
}

class MaterialModel: MaterialModelProtocol {

  private let karutaRepository: KarutaRepository

  init(karutaRepository: KarutaRepository) {
    self.karutaRepository = karutaRepository
  }

  func fetchKarutas() -> AnyPublisher<[Material], PresentationError> {
    return karutaRepository.findAll().map { karutas in
      karutas.map { Material.fromKaruta($0) }
    }.mapError {
      PresentationError($0)
    }.eraseToAnyPublisher()
  }
}
