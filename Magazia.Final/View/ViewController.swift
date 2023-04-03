//
//  ViewController.swift
//  Magazia.Final
//
//  Created by Zuka Papuashvili on 22.03.23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var mailX: UIImageView!
    @IBOutlet weak var passX: UIImageView!

    let account = Account(mail: "zuka@gmail.com", password: "12345")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButtonImage = UIImage(named: "backButtonImage")
        
        // Set the back indicator image and transition mask image
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        // Set the title of the back button to an empty string
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        mailX.isHidden = true
        passX.isHidden = true
    }

    @IBAction func logInButton(_ sender: UIButton) {
        
        let productsVC = storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        if textFieldMail.text == account.mail && textFieldPassword.text == account.password {
            navigationController?.pushViewController(productsVC, animated: true)
        } else {
            mailX.isHidden = false
            passX.isHidden = false
        }
    }
    
}

