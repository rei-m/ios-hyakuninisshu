//
//  Int8Extension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/28.
//

import Foundation

extension Int8 {
    var noText: String {
        get { "\(KanjiFormatter.string(NSNumber(value: self)))番" }
    }
}
