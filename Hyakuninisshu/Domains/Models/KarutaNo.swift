//
//  KarutaNo.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

struct KarutaNo: ValueObject {
  static let MIN = KarutaNo(1)
  static let MAX = KarutaNo(100)
  static let LIST: [KarutaNo] = (MIN.value...MAX.value).map { KarutaNo($0) }

  let value: UInt8

  init(_ value: UInt8) {
    self.value = value
  }
}
