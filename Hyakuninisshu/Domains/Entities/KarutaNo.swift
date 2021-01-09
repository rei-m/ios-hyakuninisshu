//
//  KarutaNo.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

struct KarutaNo: Equatable, Hashable {
    static let MIN = KarutaNo(1)
    static let MAX = KarutaNo(100)
    static let LIST: [KarutaNo] = (MIN.value...MAX.value).map { KarutaNo($0) }

    let value: Int8
    
    init(_ value: Int8) {
        self.value = value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}
