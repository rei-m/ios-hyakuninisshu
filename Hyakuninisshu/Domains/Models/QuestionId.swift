//
//  QuestionId.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

struct QuestionId: EntityId {
    let value: UUID
    
    private init(_ value: UUID) {
        self.value = value
    }
    
    static func create() -> QuestionId {
        return QuestionId(UUID())
    }

    static func restore(_ value: UUID) -> QuestionId {
        return QuestionId(value)
    }
}
