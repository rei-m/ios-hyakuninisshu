//
//  KarutaNo.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

//
// MARK: - KarutaNo
//
struct KarutaNo {
    let value: Int

    init(_ value: Int) {
        self.value = value
    }
    
    static let MIN = KarutaNo(1)
    static let MAX = KarutaNo(100)
    static let LIST: [KarutaNo] = (MIN.value...MAX.value).map { KarutaNo($0) }
}
