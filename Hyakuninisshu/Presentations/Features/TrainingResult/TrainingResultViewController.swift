//
//  TrainingResultViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import GoogleMobileAds
import UIKit

class TrainingResultViewController: UIViewController {
  // MARK: - Outlet
  @IBOutlet weak var scoreView: QuestionResultView!
  @IBOutlet weak var averageAnswerTimeView: QuestionResultView!

  @IBOutlet weak var goToTrainingButton: UIButton!
  @IBOutlet weak var bannerView: GADBannerView!

  // MARK: - Property
  private var trainingResult: TrainingResult!
  private var kamiNoKu: DisplayStyleCondition!
  private var shimoNoKu: DisplayStyleCondition!
  private var animationSpeed: AnimationSpeedCondition!

  private var adController: AdController!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLeftBackButton()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "Tatami")!)

    scoreView.value = trainingResult.score.score.text
    averageAnswerTimeView.value = trainingResult.score.averageAnswerSecText
    goToTrainingButton.isHidden = !trainingResult.canRestart

    adController.viewDidLoad(bannerView)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
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
  @IBAction func didTapGoToTraining(_ sender: Any) {
    let vc: QuestionStarterViewController = requireStoryboard.instantiateViewController(
      identifier: .questionStarter)

    let model = QuestionStarterModel(
      karutaNos: trainingResult.wrongKarutaNos, karutaRepository: diContainer.karutaRepository,
      questionRepository: diContainer.questionRepository)

    let presenter = QuestionStarterPresenter(view: vc, model: model)

    vc.inject(
      presenter: presenter, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, animationSpeed: animationSpeed
    )

    requireNavigationController.pushViewController(vc, animated: false)
  }

  @IBAction func didTapGoToMenu(_ sender: Any) {
    popToNaviRoot()
  }

  // MARK: - Method
  func inject(
    trainingResult: TrainingResult,
    kamiNoKu: DisplayStyleCondition,
    shimoNoKu: DisplayStyleCondition,
    animationSpeed: AnimationSpeedCondition, adController: AdController
  ) {
    self.trainingResult = trainingResult
    self.kamiNoKu = kamiNoKu
    self.shimoNoKu = shimoNoKu
    self.animationSpeed = animationSpeed
    self.adController = adController
  }
}
