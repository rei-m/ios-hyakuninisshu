//
//  MaterialTableViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import UIKit

protocol MaterialTableViewProtocol: AnyObject {
  func updateLoading(_ isLoading: Bool)
  func updateMaterialTable(_ materials: [Material])
  func presentErrorVC(_ error: Error)
}

class MaterialTableViewController: UITableViewController {
  // MARK: - Property
  private var presenter: MaterialTablePresenterProtocol!

  private var materials: [Material] = []

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.viewDidLoad()
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return materials.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
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

    default:
      fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
    }
  }

  // MARK: - Method
  func inject(presenter: MaterialTablePresenterProtocol) {
    self.presenter = presenter
  }
}

extension MaterialTableViewController: MaterialTableViewProtocol {
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
