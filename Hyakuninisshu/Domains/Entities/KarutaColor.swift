//
//  KarutaColor.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

enum KarutaColor: String {
    case blue = "blue"
    case pink = "pink"
    case yellow = "yellow"
    case green = "green"
    case orange = "orange"
    
    public static let ALL: [KarutaColor] = [
        Self.blue,
        Self.pink,
        Self.yellow,
        Self.green,
        Self.orange,
    ]
    
    public static func valueOf(value: String) -> KarutaColor {
        switch value {
        case Self.blue.rawValue:
            return Self.blue
        case Self.pink.rawValue:
            return Self.pink
        case Self.yellow.rawValue:
            return Self.yellow
        case Self.green.rawValue:
            return Self.green
        case Self.orange.rawValue:
            return Self.orange
        default:
            fatalError("unknown value \(value)")
        }
    }
}
