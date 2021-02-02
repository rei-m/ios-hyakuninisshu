//
//  Entity.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/15.
//

import Foundation

protocol Entity: Hashable {
  associatedtype Id: EntityId
}
