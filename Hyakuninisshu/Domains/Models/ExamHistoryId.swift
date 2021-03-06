//
//  ExamId.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import Foundation

/// 力試し履歴ID
struct ExamHistoryId: EntityId {
  let value: UUID

  private init(_ value: UUID) {
    self.value = value
  }

  static func create() -> ExamHistoryId {
    return ExamHistoryId(UUID())
  }

  static func restore(_ value: UUID) -> ExamHistoryId {
    return ExamHistoryId(value)
  }
}
