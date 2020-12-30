//
//  QuestionId.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

struct QuestionId {
    let value: String
    
    init() {
        value = NSUUID().uuidString
    }
}
