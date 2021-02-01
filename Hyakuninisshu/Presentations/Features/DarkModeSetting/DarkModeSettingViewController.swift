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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cells.enumerated().forEach { (offset, cell) in
            cell.accessoryType = offset == indexPath.item ? .checkmark : .none
        }
        UserDefaults.standard.setDarkMode(styles[indexPath.item])
        view.window?.overrideUserInterfaceStyle = styles[indexPath.item]
    }
}
