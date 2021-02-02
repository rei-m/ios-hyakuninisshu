//
//  TrainingStarterViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/29.
//

import UIKit

protocol QuestionStarterViewProtocol: AnyObject {
  func displayEmptyMessage()
  func presentNextVC(questionCount: Int, questionNo: UInt8)
  func presentErrorVC(_ error: Error)
}

class QuestionStarterViewController: UIViewController {
  // MARK: - Outlet
  @IBOutlet weak var emptyMessageLabel: UILabel!

  // MARK: - Property
  private var presenter: QuestionStarterPresenterProtocol!

  private var kamiNoKu: DisplayStyleCondition!
  private var shimoNoKu: DisplayStyleCondition!
  private var animationSpeed: AnimationSpeedCondition!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLeftBackButton()
    presenter.viewDidLoad()
  }

  // MARK: - Method
  func inject(
    presenter: QuestionStarterPresenterProtocol,
    kamiNoKu: DisplayStyleCondition,
    shimoNoKu: DisplayStyleCondition,
    animationSpeed: AnimationSpeedCondition
  ) {
    self.presenter = presenter
    self.kamiNoKu = kamiNoKu
    self.shimoNoKu = shimoNoKu
    self.animationSpeed = animationSpeed
  }
}

extension QuestionStarterViewController: QuestionStarterViewProtocol {

  func displayEmptyMessage() {
    emptyMessageLabel.isHidden = false
  }

  func presentNextVC(questionCount: Int, questionNo: UInt8) {
    let vc: QuestionViewController = requireStoryboard.instantiateViewController(
      identifier: .question)

    let model = QuestionModel(
      questionNo: questionNo, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu,
      karutaRepository: diContainer.karutaRepository,
      questionRepository: diContainer.questionRepository)

    let presenter = QuestionPresenter(view: vc, model: model)

    vc.inject(questionCount: questionCount, animationSpeed: animationSpeed, presenter: presenter)

    requireNavigationController.pushViewController(vc, animated: false)
  }

  func presentErrorVC(_ error: Error) {
    presentUnexpectedErrorVC(error)
  }
}
