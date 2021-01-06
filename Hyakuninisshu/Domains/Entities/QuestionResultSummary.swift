//
//  QuestionResultSummary.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import Foundation

struct QuestionResultSummary {
    let totalQuestionCount: Int
    let correctCount: Int
    let averageAnswerSec: Double
    
    func score() -> String {
        return "\(correctCount) / \(totalQuestionCount)"
    }
}
