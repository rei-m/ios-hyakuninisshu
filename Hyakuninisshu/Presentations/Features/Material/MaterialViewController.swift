//
//  MaterialViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/02/05.
//

import GoogleMobileAds
import UIKit

protocol MaterialViewProtocol: AnyObject {
  func updateLoading(_ isLoading: Bool)
  func updateMaterialTable(_ materials: [Material])
  func presentErrorVC(_ error: Error)
}

class MaterialViewController: UIViewController {
  // MARK: - Property
  private var presenter: MaterialPresenterProtocol!

  private var materials: [Material] = []

  // MARK: - Outlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var bannerView: GADBannerView!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpAdBannerView(bannerView)
    tableView.dataSource = self
    presenter.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = false
    loadBannerAd()
  }

  override func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.loadBannerAd()
    })
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    switch segue.identifier ?? "" {
    case "ShowMaterialDetail":
      guard let mealDetailViewController = segue.destination as? MaterialDetailViewController else {
        fatalError("Unexpected destination: \(segue.destination)")
      }

      guard let selectedMaterialCell = sender as? MaterialTableViewCell else {
        fatalError("Unexpected sender: \(String(describing: sender))")
      }

      guard let indexPath = tableView.indexPath(for: selectedMaterialCell) else {
        fatalError("The selected cell is not being displayed by the table")
      }

      let selectedMaterial = materials[indexPath.row]
      mealDetailViewController.material = selectedMaterial
      tableView.deselectRow(at: indexPath, animated: true)
    default:
      fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
    }
  }

  // MARK: - Method
  func inject(presenter: MaterialPresenterProtocol) {
    self.presenter = presenter
  }

  private func loadBannerAd() {
    bannerView.load(adSize)
  }
}

extension MaterialViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return materials.count + 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.item == materials.count {
      let cell = tableView.dequeueReusableCell(withIdentifier: "AdBannerCell", for: indexPath)
      cell.heightAnchor.constraint(equalToConstant: adSize.size.height).isActive = true
      return cell
    }

    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "MaterialTableViewCell", for: indexPath) as? MaterialTableViewCell
    else {
      fatalError("The dequeued cell is not instance of MaterialTableViewCell.")
    }

    let item = materials[indexPath.item]

    cell.noLabel.text = item.noTxt
    cell.contentLine1Label.text = item.kamiNoKuKanji
    cell.contentLine2Label.text = item.shimoNoKuKanji
    cell.creatorLabel.text = item.creator
    cell.karutaImage.setKarutaImage(no: item.no)

    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}

extension MaterialViewController: MaterialViewProtocol {
  func updateLoading(_ isLoading: Bool) {
    // deprecatedになった
    // UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
  }

  func updateMaterialTable(_ materials: [Material]) {
    self.materials = materials
    self.tableView.reloadData()
  }

  func presentErrorVC(_ error: Error) {
    presentUnexpectedErrorVC(error)
  }
}
