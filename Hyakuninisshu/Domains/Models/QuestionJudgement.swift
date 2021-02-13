//
//  QuestionJudgement.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

/// 問題の回答結果
struct QuestionJudgement: ValueObject {
  let karutaNo: KarutaNo
  let isCorrect: Bool
}
