//
//  Play.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/31.
//

import Foundation

struct Play {
    let no: Int
    let totalCount: Int
    let yomiFuda: YomiFuda
    let toriFudas: [ToriFuda]
    let correct: Material
    
    var position: String { get { "\(no) / \(totalCount)" } }
}
