//
//  Question.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

class Question {
    let id: QuestionId
    let no: Int
    let choices: [KarutaNo]
    let correctNo: KarutaNo
    let correctIdx: Int
    var state: QuestionState // letにしたいけど手抜き
    
    init(id: QuestionId, no: Int, choices: [KarutaNo], correctNo: KarutaNo, state: QuestionState) {
        self.id = id
        self.no = no
        self.choices = choices
        self.correctNo = correctNo
        self.correctIdx = choices.firstIndex(of: correctNo)!
        self.state = state
    }
    
    func start(startDate: Date) -> Question {
        switch state {
        case .answered(_, _):
            fatalError("this question is answered")
        case .ready, .inAnswer(_):
            let copied = self
            copied.state = .inAnswer(startDate: startDate)
            return copied
        }
    }
    
    func verify(selectedNo: KarutaNo, answerDate: Date) -> Question {
        switch state {
        case .ready:
            fatalError("Question is not started. Call start.")
        case .inAnswer(let startDate):
            let answerTime = answerDate.distance(to: startDate)
            let judgement = QuestionJudgement(karutaNo: selectedNo, isCorrect: correctNo == selectedNo)
            let result = QuestionResult(selectedKarutaNo: selectedNo, answerMillSec: answerTime, judgement: judgement)
            let copied = self
            copied.state = .answered(startDate: startDate, result: result)
            return copied
        case .answered(_, _):
            fatalError("Question is already answered.")
        }
    }
}
