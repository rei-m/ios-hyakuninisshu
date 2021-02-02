//
//  AnswerViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/04.
//

import Combine
import UIKit

protocol AnswerViewProtocol: AnyObject {
  func presentNextQuestionVC()
  func presentTrainingResultVC(_ trainingResult: TrainingResult)
  func presentExamResultVC(_ examResult: ExamResult)
  func presentErrorVC(_ error: Error)
}

class AnswerViewController: UIViewController {
  // MARK: - Outlet
  @IBOutlet weak var fudaView: FudaView!
  @IBOutlet weak var noAndKimarijiLabel: UILabel!
  @IBOutlet weak var creatorLabel: UILabel!
  @IBOutlet weak var goToNextButton: ActionButton!
  @IBOutlet weak var goToResultButton: ActionButton!

  // MARK: - Property
  private var presenter: AnswerPresenterProtocol!

  private var material: Material!
  private var questionNo: UInt8!
  private var questionCount: Int!
  private var kamiNoKu: DisplayStyleCondition!
  private var shimoNoKu: DisplayStyleCondition!
  private var animationSpeed: AnimationSpeedCondition!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLeftBackButton()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "Tatami")!)
    title = "\(questionNo ?? 0) / \(questionCount ?? 0)"

    fudaView.material = material
    noAndKimarijiLabel.text = "\(material.noTxt) / \(material.kimarijiTxt)"
    creatorLabel.text = material.creator

    let isAnsweredAllQuestions = questionNo == questionCount
    goToNextButton.isHidden = isAnsweredAllQuestions
    goToResultButton.isHidden = !isAnsweredAllQuestions
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationVC = segue.destination as? MaterialDetailViewController else {
      fatalError("Unexpected destination: \(segue.destination)")
    }

    destinationVC.material = material
  }

  // MARK: - Action
  @IBAction func didTapGoToNext(_ sender: UIButton) {
    presenter.didTapGoToNext()
  }

  @IBAction func didTapGoToResult(_ sender: UIButton) {
    if 0 < requireNavigationController.viewControllers.filter { $0 is TrainingViewController }.count
    {
      presenter.didTapGoToTrainingResult(now: Date())
      return
    }
    if 0 < requireNavigationController.viewControllers.filter { $0 is ExamViewController }.count {
      presenter.didTapGoToExamResult(now: Date())
      return
    }

    fatalError("Unknown Navigation.")
  }

  // MARK: - Method
  func inject(
    presenter: AnswerPresenterProtocol,
    material: Material,
    questionNo: UInt8,
    questionCount: Int,
    kamiNoKu: DisplayStyleCondition,
    shimoNoKu: DisplayStyleCondition,
    animationSpeed: AnimationSpeedCondition
  ) {
    self.presenter = presenter
    self.material = material
    self.questionNo = questionNo
    self.questionCount = questionCount
    self.kamiNoKu = kamiNoKu
    self.shimoNoKu = shimoNoKu
    self.animationSpeed = animationSpeed
  }
}

extension AnswerViewController: AnswerViewProtocol {
  func presentNextQuestionVC() {
    let vc: QuestionViewController = requireStoryboard.instantiateViewController(
      identifier: .question)

    let model = QuestionModel(
      questionNo: questionNo + 1, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu,
      karutaRepository: diContainer.karutaRepository,
      questionRepository: diContainer.questionRepository)

    let presenter = QuestionPresenter(view: vc, model: model)

    vc.inject(questionCount: questionCount, animationSpeed: animationSpeed, presenter: presenter)

    requireNavigationController.replace(vc)
  }

  func presentTrainingResultVC(_ trainingResult: TrainingResult) {
    let vc: TrainingResultViewController = requireStoryboard.instantiateViewController(
      identifier: .trainingResult)

    vc.inject(
      trainingResult: trainingResult,
      kamiNoKu: kamiNoKu,
      shimoNoKu: shimoNoKu,
      animationSpeed: animationSpeed
    )

    requireNavigationController.replace(vc)
  }

  func presentExamResultVC(_ examResult: ExamResult) {
    let vc: ExamResultViewController = requireStoryboard.instantiateViewController(
      identifier: .examResult)

    vc.inject(examResult: examResult)

    requireNavigationController.replace(vc)
  }

  func presentErrorVC(_ error: Error) {
    presentUnexpectedErrorVC(error)
  }
}
