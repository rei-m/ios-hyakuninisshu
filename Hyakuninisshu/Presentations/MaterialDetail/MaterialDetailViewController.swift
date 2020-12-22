//
//  MaterialDetailViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/12.
//

import UIKit

class MaterialDetailViewController: UIViewController {

    var material: Karuta!

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
        navigationItem.title = material.no.text
        
        // Do any additional setup after loading the view.

        noLabel.text = material.no.text
        creatorLabel.text = material.creator
        karutaImage.setKarutaImage(no: material.no)
        kamiNoKuKanjiLabel.text = material.kamiNoKu.kanji.padSpace()
        shimoNoKuKanjiLabel.text = material.shimoNoKu.kanji.padSpace()
        kamiNoKuKanaLabel.text = material.kamiNoKu.kana.padSpace()
        shimoNoKuKanaLabel.text = material.shimoNoKu.kana.padSpace()
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
