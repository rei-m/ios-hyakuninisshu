//
//  KarutaRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/03.
//

import Foundation
import CoreData

protocol KarutaRepositoryProtocol {
    func initialize() -> Result<Void, Error>
    
//    func findByNo(karutaNo: KarutaNo) -> Karuta
//
//    func findAll() -> [Karuta]
//
//    func findAllWithCondition(fromNo: KarutaNo, toNo: KarutaNo, kimarijis: [Kimariji], colors: [KarutaColor]) -> [Karuta]
}

class KarutaRepository: KarutaRepositoryProtocol {

    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }

    func initialize() -> Result<Void, Error> {
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
