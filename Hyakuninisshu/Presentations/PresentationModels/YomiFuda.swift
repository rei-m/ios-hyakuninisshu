//
//  YomiFuda.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/31.
//

import Foundation

/// 読み札
struct YomiFuda {
  static func fromKamiNoKu(kamiNoKu: KamiNoKu, style: DisplayStyleCondition) -> YomiFuda {
    switch style.value {
    case 0:
      return YomiFuda(
        karutaNo: kamiNoKu.karutaNo.value, firstLine: kamiNoKu.shoku.kanji,
        secondLine: kamiNoKu.niku.kanji, thirdLine: kamiNoKu.sanku.kanji)
    case 1:
      return YomiFuda(
        karutaNo: kamiNoKu.karutaNo.value, firstLine: kamiNoKu.shoku.kana,
        secondLine: kamiNoKu.niku.kana, thirdLine: kamiNoKu.sanku.kana)
    default:
      fatalError("unknown value")
    }
  }

  let karutaNo: UInt8
  let firstLine: String
  let secondLine: String
  let thirdLine: String
}
