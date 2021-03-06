//
//  TrainingViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import GoogleMobileAds
import UIKit

protocol TrainingViewProtocol: AnyObject {
  func disableInteraction()
  func enableInteraction()
  func initSettings(
    rangeFrom: RangeCondition,
    rangeTo: RangeCondition,
    kimariji: KimarijiCondition,
    color: ColorCondition,
    kamiNoKu: DisplayStyleCondition,
    shimoNoKu: DisplayStyleCondition,
    animationSpeed: AnimationSpeedCondition
  )
  func updateRangeFrom(_ condition: RangeCondition)
  func updateRangeTo(_ condition: RangeCondition)
  func updateKimariji(_ condition: KimarijiCondition)
  func updateColor(_ condition: ColorCondition)
  func updateKamiNoKu(_ condition: DisplayStyleCondition)
  func updateShimoNoKu(_ condition: DisplayStyleCondition)
  func updateAnimationSpeed(_ condition: AnimationSpeedCondition)
  func updateRangeError(_ message: String?)
  func showAlertDialog()
  func toggleMask(_ isVisble: Bool)
  func presentNextVC(
    karutaNos: [UInt8],
    kamiNoKu: DisplayStyleCondition,
    shimoNoKu: DisplayStyleCondition,
    animationSpeed: AnimationSpeedCondition
  )
  func presentErrorVC(_ error: Error)
}

class TrainingViewController: UIViewController {
  // MARK: - Outlet
  @IBOutlet weak var rangeFromPicker: KeyboardPicker!
  @IBOutlet weak var rangeToPicker: KeyboardPicker!
  @IBOutlet weak var kimarijiPicker: KeyboardPicker!
  @IBOutlet weak var colorPicker: KeyboardPicker!
  @IBOutlet weak var kamiNoKuPicker: KeyboardPicker!
  @IBOutlet weak var shimoNoKuPicker: KeyboardPicker!
  @IBOutlet weak var animationSpeedPicker: KeyboardPicker!
  @IBOutlet weak var rangeErrorLabel: UILabel!
  @IBOutlet weak var startTrainingButton: ActionButton!
  @IBOutlet weak var maskView: UIView!
  @IBOutlet weak var bannerView: GADBannerView!

  // MARK: - Property
  private var rangeErrorHeightConstraint: NSLayoutConstraint?
  private var presenter: TrainingPresenterProtocol!
  private var adController: AdController!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.viewDidLoad()
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
  @IBAction func didStartTrainingButtonTapDone(_ sender: UIButton) {
    presenter.didStartTrainingButtonTapDone()
  }

  @IBAction func didTapMask(_ sender: Any) {
    presenter.didTapMask()
  }

  // MARK: - Method
  func inject(presenter: TrainingPresenterProtocol, adController: AdController) {
    self.presenter = presenter
    self.adController = adController
  }
}

extension TrainingViewController: TrainingViewProtocol {
  func disableInteraction() {
    startTrainingButton.isUserInteractionEnabled = false
  }

  func enableInteraction() {
    startTrainingButton.isUserInteractionEnabled = true
  }

  func initSettings(
    rangeFrom: RangeCondition,
    rangeTo: RangeCondition,
    kimariji: KimarijiCondition,
    color: ColorCondition,
    kamiNoKu: DisplayStyleCondition,
    shimoNoKu: DisplayStyleCondition,
    animationSpeed: AnimationSpeedCondition
  ) {
    rangeFromPicker.setUpData(data: RangeCondition.FROM_DATA, currentItem: rangeFrom)
    rangeToPicker.setUpData(data: RangeCondition.TO_DATA, currentItem: rangeTo)
    kimarijiPicker.setUpData(data: KimarijiCondition.DATA, currentItem: kimariji)
    colorPicker.setUpData(data: ColorCondition.DATA, currentItem: color)
    kamiNoKuPicker.setUpData(data: DisplayStyleCondition.DATA, currentItem: kamiNoKu)
    shimoNoKuPicker.setUpData(data: DisplayStyleCondition.DATA, currentItem: shimoNoKu)
    animationSpeedPicker.setUpData(data: AnimationSpeedCondition.DATA, currentItem: animationSpeed)

    rangeErrorHeightConstraint = rangeErrorLabel.constraints.first

    [
      rangeFromPicker, rangeToPicker, kimarijiPicker, colorPicker, kamiNoKuPicker, shimoNoKuPicker,
      animationSpeedPicker,
    ].forEach {
      $0?.delegate = self
    }
  }

