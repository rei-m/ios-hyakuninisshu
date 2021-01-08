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
    let result: ExamResult
    
    init(id: ExamHistoryId, tookDate: Date, result: ExamResult) {
        self.id = id
        self.tookDate = tookDate
        self.result = result
    }
}
