//
//  ExamPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Combine
import Foundation

protocol ExamPresenterProtocol: AnyObject {
  func viewWillAppear()
  func didTapStartExamButton()
  func didTapStartTrainingButton()
}

class ExamPresenter: ExamPresenterProtocol {

  private weak var view: ExamViewProtocol!
  private let model: ExamModelProtocol

  private var cancellables = [AnyCancellable]()

  init(view: ExamViewProtocol, model: ExamModelProtocol) {
    self.view = view
    self.model = model
  }

  func viewWillAppear() {
    view.hideLastResult()
    view.enableInteraction()

    model.fetchLastExamScore().receive(on: DispatchQueue.main).sink(
      receiveCompletion: { [weak self] completion in
        guard case let .failure(error) = completion else {
          return
        }
        self?.view.presentErrorVC(error)
      },
      receiveValue: { [weak self] examScore in
        guard let examScore = examScore else {
          return
        }
        self?.view.displayLastResult(examScore)
      }
    ).store(in: &cancellables)
  }

  func didTapStartExamButton() {
    view.disableInteraction()
    model.fetchExamKarutaNos().receive(on: DispatchQueue.main).sink(
      receiveCompletion: { [weak self] completion in
        self?.view.enableInteraction()
        guard case let .failure(error) = completion else {
          return
        }
        self?.view.presentErrorVC(error)
      },
      receiveValue: { [weak self] karutaNos in
        self?.view.presentNextVC(karutaNos: karutaNos)
      }
    ).store(in: &cancellables)
  }

  func didTapStartTrainingButton() {
    view.disableInteraction()
    model.fetchPastExamsWrongKarutaNos().receive(on: DispatchQueue.main).sink(
      receiveCompletion: { [weak self] completion in
        self?.view.enableInteraction()
        guard case let .failure(error) = completion else {
          return
        }
        self?.view.presentErrorVC(error)
      },
      receiveValue: { [weak self] karutaNos in
        self?.view.presentNextVC(karutaNos: karutaNos)
      }
    ).store(in: &cancellables)
  }
}
