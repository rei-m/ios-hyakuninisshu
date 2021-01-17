//
//  PresentationError.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/15.
//

import Foundation

struct PresentationError: Error {
    enum ErrorKind {
        case unhandled
    }

    let reason: String
    let kind: ErrorKind
    
    init(reason: String, kind: ErrorKind) {
        self.reason = reason
        self.kind = kind
    }
    
    init(_ domainError: DomainError) {
        self.reason = "Domain: \(domainError.reason)"
        self.kind = .unhandled
    }
}
