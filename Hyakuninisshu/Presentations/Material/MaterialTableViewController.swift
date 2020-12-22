//
//  MaterialTableViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import UIKit

protocol MaterialTableViewProtocol: AnyObject {
    func updateLoading(_ isLoading: Bool)
    func updateKarutaTable(_ karutas: [Karuta])
    func displayError(_ message: String)
}

class MaterialTableViewController: UITableViewController, MaterialTableViewProtocol {

    private var presenter: MaterialTablePresenterProtocol!
    
    private var model: MaterialTableModelProtocol!
    
    private var karutas: [Karuta] = []
    
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
        return karutas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialTableViewCell", for: indexPath) as? MaterialTableViewCell else {
            fatalError("The dequeued cell is not instance of MaterialTableViewCell.")
        }

        let item = karutas[indexPath.item]
        
        cell.noLabel.text = item.no.text
        cell.contentLine1Label.text = item.kamiNoKu.kanji
        cell.contentLine2Label.text = item.shimoNoKu.kanji
        cell.creatorLabel.text = item.creator
        cell.karutaImage.setKarutaImage(no: item.no)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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

                let selectedMaterial = karutas[indexPath.row]
                mealDetailViewController.material = selectedMaterial

            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    func inject(presenter: MaterialTablePresenterProtocol, model: MaterialTableModelProtocol) {
        self.presenter = presenter
        self.model = model
    }
    
    // MARK: - View methods
    func updateLoading(_ isLoading: Bool) {
        // deprecatedになった
        // UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }
    
    func updateKarutaTable(_ karutas: [Karuta]) {
        self.karutas = karutas
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func displayError(_ message: String) {
        // TODO
        print("Error: \(message)")
    }
}
