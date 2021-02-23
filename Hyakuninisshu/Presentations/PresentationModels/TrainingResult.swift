//
//  TrainingResult.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import Foundation

/// 練習結果
struct TrainingResult {
  let score: PlayScore
  let canRestart: Bool
  let wrongKarutaNos: [UInt8]
}
