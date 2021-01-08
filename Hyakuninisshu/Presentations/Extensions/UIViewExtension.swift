//
//  UIViewExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import UIKit

private func createFitLayoutConstraint(item: UIView, toItem: UIView, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: item,
                              attribute: attribute,
                              relatedBy: .equal,
                              toItem: toItem,
                              attribute: attribute,
                              multiplier: 1.0,
                              constant: 0)
}

extension UIView {
    func addFitConstraints(to: UIView) {
        to.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(createFitLayoutConstraint(item: to, toItem: self, attribute: .top))
        self.addConstraint(createFitLayoutConstraint(item: to, toItem: self, attribute: .leading))
        self.addConstraint(createFitLayoutConstraint(item: to, toItem: self, attribute: .bottom))
        self.addConstraint(createFitLayoutConstraint(item: to, toItem: self, attribute: .trailing))
    }
}
