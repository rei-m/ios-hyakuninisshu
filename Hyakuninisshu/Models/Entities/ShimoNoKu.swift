//
//  ShimoNoKu.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

struct ShimoNoKu {
    let karutaNo: KarutaNo
    let shiku: Verse
    let goku: Verse
    
    var kana: String {
        get { "\(shiku.kana) \(goku.kana)" }
    }
    
    var kanji: String {
        get { "\(shiku.kanji) \(goku.kanji)" }
    }
}
