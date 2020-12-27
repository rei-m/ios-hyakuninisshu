//
//  KarutaExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/26.
//

import Foundation

extension Karuta {
    func toMaterial() -> Material {
        return Material(
            no: no.value,
            noTxt: no.text,
            kimariji: kimariji.rawValue,
            kimarijiTxt: "\(KanjiFormatter.string(NSNumber(value: kimariji.rawValue)))字決まり",
            creator: creator,
            shokuKanji: kamiNoKu.shoku.kanji,
            shokuKana: kamiNoKu.shoku.kana,
            nikuKanji: kamiNoKu.niku.kanji,
            nikuKana: kamiNoKu.niku.kana,
            sankuKanji: kamiNoKu.sanku.kanji,
            sankuKana: kamiNoKu.sanku.kana,
            shikuKanji: shimoNoKu.shiku.kanji,
            shikuKana: shimoNoKu.shiku.kana,
            gokuKanji: shimoNoKu.goku.kanji,
            gokuKana: shimoNoKu.shiku.kana,
            translation: translation
        )
    }
}
