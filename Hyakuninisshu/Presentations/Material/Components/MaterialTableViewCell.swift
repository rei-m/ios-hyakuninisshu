//
//  MaterialTableViewCell.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/11.
//

import UIKit

class MaterialTableViewCell: UITableViewCell {

    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var contentLine1Label: UILabel!
    @IBOutlet weak var contentLine2Label: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var karutaImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
