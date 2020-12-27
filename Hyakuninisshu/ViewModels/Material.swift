//
//  Material.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/26.
//

import Foundation

struct Material {
    let no: Int8
    let noTxt: String
    let kimariji: Int8
    let kimarijiTxt: String
    let creator: String
    let shokuKanji: String
    let shokuKana: String
    let nikuKanji: String
    let nikuKana: String
    let sankuKanji: String
    let sankuKana: String
    let shikuKanji: String
    let shikuKana: String
    let gokuKanji: String
    let gokuKana: String
    let translation: String

    var kamiNoKuKanji: String {
        get { "\(shokuKanji)　\(nikuKanji)　\(sankuKanji)" }
    }
    
    var kamiNoKuKana: String {
        get { "\(shokuKana)　\(nikuKana)　\(sankuKana)" }
    }
    
    var shimoNoKuKanji: String {
        get { "\(shikuKanji)　\(gokuKanji)" }
    }
    
    var shimoNoKuKana: String {
        get { "\(shikuKana)　\(gokuKana)" }
    }
}
