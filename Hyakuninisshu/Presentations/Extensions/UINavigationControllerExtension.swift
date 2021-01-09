//
//  UINavigationControllerExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import UIKit

extension UINavigationController {
    func replace(_ vc: UIViewController) {
        var currentVCs = viewControllers
        currentVCs.removeLast()
        currentVCs.append(vc)
        setViewControllers(currentVCs, animated: false)
    }
}
