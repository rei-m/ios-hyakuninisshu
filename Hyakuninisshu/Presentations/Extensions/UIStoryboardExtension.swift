//
//  UIStoryboardExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/07.
//

import Foundation
import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(identifier: ViewControllerIdentifier) -> T {
        guard let vc = instantiateViewController(identifier: identifier.rawValue) as? T else {
            fatalError("unknown VC identifier value=\(identifier.rawValue)")
        }
        return vc
    }
}
