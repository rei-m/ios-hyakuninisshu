//
//  Karuta.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

struct Karuta: ValueObject {
  let no: KarutaNo
  let kamiNoKu: KamiNoKu
  let shimoNoKu: ShimoNoKu
  let creator: String
  let translation: String
  let kimariji: Kimariji
  let color: KarutaColor

  func hash(into hasher: inout Hasher) {
    hasher.combine(no)
  }
}
