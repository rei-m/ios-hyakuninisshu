//
//  KarutaNoCollection.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import Foundation

struct KarutaNoCollection {
    let values: [KarutaNo]

    var count: Int {
        get { values.count }
    }
    
    var asRandomized: [KarutaNo] {
        get {
            values
        }
    }
}
