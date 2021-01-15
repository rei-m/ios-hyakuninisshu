//
//  PresentationError.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/15.
//

import Foundation

public enum PresentationError: Error {
    case unhandled(_ error: Error)
}
