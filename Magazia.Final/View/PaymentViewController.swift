//
//  PaymentViewController.swift
//  Magazia.Final
//
//  Created by Zuka Papuashvili on 31.03.23.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var text = ""
    var image = UIImage(named: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentLabel.text = text
        paymentImage.image = image
        
        backButton.layer.cornerRadius = backButton.frame.width / 20
        backButton.clipsToBounds = true
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
