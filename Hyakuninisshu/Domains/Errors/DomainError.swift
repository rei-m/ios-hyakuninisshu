//
//  RepositoryError.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

/// ドメインレイヤエラー
struct DomainError: Error {
  enum ErrorKind {
    case model
    case repository
    case unhandled
  }

  let reason: String
  let kind: ErrorKind
}
