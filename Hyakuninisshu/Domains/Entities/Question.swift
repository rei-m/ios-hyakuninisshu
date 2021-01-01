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
    let state: QuestionState
    
    init(id: QuestionId, no: Int, choices: [KarutaNo], correctNo: KarutaNo, state: QuestionState) {
        self.id = id
        self.no = no
        self.choices = choices
        self.correctNo = correctNo
        self.correctIdx = choices.firstIndex(of: correctNo)!
        self.state = state
    }
}
