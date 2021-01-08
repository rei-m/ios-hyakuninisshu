//
//  Material.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/26.
//

import Foundation

struct Material {
    static func fromKaruta(_ karuta: Karuta) -> Material {
        return Material(
            no: karuta.no.value,
            kimariji: karuta.kimariji.rawValue,
            creator: karuta.creator,
            shokuKanji: karuta.kamiNoKu.shoku.kanji,
            shokuKana: karuta.kamiNoKu.shoku.kana,
            nikuKanji: karuta.kamiNoKu.niku.kanji,
            nikuKana: karuta.kamiNoKu.niku.kana,
            sankuKanji: karuta.kamiNoKu.sanku.kanji,
            sankuKana: karuta.kamiNoKu.sanku.kana,
            shikuKanji: karuta.shimoNoKu.shiku.kanji,
            shikuKana: karuta.shimoNoKu.shiku.kana,
            gokuKanji: karuta.shimoNoKu.goku.kanji,
            gokuKana: karuta.shimoNoKu.shiku.kana,
            translation: karuta.translation
        )
    }

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
    let kamiNoKuKanji: String
    let kamiNoKuKana: String
    let shimoNoKuKanji: String
    let shimoNoKuKana: String
    
    init(
        no: Int8,
        kimariji: Int8,
        creator: String,
        shokuKanji: String,
        shokuKana: String,
        nikuKanji: String,
        nikuKana: String,
        sankuKanji: String,
        sankuKana: String,
        shikuKanji: String,
        shikuKana: String,
        gokuKanji: String,
        gokuKana: String,
        translation: String
    ) {
        self.no = no
        self.noTxt = KanjiFormatter.no(NSNumber(value: no))
        self.kimariji = kimariji
        self.kimarijiTxt = KanjiFormatter.kimariji(NSNumber(value: kimariji))
        self.creator = creator
        self.shokuKanji = shokuKanji
        self.shokuKana = shokuKana
        self.nikuKanji = nikuKanji
        self.nikuKana = nikuKana
        self.sankuKanji = sankuKanji
        self.sankuKana = sankuKana
        self.shikuKanji = shikuKanji
        self.shikuKana = shikuKana
        self.gokuKanji = gokuKanji
        self.gokuKana = gokuKana
        self.translation = translation
        self.kamiNoKuKanji = "\(shokuKanji)　\(nikuKanji)　\(sankuKanji)"
        self.kamiNoKuKana = "\(shokuKana)　\(nikuKana)　\(sankuKana)"
        self.shimoNoKuKanji = "\(shikuKanji)　\(gokuKanji)"
        self.shimoNoKuKana = "\(shikuKana)　\(gokuKana)"
    }
}
