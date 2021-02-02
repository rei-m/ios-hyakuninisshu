//
//  MaterialTablePresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Combine
import Foundation

protocol MaterialTablePresenterProtocol: AnyObject {
  func viewDidLoad()
}

class MaterialTablePresenter: MaterialTablePresenterProtocol {

  private weak var view: MaterialTableViewProtocol!
  private let model: MaterialTableModelProtocol

  private var cancellables = [AnyCancellable]()

  init(view: MaterialTableViewProtocol, model: MaterialTableModelProtocol) {
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
