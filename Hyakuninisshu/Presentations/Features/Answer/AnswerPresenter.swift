//
//  AnswerPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Combine
import Foundation

protocol AnswerPresenterProtocol: AnyObject {
  func viewWillAppear()
  func didTapGoToNext()
  func didTapGoToTrainingResult(now: Date)
  func didTapGoToExamResult(now: Date)
}

class AnswerPresenter: AnswerPresenterProtocol {
  private weak var view: AnswerViewProtocol!
  private let model: AnswerModelProtocol

  private var cancellables = [AnyCancellable]()

  init(view: AnswerViewProtocol, model: AnswerModelProtocol) {
    self.view = view
    self.model = model
  }

  func viewWillAppear() {
    view.enableInteraction()
  }

  func didTapGoToNext() {
    view.presentNextQuestionVC()
  }

  func didTapGoToTrainingResult(now: Date) {
    view.disableInteraction()
    model.aggregateTrainingResult(finishDate: now).receive(on: DispatchQueue.main).sink(
      receiveCompletion: { [weak self] completion in
        self?.view.enableInteraction()
        guard case let .failure(error) = completion else {
          return
        }
        self?.view.presentErrorVC(error)
      },
      receiveValue: { [weak self] trainingResult in
        self?.view.presentTrainingResultVC(trainingResult)
      }
    ).store(in: &cancellables)
  }

  func didTapGoToExamResult(now: Date) {
    view.disableInteraction()
    model.aggregateExamResultAndSaveExamHistory(finishDate: now).receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          self?.view.enableInteraction()
          guard case let .failure(error) = completion else {
            return
          }
          self?.view.presentErrorVC(error)
        },
        receiveValue: { [weak self] examHistory in
          self?.view.presentExamResultVC(examHistory)
        }
      ).store(in: &cancellables)
  }
}