  func updateRangeFrom(_ condition: RangeCondition) {
    rangeFromPicker.currentItem = condition
  }

  func updateRangeTo(_ condition: RangeCondition) {
    rangeToPicker.currentItem = condition
  }

  func updateKimariji(_ condition: KimarijiCondition) {
    kimarijiPicker.currentItem = condition
  }

  func updateColor(_ condition: ColorCondition) {
    colorPicker.currentItem = condition
  }

  func updateKamiNoKu(_ condition: DisplayStyleCondition) {
    kamiNoKuPicker.currentItem = condition
  }

  func updateShimoNoKu(_ condition: DisplayStyleCondition) {
    shimoNoKuPicker.currentItem = condition
  }

  func updateAnimationSpeed(_ condition: AnimationSpeedCondition) {
    animationSpeedPicker.currentItem = condition
  }

  func updateRangeError(_ message: String?) {
    rangeErrorLabel.text = message
    rangeErrorHeightConstraint?.isActive = message == nil
  }

  func showAlertDialog() {
    let alert = UIAlertController(
      title: "エラー",
      message: "エラーがあります。画面をご確認ください。",
      preferredStyle: .alert
    )

    let defaultAction = UIAlertAction(title: "閉じる", style: .default)
    alert.addAction(defaultAction)

    self.present(alert, animated: true)
  }

  func toggleMask(_ isVisble: Bool) {
    maskView.isHidden = !isVisble
    if !isVisble {
      [
        rangeFromPicker, rangeToPicker, kimarijiPicker, colorPicker, kamiNoKuPicker,
        shimoNoKuPicker, animationSpeedPicker,
      ].forEach {
        if ($0?.isFirstResponder) != nil {
          $0?.close()
        }
      }
    }
  }

  func presentNextVC(
    karutaNos: [UInt8],
    kamiNoKu: DisplayStyleCondition,
    shimoNoKu: DisplayStyleCondition,
    animationSpeed: AnimationSpeedCondition
  ) {
    let vc: QuestionStarterViewController = requireStoryboard.instantiateViewController(
      identifier: .questionStarter)

    let model = QuestionStarterModel(
      karutaNos: karutaNos, karutaRepository: diContainer.karutaRepository,
      questionRepository: diContainer.questionRepository)

    let presenter = QuestionStarterPresenter(view: vc, model: model)

    vc.inject(
      presenter: presenter, kamiNoKu: kamiNoKu, shimoNoKu: shimoNoKu, animationSpeed: animationSpeed
    )

    requireNavigationController.pushViewController(vc, animated: false)
  }

  func presentErrorVC(_ error: Error) {
    presentUnexpectedErrorVC(error)
  }
}

extension TrainingViewController: KeyboardPickerDelegate {
  func didTap() {
    maskView.isHidden = false
  }

  func didTapDone(_ keyboardPicker: KeyboardPicker, item: KeyboardPickerItem) {
    // ここイケてない・・・
    switch keyboardPicker {
    case rangeFromPicker:
      presenter.didChangeRangeFrom(item as! RangeCondition)
    case rangeToPicker:
      presenter.didChangeRangeTo(item as! RangeCondition)
    case kimarijiPicker:
      presenter.didChangeKimariji(item as! KimarijiCondition)
    case colorPicker:
      presenter.didChangeColor(item as! ColorCondition)
    case kamiNoKuPicker:
      presenter.didChangeKamiNoKu(item as! DisplayStyleCondition)
    case shimoNoKuPicker:
      presenter.didChangeShimoNoKu(item as! DisplayStyleCondition)
    case animationSpeedPicker:
      presenter.didChangeAnimationSpeed(item as! AnimationSpeedCondition)
    default:
      return
    }
  }
}
