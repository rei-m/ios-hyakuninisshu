//
//  EntranceTabBarController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/11.
//

import Combine
import UIKit

class EntranceTabBarController: UITabBarController {
  private var cancellables = [AnyCancellable]()

  override func viewDidLoad() {
    super.viewDidLoad()

    // TODO: DIはもっとうまいやり方があると思うんだけど・・・取りあえず動くの優先
    viewControllers?.forEach { vc in
      if vc is UINavigationController {
        for nvc in vc.children {
          guard let materialViewController = nvc as? MaterialViewController else {
            break
          }
          let model = MaterialModel(karutaRepository: diContainer.karutaRepository)
          let presenter = MaterialPresenter(view: materialViewController, model: model)
          let adController = AdController(vc: materialViewController)
          materialViewController.inject(presenter: presenter, adController: adController)
        }
        for nvc in vc.children {
          guard let trainingViewController = nvc as? TrainingViewController else {
            break
          }
          let model = TrainingModel(karutaRepository: diContainer.karutaRepository)
          let presenter = TrainingPresenter(view: trainingViewController, model: model)
          let adController = AdController(vc: trainingViewController)
          trainingViewController.inject(presenter: presenter, adController: adController)
        }
        for nvc in vc.children {
          guard let examViewController = nvc as? ExamViewController else {
            break
          }
          let model = ExamModel(
            karutaRepository: diContainer.karutaRepository,
            examHistoryRepository: diContainer.examHistoryRepository)
          let presenter = ExamPresenter(view: examViewController, model: model)
          let adController = AdController(vc: examViewController)
          examViewController.inject(presenter: presenter, adController: adController)
        }
      }
    }
  }
}
