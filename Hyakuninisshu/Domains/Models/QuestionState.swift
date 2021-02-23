//
//  QuestionState.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

/// 問題の状態
enum QuestionState {
  case ready  // 回答前
  case inAnswer(startDate: Date)  // 回答中
  case answered(startDate: Date, result: QuestionResult)  // 回答済
}
