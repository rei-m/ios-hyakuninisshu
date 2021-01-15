//
//  RepositoryError.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

enum DomainError: Error {
    case repository(_ reason: String)
    case unhandled(_ reason: String)
}
