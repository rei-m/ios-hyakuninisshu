//
//  TrainingPresenter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/27.
//

import Combine
import Foundation

protocol TrainingPresenterProtocol: AnyObject {
  func viewDidLoad()
  func viewWillAppear()
  func didTapCondition()
  func didChangeRangeFrom(_ condition: RangeCondition)
  func didChangeRangeTo(_ condition: RangeCondition)
  func didChangeKimariji(_ condition: KimarijiCondition)
  func didChangeColor(_ condition: ColorCondition)
  func didChangeKamiNoKu(_ condition: DisplayStyleCondition)
  func didChangeShimoNoKu(_ condition: DisplayStyleCondition)
  func didChangeAnimationSpeed(_ condition: AnimationSpeedCondition)
  func didStartTrainingButtonTapDone()
  func didTapMask()
}

class TrainingPresenter: TrainingPresenterProtocol {

  private weak var view: TrainingViewProtocol!
  private let model: TrainingModelProtocol

  private var cancellables = [AnyCancellable]()

  init(view: TrainingViewProtocol, model: TrainingModelProtocol) {
    self.view = view
    self.model = model
  }

  func viewDidLoad() {
    view.initSettings(
      rangeFrom: model.rangeFromCondition,
      rangeTo: model.rangeToCondition,
      kimariji: model.kimarijiCondition,
      color: model.colorCondition,
      kamiNoKu: model.kamiNoKuCondition,
      shimoNoKu: model.shimoNoKuCondition,
      animationSpeed: model.animationSpeedCondition
    )
  }

  func viewWillAppear() {
    view.enableInteraction()
  }

  func didTapCondition() {
    view.toggleMask(true)
  }

  func didChangeRangeFrom(_ condition: RangeCondition) {
    model.rangeFromCondition = condition
    view.updateRangeFrom(condition)
    view.updateRangeError(model.rangeConditionError)
    view.toggleMask(false)
  }

  func didChangeRangeTo(_ condition: RangeCondition) {
    model.rangeToCondition = condition
    view.updateRangeTo(condition)
    view.updateRangeError(model.rangeConditionError)
    view.toggleMask(false)
  }

  func didChangeKimariji(_ condition: KimarijiCondition) {
    model.kimarijiCondition = condition
    view.updateKimariji(condition)
    view.toggleMask(false)
  }

  func didChangeColor(_ condition: ColorCondition) {
    model.colorCondition = condition
    view.updateColor(condition)
    view.toggleMask(false)
  }

  func didChangeKamiNoKu(_ condition: DisplayStyleCondition) {
    model.kamiNoKuCondition = condition
    view.updateKamiNoKu(condition)
    view.toggleMask(false)
  }

  func didChangeShimoNoKu(_ condition: DisplayStyleCondition) {
    model.shimoNoKuCondition = condition
    view.updateShimoNoKu(condition)
    view.toggleMask(false)
  }

  func didChangeAnimationSpeed(_ condition: AnimationSpeedCondition) {
    model.animationSpeedCondition = condition
    view.updateAnimationSpeed(condition)
    view.toggleMask(false)
  }

  func didStartTrainingButtonTapDone() {
    if model.hasError {
      view.showAlertDialog()
      return
    }

    view.disableInteraction()

    model.fetchQuestionKarutaNos().receive(on: DispatchQueue.main).sink(
      receiveCompletion: { [weak self] completion in
        self?.view.enableInteraction()
        guard case let .failure(error) = completion else {
          return
        }
        self?.view.presentErrorVC(error)
      },
      receiveValue: { [weak self] karutaNos in
        guard let model = self?.model else {
          return
        }
        self?.view.presentNextVC(
          karutaNos: karutaNos,
          kamiNoKu: model.kamiNoKuCondition,
          shimoNoKu: model.shimoNoKuCondition,
          animationSpeed: model.animationSpeedCondition
        )
      }
    ).store(in: &cancellables)
  }

  func didTapMask() {
    view.toggleMask(false)
  }
}
