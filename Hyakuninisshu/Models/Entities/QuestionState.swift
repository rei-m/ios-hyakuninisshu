//
//  QuestionState.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

enum QuestionState {
    case ready
    case inAnswer(startDate: Date)
    case answered(startDate: Date)
}
