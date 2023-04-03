//
//  CartTableViewCell.swift
//  Magazia.Final
//
//  Created by Zuka Papuashvili on 30.03.23.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var customImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
