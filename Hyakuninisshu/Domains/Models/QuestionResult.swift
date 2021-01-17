//
//  QuestionResult.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

struct QuestionResult: ValueObject {
    let selectedKarutaNo: KarutaNo
    let answerSec: TimeInterval
    let judgement: QuestionJudgement
}
