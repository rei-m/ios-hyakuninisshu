//
//  Kimariji.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

enum Kimariji: UInt8 {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    
    static let ALL: [Kimariji] = [
        Self.one,
        Self.two,
        Self.three,
        Self.four,
        Self.five,
        Self.six,
    ]
    
    static func valueOf(value: UInt8) -> Kimariji {
        precondition(Kimariji.one.rawValue <= value && value <= Kimariji.six.rawValue)
        return Self.ALL[Int(value) - 1]
    }
}
