//
//  KarutaNo.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

private func createKanjiFormater() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    formatter.locale = .init(identifier: "ja-JP")
    return formatter
}

struct KarutaNo {
    static let MIN = KarutaNo(1)
    static let MAX = KarutaNo(100)
    static let LIST: [KarutaNo] = (MIN.value...MAX.value).map { KarutaNo($0) }

    private static let formatter = createKanjiFormater()

    let value: Int8
    let text: String
    
    init(_ value: Int8) {
        self.value = value
        self.text = "\(KarutaNo.formatter.string(from: NSNumber(value: value))!)番"
    }
}
