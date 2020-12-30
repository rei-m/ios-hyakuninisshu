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
    func displayError(_ message: String)
}

class MaterialTableViewController: UITableViewController, MaterialTableViewProtocol {

    private var presenter: MaterialTablePresenterProtocol!

    private var materials: [Material] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()    
        presenter.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return materials.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialTableViewCell", for: indexPath) as? MaterialTableViewCell else {
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
    
    func inject(presenter: MaterialTablePresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - View methods
    func updateLoading(_ isLoading: Bool) {
        // deprecatedになった
        // UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }
    
    func updateMaterialTable(_ materials: [Material]) {
        self.materials = materials
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func displayError(_ message: String) {
        // TODO
        print("Error: \(message)")
    }
}
