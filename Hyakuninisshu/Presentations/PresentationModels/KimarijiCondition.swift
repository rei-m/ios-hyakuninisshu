//
//  KimarijiCondition.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/28.
//

import Foundation

struct KimarijiCondition: KeyboardPickerItem, Equatable {
    let text: String
    let value: Int8?

    private static let DATA_SOURCE: [Int8?] = [nil, 1, 2, 3, 4, 5, 6]
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
    
    static let DATA: [Self] = Self.DATA_SOURCE.map {
        guard let v = $0 else {
            return Self(text: "指定しない", value: nil)
        }
        return Self(text: KanjiFormatter.kimariji(NSNumber(value: v)), value: v)
    }
}
