//
//  ShimoNoKu.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

/// 歌の下の句
struct ShimoNoKu: ValueObject {
  let karutaNo: KarutaNo
  let shiku: Verse
  let goku: Verse

  func hash(into hasher: inout Hasher) {
    hasher.combine(karutaNo)
  }
}
