//
//  KarutaRepository.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/03.
//

import Foundation
import CoreData
import Combine

protocol KarutaRepositoryProtocol {
    func initialize() -> AnyPublisher<Void, RepositoryError>
    func findAll() -> AnyPublisher<[Karuta], RepositoryError>
    func findAll(fromNo: KarutaNo, toNo: KarutaNo, kimarijis: [Kimariji], colors: [KarutaColor]) -> AnyPublisher<[Karuta], RepositoryError>
    func findAll(karutaNos: [KarutaNo]) -> AnyPublisher<[Karuta], RepositoryError>
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

    func initialize() -> AnyPublisher<Void, RepositoryError> {
        let publisher = Future<Void, RepositoryError>{ promise in
            let currentVer = UserDefaults.standard.string(forKey: KarutaRepository.VERSION_KEY)
            if currentVer == KarutaRepository.VERSION {
                promise(.success(()))
                return
            }

            DispatchQueue.global(qos: .userInteractive).async {
                guard let url = Bundle.main.url(forResource: "karuta_list_v_3", withExtension: "json") else {
                    promise(.failure(.io))
                    return
                }
                guard let data = try? Data(contentsOf: url) else {
                    promise(.failure(.io))
                    return
                }
                
                guard let json = try? JSONDecoder().decode(KarutaListJson.self, from: data) else {
                    promise(.failure(.io))
                    return
                }

                do {
                    let context = self.container.viewContext
                    
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDKaruta.fetchRequest()
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    deleteRequest.resultType = .resultTypeObjectIDs
                    
                    try context.execute(deleteRequest)

                    let _ = json.karuta_list.map { $0.toPersistentModel(context: context) }
                    try context.save()
                    UserDefaults.standard.setValue(KarutaRepository.VERSION, forKey: KarutaRepository.VERSION_KEY)
                    // TODO
                    print("success !!")
                    
                    promise(.success(()))
                } catch {
                    let nserror = error as NSError
                    // TODO
                    print(nserror)
                    
                    promise(.failure(.io))
                }
            }
        }
        
        return publisher.eraseToAnyPublisher()
    }

    func findAll() -> AnyPublisher<[Karuta], RepositoryError> {
        let publisher = Future<[Karuta], RepositoryError> { promise in
            let fetchRequest: NSFetchRequest<CDKaruta> = CDKaruta.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "no", ascending: true)]

            let asyncFetch = NSAsynchronousFetchRequest<CDKaruta>(fetchRequest: fetchRequest){ result in
                guard let cdKarutas = result.finalResult else {
                    return
                }
                promise(.success(cdKarutas.map { $0.toModel() }))
            }

            do {
                let backgroundContext = self.container.newBackgroundContext()
                try backgroundContext.execute(asyncFetch)
            } catch let error {
                let nserror = error as NSError
                // TODO
                print(nserror)
                promise(.failure(.io))
            }
        }

        return publisher.eraseToAnyPublisher()
    }

    func findAll(fromNo: KarutaNo, toNo: KarutaNo, kimarijis: [Kimariji], colors: [KarutaColor]) -> AnyPublisher<[Karuta], RepositoryError> {
        let publisher = Future<[Karuta], RepositoryError> { promise in
            let fetchRequest: NSFetchRequest<CDKaruta> = CDKaruta.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "%K BETWEEN {%i, %i} AND kimariji IN %@ AND color IN %@",
                "no",
                fromNo.value,
                toNo.value,
                kimarijis.map { $0.rawValue },
                colors.map { $0.rawValue }
            )
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "no", ascending: true)]

            let asyncFetch = NSAsynchronousFetchRequest<CDKaruta>(fetchRequest: fetchRequest){ result in
                guard let cdKarutas = result.finalResult else {
                    return
                }
                promise(.success(cdKarutas.map { $0.toModel() }))
            }

            do {
                let backgroundContext = self.container.newBackgroundContext()
                try backgroundContext.execute(asyncFetch)
            } catch let error {
                let nserror = error as NSError
                // TODO
                print(nserror)
                promise(.failure(.io))
            }
        }

        return publisher.eraseToAnyPublisher()
    }
    
    func findAll(karutaNos: [KarutaNo]) -> AnyPublisher<[Karuta], RepositoryError> {
        let publisher = Future<[Karuta], RepositoryError> { promise in
            let fetchRequest: NSFetchRequest<CDKaruta> = CDKaruta.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "%K IN %@",
                "no",
                karutaNos.map { $0.value }
            )
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "no", ascending: true)]

            let asyncFetch = NSAsynchronousFetchRequest<CDKaruta>(fetchRequest: fetchRequest){ result in
                guard let cdKarutas = result.finalResult else {
                    return
                }
                promise(.success(cdKarutas.map { $0.toModel() }))
            }

            do {
                let backgroundContext = self.container.newBackgroundContext()
                try backgroundContext.execute(asyncFetch)
            } catch let error {
                let nserror = error as NSError
                // TODO
                print(nserror)
                promise(.failure(.io))
            }
        }

        return publisher.eraseToAnyPublisher()
    }
}
