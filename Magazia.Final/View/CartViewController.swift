//
//  CartViewController.swift
//  Magazia.Final
//
//  Created by Zuka Papuashvili on 30.03.23.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var delivaryLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var balance: Double = 5000
    var id = 0
    var selectedProducts: [Data.Product] = []
    var quantityArray: [Int: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let totalPrice = selectedProducts.reduce(0.0) { $0 + $1.price }
        let fee = totalPrice / 10
        priceLabel.text = "\(totalPrice)"
        feeLabel.text = "\(fee)"
        delivaryLabel.text = "50"
        
        let total = totalPrice + fee + 50
        
        totalPriceLabel.text = "\(total)"
        
        tableView.reloadData()
    }
    
    @IBAction func payButton(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        
        let totalString = totalPriceLabel.text
        let totalDouble = Double(totalString ?? "0.0")
        
        if totalDouble! < balance {
            vc.text = "გადახდა წარმატებით დასრულდა"
            vc.image = UIImage(named: "tick-circle")
            
            present(vc, animated: true)
            
        } else {
            vc.text = "სამწუხაროდ გადახდა ვერ მოხერხდა, სცადეთ თავიდან"
            vc.image = UIImage(named: "close-circle")
            
            present(vc, animated: true)
        }
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        let product = selectedProducts[indexPath.row]
        cell.priceLabel.text = "\(product.price)"
        cell.quantityLabel.text = "\(quantityArray[indexPath.row] ?? 1)"
        cell.nameLabel.text = "\(product.brand)"
        
        let imageUrlString = product.images.first ?? "https://fastly.picsum.photos/id/424/200/300.jpg"
        let imageUrl = URL(string: imageUrlString)!
        
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            guard let imageData = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                cell.customImageView.image = UIImage(data: imageData)
            }
        }
        
        task.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
