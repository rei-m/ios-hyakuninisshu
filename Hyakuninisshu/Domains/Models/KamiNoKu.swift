//
//  KamiNoKu.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

struct KamiNoKu: ValueObject {
    let karutaNo: KarutaNo
    let shoku: Verse
    let niku: Verse
    let sanku: Verse
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(karutaNo)
    }
}
