//
//  KanjiFormatter.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/26.
//

import Foundation

class KanjiFormatter {
    private static let formatter = createFormater()
    
    static func string(_ value: NSNumber) -> String {
        return KanjiFormatter.formatter.string(from: value)!
    }
    
    private static func createFormater() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = .init(identifier: "ja-JP")
        return formatter
    }
}
