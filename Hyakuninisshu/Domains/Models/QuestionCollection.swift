//
//  QuestionCollection.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import Foundation

struct QuestionCollection {
    let values: [Question]
    
    init(_ values: [Question]) {
        self.values = values
    }
    
    func aggregateResult() -> (QuestionResultSummary, KarutaNoCollection) {
        let questionCount = UInt8(values.count)
        if (questionCount == 0) {
            return (QuestionResultSummary(totalQuestionCount: 0, correctCount: 0, averageAnswerSec: 0), KarutaNoCollection([]))
        }

        var totalAnswerTimeSec: TimeInterval = 0
        var collectCount: UInt8 = 0
        var wrongKarutaNos: [KarutaNo] = []
        
        values.forEach { question in
            guard case .answered(_, let result) = question.state else {
                fatalError("includes unanswered question.")
            }

            totalAnswerTimeSec += result.answerSec

            if (result.judgement.isCorrect) {
                collectCount += 1
            } else {
                wrongKarutaNos.append(result.selectedKarutaNo)
            }
        }

        let averageAnswerSec = totalAnswerTimeSec / Double(questionCount)
        let roundedAverageAnswerSec = round(averageAnswerSec * 100) / 100

        return (QuestionResultSummary(totalQuestionCount: questionCount, correctCount: collectCount, averageAnswerSec: roundedAverageAnswerSec), KarutaNoCollection(wrongKarutaNos))
    }
}
