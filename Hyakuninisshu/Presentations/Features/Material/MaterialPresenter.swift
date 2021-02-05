//
//  MaterialPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/02/05.
//

import Combine
import Foundation

protocol MaterialPresenterProtocol: AnyObject {
  func viewDidLoad()
}

class MaterialPresenter: MaterialPresenterProtocol {

  private weak var view: MaterialViewProtocol!
  private let model: MaterialModelProtocol

  private var cancellables = [AnyCancellable]()

  init(view: MaterialViewProtocol, model: MaterialModelProtocol) {
    self.view = view
    self.model = model
  }

  func viewDidLoad() {
    view.updateLoading(true)
    model.fetchKarutas().receive(on: DispatchQueue.main).sink(
      receiveCompletion: { [weak self] completion in
        self?.view.updateLoading(false)
        guard case let .failure(error) = completion else {
          return
        }
        self?.view.presentErrorVC(error)
      },
      receiveValue: { [weak self] materials in
        self?.view.updateMaterialTable(materials)
      }
    ).store(in: &cancellables)
  }
}
