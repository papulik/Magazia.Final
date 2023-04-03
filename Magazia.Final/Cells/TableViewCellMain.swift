//
//  TableViewCellMain.swift
//  Magazia.Final
//
//  Created by Zuka Papuashvili on 23.03.23.
//

import UIKit

protocol TableViewCellMainDelegate: AnyObject {
    func didUpdateQuantity(_ cell: TableViewCellMain, quantity: Int, price: String, indexpath: IndexPath)
}

class TableViewCellMain: UITableViewCell {
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var customImage: UIImageView!
    @IBOutlet weak var itemQuantity: UILabel!
    
    
    weak var delegate: TableViewCellMainDelegate?
    
    var viewButtons: ViewButtons?
    
    var indexpath: IndexPath?
    
    var quantity: Int = 0 {
            didSet {
                itemQuantity.text = "\(quantity)"
            }
        }
    
    var price: String {
        return priceLabel.text ?? "Nil"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func plus(_ sender: UIButton) {
        quantity += 1
        itemQuantity.text = "\(quantity)"
        delegate?.didUpdateQuantity(self, quantity: quantity, price: price, indexpath: indexpath!)
    }
    
    @IBAction func minus(_ sender: UIButton) {
        if quantity > 0 {
            quantity -= 1
            itemQuantity.text = "\(quantity)"
            delegate?.didUpdateQuantity(self, quantity: quantity, price: price, indexpath: indexpath!)
        }
    }
    
}
