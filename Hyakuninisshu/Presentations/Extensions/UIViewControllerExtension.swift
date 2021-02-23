//
//  UIViewControllerExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation
import UIKit

extension UIViewController {
  var requireAppDelegate: AppDelegate {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Missing AppDelegate.")
    }
    return appDelegate
  }

  var requireStoryboard: UIStoryboard {
    guard let storyboard = storyboard else {
      fatalError("Missing storyboard.")
    }
    return storyboard
  }

  var requireNavigationController: UINavigationController {
    guard let navigationController = navigationController else {
      fatalError("Missing navigationController.")
    }
    return navigationController
  }

  var diContainer: DIContainer {
    requireAppDelegate.diContainer
  }

  /// unhandledなエラー表示用のViewControllerを表示する
  /// - Parameter error: エラー
  func presentUnexpectedErrorVC(_ error: Error) {
    let storyboard = UIStoryboard(name: "Error", bundle: nil)
    let vc: UnexpectedErrorViewController = storyboard.instantiateViewController(
      identifier: .fatalError)
    vc.modalPresentationStyle = .fullScreen
    vc.error = error
    present(vc, animated: false)
  }

  /// ナビゲーション左にカスタムの戻るボタンを設置する
  func setUpLeftBackButton() {
    let leftButton = UIBarButtonItem(
      title: "戻る", style: UIBarButtonItem.Style.plain, target: self,
      action: #selector(popToNaviRoot))
    navigationItem.leftBarButtonItem = leftButton
  }

  /// Navigationの先頭まで戻る
  @objc func popToNaviRoot() {
    requireNavigationController.popToRootViewController(animated: true)
  }
}
