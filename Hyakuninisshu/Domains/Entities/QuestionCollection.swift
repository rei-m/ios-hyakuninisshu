//
//  QuestionCollection.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/06.
//

import Foundation

struct QuestionCollection {
    let values: [Question]
    
    init(values: [Question]) {
        self.values = values
    }
    
    func canRestart() -> Bool {
        let wrongCount = wrongKarutaNoCollection().count
        return 0 < wrongCount
    }
    
    func wrongKarutaNoCollection() -> KarutaNoCollection {
        return KarutaNoCollection(values: values.compactMap { question -> KarutaNo? in
            guard case .answered(_, let result) = question.state else {
                return nil
            }
            return result.judgement.karutaNo
        })
    }
    
    func resultSummary() -> QuestionResultSummary {
        let questionCount = values.count
        if (questionCount == 0) {
            return QuestionResultSummary(totalQuestionCount: 0, correctCount: 0, averageAnswerSec: 0)
        }
        var totalAnswerTimeMillSec: TimeInterval = 0
        var collectCount = 0
        
        values.forEach { question in
            guard case .answered(_, let result) = question.state else {
                // TODO
                fatalError()
            }
            totalAnswerTimeMillSec += result.answerMillSec
            if (result.judgement.isCorrect) {
                collectCount += 1
            }
        }

        let averageAnswerSec = totalAnswerTimeMillSec / Double(questionCount)

        return QuestionResultSummary(totalQuestionCount: questionCount, correctCount: collectCount, averageAnswerSec: averageAnswerSec)
    }
}
