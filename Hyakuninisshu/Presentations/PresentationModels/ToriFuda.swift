//
//  ToriFuda.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/31.
//

import Foundation

struct ToriFuda {
    static func fromShimoNoKu(shimoNoKu: ShimoNoKu, style: DisplayStyleCondition) -> ToriFuda {
        switch style.value {
        case 0:
            return ToriFuda(karutaNo: shimoNoKu.karutaNo.value, firstLine: shimoNoKu.shiku.kanji, secondLine: shimoNoKu.goku.kanji)
        case 1:
            return ToriFuda(karutaNo: shimoNoKu.karutaNo.value, firstLine: shimoNoKu.shiku.kana, secondLine: shimoNoKu.goku.kana)
        default:
            fatalError("unknown value")
        }
    }
    
    let karutaNo: UInt8
    let firstLine: String
    let secondLine: String
}
