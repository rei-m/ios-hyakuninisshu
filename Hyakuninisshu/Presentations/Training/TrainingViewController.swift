//
//  TrainingViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import UIKit

class TrainingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
                
    override func viewDidLoad() {
        super.viewDidLoad()

        print("unko")
        // Do any additional setup after loading the view.

        let questionsResult = karutaRepository.findAll().map { karutas -> Optional<[Question]> in
            let allKarutaNoCollection = KarutaNoCollection(values: karutas.map { $0.no })
            let questions = CreateQuestionsService(allKarutaNoCollection)?.execute(targetKarutaNoCollection: KarutaNoCollection(values: [KarutaNo(1), KarutaNo(5), KarutaNo(8)]), choiceSize: 4)
            return questions
        }

        switch questionsResult {
        case .success(let questions):
            guard let questions = questions else {
                fatalError()
            }
//            dump(questions)
        case .failure(let e):
            dump(e)
        }
    }
    
    private let ITEMS = ["1", "2", "3", "4", "5"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ITEMS.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ITEMS[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
