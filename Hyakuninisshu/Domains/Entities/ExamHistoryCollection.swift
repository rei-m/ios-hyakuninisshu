//
//  ExamHistoryCollection.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation

struct ExamHistoryCollection {
    static let MAX_HISTORY_COUNT = 10
    
    let values: [ExamHistory]
    let overflowed: [ExamHistory]
    let totalWrongKarutaNoCollection: KarutaNoCollection
    
    init(_ values: [ExamHistory]) {
        self.values = values
        self.overflowed = values.count <= Self.MAX_HISTORY_COUNT ? [] : values.suffix(values.count - Self.MAX_HISTORY_COUNT)
        var totalWrongKarutaNoSet: Set<KarutaNo> = Set()
        values.forEach { examHistory in
            examHistory.questionJudgements.forEach { judgement in
                if (!judgement.isCorrect) {
                    totalWrongKarutaNoSet.insert(judgement.karutaNo)
                }
            }
        }
        self.totalWrongKarutaNoCollection = KarutaNoCollection(values: totalWrongKarutaNoSet.compactMap { $0 })
    }
}
