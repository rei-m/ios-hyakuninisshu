//
//  Play.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/31.
//

import Foundation

/// 問題実行用
struct Play {
  let no: UInt8
  let yomiFuda: YomiFuda
  let toriFudas: [ToriFuda]
  let correct: Material
}
