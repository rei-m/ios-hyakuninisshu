//
//  KarutaRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/03.
//

import Foundation
import CoreData

protocol KarutaRepositoryProtocol {
    func initialize() -> Result<Void, RepositoryError>
    func findAll() -> Result<[Karuta], RepositoryError>
    func findAllWithCondition(fromNo: KarutaNo, toNo: KarutaNo, kimarijis: [Kimariji], colors: [KarutaColor]) -> Result<[Karuta], RepositoryError>
    
//    func findByNo(karutaNo: KarutaNo) -> Karuta
//
}

private struct KarutaJson: Codable {
    var no: Int8
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
    var kimariji: Int8
    var color: String
    var color_no: Int
}

private extension KarutaJson {
    func toPersistentModel(context: NSManagedObjectContext) -> CDKaruta {
        let cdKaruta = CDKaruta(context: context)
        cdKaruta.no = Int16(no)
        cdKaruta.creator = creator
        cdKaruta.first_kana = first_kana
        cdKaruta.first_kanji = first_kanji
        cdKaruta.second_kana = second_kana
        cdKaruta.second_kanji = second_kanji
        cdKaruta.third_kana = third_kana
        cdKaruta.third_kanji = third_kanji
        cdKaruta.fourth_kana = fourth_kana
        cdKaruta.fourth_kanji = fourth_kanji
        cdKaruta.fifth_kana = fifth_kana
        cdKaruta.fifth_kanji = fifth_kanji
        cdKaruta.kimariji = Int16(kimariji)
        cdKaruta.color = color
        cdKaruta.translation = translation
        return cdKaruta
    }
}

private extension CDKaruta {
    func toModel() -> Karuta {
        let karutaNo = KarutaNo(Int8(no))
        let kamiNoKu = KamiNoKu(
            karutaNo: karutaNo,
            shoku: Verse(
                kana: first_kana!,
                kanji: first_kanji!
            ),
            niku: Verse(
                kana: second_kana!,
                kanji: second_kanji!
            ),
            sanku: Verse(
                kana: third_kana!,
                kanji: third_kanji!
            )
        )
        let shimoNoKu = ShimoNoKu(
            karutaNo: karutaNo,
            shiku: Verse(
                kana: fourth_kana!,
                kanji: fourth_kanji!
            ),
            goku: Verse(
                kana: fifth_kana!,
                kanji: fifth_kanji!
            )
        )

        guard let kimarijiModel = Kimariji(rawValue: Int8(kimariji)) else {
            fatalError("unknown value: kimariji")
        }

        guard let karutaColor = KarutaColor(rawValue: color!) else {
            fatalError("unknown value: color")
        }

        return Karuta(
            no: karutaNo,
            kamiNoKu: kamiNoKu,
            shimoNoKu: shimoNoKu,
            creator: creator!,
            translation: translation!,
            kimariji: kimarijiModel,
            color: karutaColor
        )
    }
}

private struct KarutaListJson: Codable {
    var karuta_list: [KarutaJson]
}

class KarutaRepository: KarutaRepositoryProtocol {

    private static let VERSION = "1"

    private static let VERSION_KEY = "8XhHm"
    
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func initialize() -> Result<Void, RepositoryError> {
        let currentVer = UserDefaults.standard.string(forKey: KarutaRepository.VERSION_KEY)
        if currentVer == KarutaRepository.VERSION {
            return Result.success(())
        }

        guard let url = Bundle.main.url(forResource: "karuta_list_v_3", withExtension: "json") else {
            return Result.failure(RepositoryError.io)
        }
        guard let data = try? Data(contentsOf: url) else {
            return Result.failure(RepositoryError.io)
        }
        
        guard let json = try? JSONDecoder().decode(KarutaListJson.self, from: data) else {
            return Result.failure(RepositoryError.io)
        }
        
        do {
            let context = container.viewContext
            
            // TODO: 掃除する処理を入れる
            
            let _ = json.karuta_list.map { $0.toPersistentModel(context: context) }
            try context.save()
            UserDefaults.standard.setValue(KarutaRepository.VERSION, forKey: KarutaRepository.VERSION_KEY)
            print("success !!")

        } catch {
            let nserror = error as NSError
            // TODO
            print(nserror)
            return Result.failure(RepositoryError.io)
        }
        
        return Result.success(())
    }
    
    func findAll() -> Result<[Karuta], RepositoryError> {
        do {
            let context = container.viewContext
            let fetchRequest = NSFetchRequest<CDKaruta>(entityName: "CDKaruta")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "no", ascending: true)]
            let cdKarutas = try context.fetch(fetchRequest)
            return Result.success(cdKarutas.map { $0.toModel() })
        } catch {
            let nserror = error as NSError
            // TODO
            print(nserror)
            return Result.failure(RepositoryError.io)
        }
    }

    func findAllWithCondition(fromNo: KarutaNo, toNo: KarutaNo, kimarijis: [Kimariji], colors: [KarutaColor]) -> Result<[Karuta], RepositoryError> {
        do {
            let context = container.viewContext
            let fetchRequest = NSFetchRequest<CDKaruta>(entityName: "CDKaruta")
            fetchRequest.predicate = NSPredicate(
                format: "%K BETWEEN {%i, %i} AND kimariji IN %@ AND color IN %@",
                "no",
                fromNo.value,
                toNo.value,
                kimarijis.map { $0.rawValue },
                colors.map { $0.rawValue }
            )
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "no", ascending: true)]
            let cdKarutas = try context.fetch(fetchRequest)
            return Result.success(cdKarutas.map { $0.toModel() })
        } catch {
            let nserror = error as NSError
            // TODO
            print(nserror)
            return Result.failure(RepositoryError.io)
        }
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
