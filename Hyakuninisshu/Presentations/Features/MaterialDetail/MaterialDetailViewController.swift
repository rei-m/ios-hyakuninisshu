//
//  MaterialDetailViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/12.
//

import GoogleMobileAds
import UIKit

class MaterialDetailViewController: UIViewController {
  // MARK: - Outlet
  @IBOutlet weak var karutaImage: UIImageView!
  @IBOutlet weak var creatorLabel: UILabel!
  @IBOutlet weak var kamiNoKuKanjiLabel: UILabel!
  @IBOutlet weak var shimoNoKuKanjiLabel: UILabel!
  @IBOutlet weak var kamiNoKuKanaLabel: UILabel!
  @IBOutlet weak var shimoNoKuKanaLabel: UILabel!
  @IBOutlet weak var transrationLabel: UILabel!
  @IBOutlet weak var bannerView: GADBannerView!

  // MARK: - Property
  private var material: Material!
  private var adController: AdController!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = material.noTxt

    creatorLabel.text = material.creator
    karutaImage.setKarutaImage(no: material.no)
    kamiNoKuKanjiLabel.text = material.kamiNoKuKanji.padSpace()
    shimoNoKuKanjiLabel.text = material.shimoNoKuKanji.padSpace()
    kamiNoKuKanaLabel.text = material.kamiNoKuKana.padSpace()
    shimoNoKuKanaLabel.text = material.shimoNoKuKana.padSpace()
    transrationLabel.text = material.translation

    kamiNoKuKanaLabel.addKimarijiAccent(material.kimariji)

    adController.viewDidLoad(bannerView)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    adController.viewWillAppear()
  }

  override func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.viewWillTransition(to: size, with: coordinator)
    adController.viewWillTransition(to: size, with: coordinator)
  }

  // MARK: - Method
  func inject(
    material: Material,
    adController: AdController
  ) {
    self.material = material
    self.adController = adController
  }
}

extension UILabel {
  fileprivate func addKimarijiAccent(_ kimariji: UInt8) {
    guard let orgText = attributedText?.string else {
      return
    }

    let length = orgText.prefix(Int(kimariji)).contains("　") ? kimariji + 1 : kimariji

    let newAttributedString = NSMutableAttributedString(string: orgText)
    newAttributedString.addAttributes(
      [.foregroundColor: UIColor.systemRed], range: NSRange(location: 0, length: Int(length)))

    attributedText = newAttributedString
  }
}

extension String {
  fileprivate func padSpace() -> String {
    return self.padding(toLength: 21, withPad: "　", startingAt: 0)
  }
}
