//
//  UINavigationControllerExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import UIKit

extension UINavigationController {

  /// 表示中のViewControllerを階層を増やさずに置き換える
  /// - Parameter vc: 表示対象のViewController
  func replace(_ vc: UIViewController) {
    var currentVCs = viewControllers
    currentVCs.removeLast()
    currentVCs.append(vc)
    setViewControllers(currentVCs, animated: false)
  }
}
