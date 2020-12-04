//
//  KarutaRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/03.
//

import Foundation
import CoreData

enum RepositoryError: Error {
    case initialize
}

protocol KarutaRepositoryProtocol {
    func initialize() -> Result<Void, RepositoryError>
    
//    func findByNo(karutaNo: KarutaNo) -> Karuta
//
//    func findAll() -> [Karuta]
//
//    func findAllWithCondition(fromNo: KarutaNo, toNo: KarutaNo, kimarijis: [Kimariji], colors: [KarutaColor]) -> [Karuta]
}

private struct KarutaJson: Codable {
    var no: Int
    var creator: String
    var first_kana: String
    var first_kanji: String
    var second_kana: String
    var second_kanji: String
    var third_kana: String
    var third_kanji: String
    var fourth_kana: String
    var fourth_kanji: String
    var fifth_kana: String
    var fifth_kanji: String
    var translation: String
    var kimariji: Int
    var color: String
    var color_no: Int
}

private extension KarutaJson {
    func toModel() -> Karuta {
        let karutaNo = KarutaNo(no)
        let kamiNoKu = KamiNoKu(
            karutaNo: karutaNo,
            shoku: Verse(
                kana: first_kana,
                kanji: first_kanji
            ),
            niku: Verse(
                kana: second_kana,
                kanji: second_kanji
            ),
            sanku: Verse(
                kana: third_kana,
                kanji: third_kanji
            )
        )
        let shimoNoKu = ShimoNoKu(
            karutaNo: karutaNo,
            shiku: Verse(
                kana: fourth_kana,
                kanji: first_kanji
            ),
            goku: Verse(
                kana: fifth_kana,
                kanji: fifth_kanji
            )
        )
        guard let kimarijiModel = Kimariji(rawValue: kimariji) else {
            fatalError("unknown value: kimariji")
        }
        guard let karutaColor = KarutaColor(rawValue: color) else {
            fatalError("unknown value: color")
        }
        
        return Karuta(
            no: karutaNo,
            kamiNoKu: kamiNoKu,
            shimoNoKu: shimoNoKu,
            creator: creator,
            translation: translation,
            kimariji: kimarijiModel,
            color: karutaColor
        )
    }
}

private struct KarutaListJson: Codable {
    var karuta_list: [KarutaJson]
}

class KarutaRepository: KarutaRepositoryProtocol {
    
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }

    func initialize() -> Result<Void, RepositoryError> {
        guard let url = Bundle.main.url(forResource: "karuta_list_v_3", withExtension: "json") else {
            return Result.failure(RepositoryError.initialize)
        }
        guard let data = try? Data(contentsOf: url) else {
            return Result.failure(RepositoryError.initialize)
        }
        
        guard let json = try? JSONDecoder().decode(KarutaListJson.self, from: data) else {
            return Result.failure(RepositoryError.initialize)
        }
        
        for karutaJson in json.karuta_list {
            print(karutaJson.toModel())
        }
        
        return Result.success(())
    }
    
//    func findByNo(karutaNo: KarutaNo) -> Karuta {
//        let no = KarutaNo.MIN
//        return Karuta(
//            no: no,
//            kamiNoKu: KamiNoKu(
//                karutaNo: no,
//                shoku: Verse(kana: <#T##String#>, kanji: <#T##String#>),
//                niku: <#T##Verse#>,
//                sanku: Verse
//            ))
//    }
}
