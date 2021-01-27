//
//  UIColorExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/29.
//

import UIKit

extension UIColor {
    enum ColorNames: String {
        case accent = "AccentColor"
        case background = "BackgroundColor"
        case fudaBackground = "FudaBackgroundColor"
        case fudaBackgroundTouched = "FudaBackgroundTouchedColor"
        case fudaFrame = "FudaFrameColor"
        case fudaText = "FudaTextColor"
        case primary = "PrimaryColor"
        case primaryContrastText = "PrimaryContrastTextColor"
        case primaryTouched = "PrimaryTouchedColor"
        case secondary = "SecondaryColor"
        case secondaryContrastText = "SecondaryContrastTextColor"
        case secondaryTouched = "SecondaryTouchedColor"
        case text = "TextColor"
    }

    convenience init(named: ColorNames) {
        self.init(named: named.rawValue)!
    }
}

