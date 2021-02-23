//
//  ExamViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import GoogleMobileAds
import UIKit

protocol ExamViewProtocol: AnyObject {
  func disableInteraction()
  func enableInteraction()
  func displayLastResult(_ examScore: PlayScore)
  func hideLastResult()
  func presentNextVC(karutaNos: [UInt8])
  func presentErrorVC(_ error: Error)
}

class ExamViewController: UIViewController {
  // MARK: - Outlet
  @IBOutlet weak var lastExamResultView: UIView!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var averageAnswerSecLabel: UILabel!
  @IBOutlet weak var startExamButton: ActionButton!
  @IBOutlet weak var startTrainingButton: UIButton!
  @IBOutlet weak var bannerView: GADBannerView!

  // MARK: - Property
  private var presenter: ExamPresenterProtocol!
  private var adController: AdController!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    lastExamResultView.layer.cornerRadius = 8
    adController.viewDidLoad(bannerView)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = false
    presenter.viewWillAppear()
    adController.viewWillAppear()
  }

  override func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.viewWillTransition(to: size, with: coordinator)
    adController.viewWillTransition(to: size, with: coordinator)
  }

  // MARK: - Action
  @IBAction func didTapStartExamButton(_ sender: Any) {
    presenter.didTapStartExamButton()
  }

  @IBAction func didTapStartTrainingButton(_ sender: Any) {
    presenter.didTapStartTrainingButton()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    switch segue.identifier ?? "" {
    case "ShowExamHistory":
      guard
        let examHistoryViewController = segue.destination as? ExamHistoryViewController
      else {
        fatalError("Unexpected destination: \(segue.destination)")
      }
      let model = ExamHistoryModel(examHistoryRepository: diContainer.examHistoryRepository)
      let presenter = ExamHistoryPresenter(view: examHistoryViewController, model: model)
      let adController = AdController(vc: examHistoryViewController)
      examHistoryViewController.inject(presenter: presenter, adController: adController)
    default:
      fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
    }
  }

  // MARK: - Method
  func inject(presenter: ExamPresenterProtocol, adController: AdController) {
    self.presenter = presenter
    self.adController = adController
  }
}

extension ExamViewController: ExamViewProtocol {
  func disableInteraction() {
    startExamButton.isUserInteractionEnabled = false
    startTrainingButton.isUserInteractionEnabled = false
  }

  func enableInteraction() {
    startExamButton.isUserInteractionEnabled = true
    startTrainingButton.isUserInteractionEnabled = true
  }

  func displayLastResult(_ examScore: PlayScore) {
    scoreLabel.text = examScore.score.text
    averageAnswerSecLabel.text = examScore.averageAnswerSecText
    lastExamResultView.isHidden = false
    startTrainingButton.isHidden = false
  }

  func hideLastResult() {
    lastExamResultView.isHidden = true
    startTrainingButton.isHidden = true
  }

  func presentNextVC(karutaNos: [UInt8]) {
    let vc: QuestionStarterViewController = requireStoryboard.instantiateViewController(
      identifier: .questionStarter)

    let model = QuestionStarterModel(
      karutaNos: karutaNos, karutaRepository: diContainer.karutaRepository,
      questionRepository: diContainer.questionRepository)

    let presenter = QuestionStarterPresenter(view: vc, model: model)

    vc.inject(
      presenter: presenter, kamiNoKu: DisplayStyleCondition.DATA[0],
      shimoNoKu: DisplayStyleCondition.DATA[1], animationSpeed: AnimationSpeedCondition.DATA[1])

    requireNavigationController.pushViewController(vc, animated: false)
  }

  func presentErrorVC(_ error: Error) {
    presentUnexpectedErrorVC(error)
  }
}
