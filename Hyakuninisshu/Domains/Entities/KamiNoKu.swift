//
//  KamiNoKu.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import Foundation

struct KamiNoKu {
    let karutaNo: KarutaNo
    let shoku: Verse
    let niku: Verse
    let sanku: Verse
    
    var kana: String {
        get { "\(shoku.kana)　\(niku.kana)　\(sanku.kana)" }
    }
    
    var kanji: String {
        get { "\(shoku.kanji)　\(niku.kanji)　\(sanku.kanji)" }
    }
}
