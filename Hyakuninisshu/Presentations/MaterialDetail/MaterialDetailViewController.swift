//
//  MaterialDetailViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/12.
//

import UIKit

class MaterialDetailViewController: UIViewController {

    var material: Material!

    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var karutaImage: UIImageView!
    @IBOutlet weak var kamiNoKuKanjiLabel: UILabel!
    @IBOutlet weak var shimoNoKuKanjiLabel: UILabel!
    @IBOutlet weak var kamiNoKuKanaLabel: UILabel!
    @IBOutlet weak var shimoNoKuKanaLabel: UILabel!
    @IBOutlet weak var transrationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = material.noTxt
        
        // Do any additional setup after loading the view.

        noLabel.text = material.noTxt
        creatorLabel.text = material.creator
        karutaImage.setKarutaImage(no: material.no)
        kamiNoKuKanjiLabel.text = material.kamiNoKuKanji.padSpace()
        shimoNoKuKanjiLabel.text = material.shimoNoKuKanji.padSpace()
        kamiNoKuKanaLabel.text = material.kamiNoKuKana.padSpace()
        shimoNoKuKanaLabel.text = material.shimoNoKuKana.padSpace()
        transrationLabel.text = material.translation
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

extension String {
    func padSpace() -> String {
        return self.padding(toLength: 21, withPad: "　", startingAt: 0)
    }
}
