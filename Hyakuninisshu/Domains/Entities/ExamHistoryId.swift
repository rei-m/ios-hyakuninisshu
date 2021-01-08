//
//  ExamId.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation

struct ExamHistoryId {
    let value: String
    
    init() {
        value = NSUUID().uuidString
    }
}
