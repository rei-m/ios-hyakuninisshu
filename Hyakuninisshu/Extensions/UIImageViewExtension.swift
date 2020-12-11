//
//  UIImageViewExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/11.
//

import Foundation
import UIKit

extension UIImageView {
    func setKarutaImage(no: KarutaNo) {
        self.image = UIImage(named: "Karuta\(no.value)")
    }
}
