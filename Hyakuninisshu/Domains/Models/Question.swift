//
//  Question.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

class Question: Entity {
    typealias Id = QuestionId
    
    let id: Id
    let no: UInt8
    let choices: [KarutaNo]
    let correctNo: KarutaNo
    let state: QuestionState
    
    init(id: Id, no: UInt8, choices: [KarutaNo], correctNo: KarutaNo, state: QuestionState) {
        self.id = id
        self.no = no
        self.choices = choices
        self.correctNo = correctNo
        self.state = state
    }
    
    func start(startDate: Date) -> Question {
        switch state {
        case .answered(_, _):
            fatalError("Question is already answered. no=\(no)")
        case .ready, .inAnswer(_):
            return Question(id: id, no: no, choices: choices, correctNo: correctNo, state: .inAnswer(startDate: startDate))
        }
    }
    
    func verify(selectedNo: KarutaNo, answerDate: Date) -> Question {
        switch state {
        case .ready:
            fatalError("Question is not started. Call start. no=\(no)")
        case .inAnswer(let startDate):
            let answerSec = startDate.distance(to: answerDate)
            let judgement = QuestionJudgement(karutaNo: correctNo, isCorrect: correctNo == selectedNo)
            let result = QuestionResult(selectedKarutaNo: selectedNo, answerSec: answerSec, judgement: judgement)
            return Question(id: id, no: no, choices: choices, correctNo: correctNo, state: .answered(startDate: startDate, result: result))
        case .answered(_, _):
            fatalError("Question is already answered. no=\(no)")
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.id == rhs.id
    }
}
