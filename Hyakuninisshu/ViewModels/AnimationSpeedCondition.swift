//
//  DisplayStyleCondition.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/28.
//

import Foundation

struct AnimationSpeedCondition: KeyboardPickerItem, Equatable {
    let text: String
    let value: Int

    private static let DATA_SOURCE: [Int] = [0, 1, 2, 3]
    
    private static let TEXT_SOURCE: [String] = [
        "なし",
        "おそめ",
        "ふつう",
        "はやめ"
    ]
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
    
    static let DATA: [Self] = Self.DATA_SOURCE.enumerated().map {
        return Self(text: TEXT_SOURCE[$0.offset], value: $0.element)
    }
}
