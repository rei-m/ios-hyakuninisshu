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
          guard let materialTableViewController = nvc as? MaterialTableViewController else {
            break
          }
          let model = MaterialTableModel(karutaRepository: diContainer.karutaRepository)
          let presenter = MaterialTablePresenter(view: materialTableViewController, model: model)
          materialTableViewController.inject(presenter: presenter)
        }
        for nvc in vc.children {
          guard let trainingViewController = nvc as? TrainingViewController else {
            break
          }
          let model = TrainingModel(karutaRepository: diContainer.karutaRepository)
          let presenter = TrainingPresenter(view: trainingViewController, model: model)
          trainingViewController.inject(presenter: presenter)
        }
        for nvc in vc.children {
          guard let examViewController = nvc as? ExamViewController else {
            break
          }
          let model = ExamModel(
            karutaRepository: diContainer.karutaRepository,
            examHistoryRepository: diContainer.examHistoryRepository)
          let presenter = ExamPresenter(view: examViewController, model: model)
          examViewController.inject(presenter: presenter)
        }
      }
    }
  }
}
