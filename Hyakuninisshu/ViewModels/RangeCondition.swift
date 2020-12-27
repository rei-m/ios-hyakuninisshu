//
//  RangeFromCondition.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/27.
//

import Foundation

struct RangeCondition: KeyboardPickerItem {
    let text: String
    let no: Int8

    private static let FROM_DATA_SOURCE: [Int8] = [1, 11, 21, 31, 41, 51, 61, 71, 81, 91]
    private static let TO_DATA_SOURCE: [Int8] = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    
    static let FROM_DATA = RangeCondition.FROM_DATA_SOURCE.map {
        RangeCondition(text: $0.noText, no: $0)
    }
    
    static let TO_DATA = RangeCondition.TO_DATA_SOURCE.map {
        RangeCondition(text: $0.noText, no: $0)
    }
}
