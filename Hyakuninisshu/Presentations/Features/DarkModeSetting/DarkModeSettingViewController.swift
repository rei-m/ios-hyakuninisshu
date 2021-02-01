//
//  DarkModeSettingViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/31.
//

import UIKit

class DarkModeSettingViewController: UITableViewController {
    @IBOutlet weak var unspecifiedCell: UITableViewCell!
    @IBOutlet weak var lightCell: UITableViewCell!
    @IBOutlet weak var darkCell: UITableViewCell!
    
    private var cells: [UITableViewCell] {
        [unspecifiedCell, lightCell, darkCell]
    }
    
    private let styles: [UIUserInterfaceStyle] = [.unspecified, .light, .dark]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch UserDefaults.standard.darkMode {
        case .unspecified:
            unspecifiedCell.accessoryType = .checkmark
        case .light:
            lightCell.accessoryType = .checkmark
        case .dark:
            darkCell.accessoryType = .checkmark
        @unknown default:
            fatalError("unknown UIUserInterfaceStyle. value=\(UserDefaults.standard.darkMode)")
        }
        
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cells.enumerated().forEach { (offset, cell) in
            cell.accessoryType = offset == indexPath.item ? .checkmark : .none
        }
        UserDefaults.standard.setDarkMode(styles[indexPath.item])
        view.window?.overrideUserInterfaceStyle = styles[indexPath.item]
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("unko")
//        tableView.estimatedRowHeight = 80 //セルの高さ
//        return UITableView.automaticDimension //自動設定
//     }
}
