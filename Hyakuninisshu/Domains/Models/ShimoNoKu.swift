//
//  ShimoNoKu.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

struct ShimoNoKu: ValueObject {
  let karutaNo: KarutaNo
  let shiku: Verse
  let goku: Verse

  func hash(into hasher: inout Hasher) {
    hasher.combine(karutaNo)
  }
}
