//
//  ExamHistoryPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/11.
//

import Combine
import Foundation

protocol ExamHistoryPresenterProtocol: AnyObject {
  func viewDidLoad()
}

class ExamHistoryPresenter: ExamHistoryPresenterProtocol {

  private weak var view: ExamHistoryViewProtocol!
  private let model: ExamHistoryModelProtocol

  private var cancellables = [AnyCancellable]()

  init(view: ExamHistoryViewProtocol, model: ExamHistoryModelProtocol) {
    self.view = view
    self.model = model
  }

  func viewDidLoad() {
    model.fetchScores().receive(on: DispatchQueue.main).sink(
      receiveCompletion: { [weak self] completion in
        guard case .failure(let error) = completion else {
          return
        }
        self?.view.presentErrorVC(error)
      },
      receiveValue: { [weak self] scores in
        self?.view.updateTable(scores)
      }
    ).store(in: &cancellables)
  }
}
