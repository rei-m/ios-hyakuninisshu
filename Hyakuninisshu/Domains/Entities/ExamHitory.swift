//
//  ExamHitory.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation

class ExamHistory {
    let id: ExamHistoryId
    let tookDate: Date
    let resultSummary: QuestionResultSummary
    let questionJudgements: [QuestionJudgement]
    
    init(id: ExamHistoryId, tookDate: Date, resultSummary: QuestionResultSummary, questionJudgements: [QuestionJudgement]) {
        self.id = id
        self.tookDate = tookDate
        self.resultSummary = resultSummary
        self.questionJudgements = questionJudgements
    }
}
