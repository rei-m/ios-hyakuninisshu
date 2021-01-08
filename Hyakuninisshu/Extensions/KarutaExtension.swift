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
    
    func toToriFuda(style: DisplayStyleCondition) -> ToriFuda {
        switch style.value {
        case 0:
            return ToriFuda(karutaNo: no.value, firstLine: shimoNoKu.shiku.kanji, secondLine: shimoNoKu.goku.kanji)
        case 1:
            return ToriFuda(karutaNo: no.value, firstLine: shimoNoKu.shiku.kana, secondLine: shimoNoKu.goku.kana)
        default:
            fatalError("unknown value")
        }
    }
    
    func toYomiFuda(style: DisplayStyleCondition) -> YomiFuda {
        switch style.value {
        case 0:
            return YomiFuda(karutaNo: no.value, firstLine: kamiNoKu.shoku.kanji, secondLine: kamiNoKu.niku.kanji, thirdLine: kamiNoKu.sanku.kanji)
        case 1:
            return YomiFuda(karutaNo: no.value, firstLine: kamiNoKu.shoku.kana, secondLine: kamiNoKu.niku.kana, thirdLine: kamiNoKu.sanku.kana)
        default:
            fatalError("unknown value")
        }
    }
}
