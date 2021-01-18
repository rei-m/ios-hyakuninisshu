//
//  UIViewExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation
import UIKit

private func createFitLayoutConstraint(item: UIView, toItem: UIView, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
    return NSLayoutConstraint(
        item: item,
        attribute: attribute,
        relatedBy: .equal,
        toItem: toItem,
        attribute: attribute,
        multiplier: 1.0,
        constant: 0
    )
}

extension UIView {
    private func addFitConstraints(to: UIView) {
        to.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(createFitLayoutConstraint(item: to, toItem: self, attribute: .top))
        self.addConstraint(createFitLayoutConstraint(item: to, toItem: self, attribute: .leading))
        self.addConstraint(createFitLayoutConstraint(item: to, toItem: self, attribute: .bottom))
        self.addConstraint(createFitLayoutConstraint(item: to, toItem: self, attribute: .trailing))
    }
    
    func setUpCardFrame(borderWidth: CGFloat, cornerRadius: CGFloat, shadowOffset: CGFloat) {
        let borderColor = UIColor(named: "AccentColor")
        let shadowView = UIView()
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = cornerRadius
        shadowView.layer.cornerRadius = cornerRadius
        shadowView.layer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        shadowView.layer.masksToBounds = false
        
        let roundView = UIView()
        roundView.layer.borderColor = borderColor?.cgColor
        roundView.layer.borderWidth = borderWidth
        roundView.layer.cornerRadius = cornerRadius
        roundView.layer.masksToBounds = true

        addSubview(shadowView)
        addSubview(roundView)
        addFitConstraints(to: roundView)
        addFitConstraints(to: shadowView)
        sendSubviewToBack(roundView)
        sendSubviewToBack(shadowView)
    }
}
