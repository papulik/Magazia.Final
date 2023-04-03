//
//  ProductsViewController.swift
//  Magazia.Final
//
//  Created by Zuka Papuashvili on 22.03.23.
//

import UIKit

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewButtons: ViewButtons!
    
    var buttonQuantity = 0
    var buttonPrice = ""
    var indexForId = 0
    var quantityArray: [Int: Int] = [:]
    
    var products: [[Data.Product]] = []
    var selectedProducts: [Data.Product] = []
    
    let config = URLSessionConfiguration.default
        var session: URLSession!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession(configuration: config)
        
        //MARK: creating views from custom view:
        
        let nib = UINib(nibName: "View", bundle: nil)
        let buttenView = nib.instantiate(withOwner: self, options: nil).first as! ViewButtons
        buttenView.frame = buttenView.bounds
        buttenView.quantityLabel.text = "\(buttonQuantity)"
        buttenView.priceLabel.text = "\(buttonQuantity)"
        viewButtons.addSubview(buttenView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData { [weak self] data in
            guard let self = self else { return }
            
            let groupedProducts = Dictionary(grouping: data.products, by: { $0.category })
            let categories = groupedProducts.keys.sorted()
            
            self.products = categories.map { category in
                return groupedProducts[category] ?? []
            }
            
            self.tableView.reloadData()
        }
    }
    
    func fetchData(completion: @escaping (Data) -> Void) {
        if let jsonData = UserDefaults.standard.data(forKey: "\(indexForId)"),
           let object = try? JSONDecoder().decode(Data.self, from: jsonData) {
            // If the JSON data is already stored in UserDefaults, use it
            completion(object)
        } else {
            // Otherwise, fetch the data from the API
            let urlString = "https://dummyjson.com/products"
            let url = URL(string: urlString)!
            
            session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let response = response as? HTTPURLResponse else {
                    return
                }
                guard (200...299).contains(response.statusCode) else {
                    print("response error")
                    return
                }
                guard let data = data else {
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let object = try decoder.decode(Data.self, from: data)
                    
                    // Store the JSON data in UserDefaults
                    UserDefaults.standard.set(data, forKey: "\(self.indexForId)")
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async {
                        completion(object)
                    }
                    
                } catch {
                    print(error)
                }
                
            }.resume()
        }
    }
    
    @IBAction func shopButton(_ sender: UIButton) {
        
        let cartVC = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        
        cartVC.id = indexForId
        cartVC.selectedProducts = selectedProducts
        cartVC.quantityArray = quantityArray

            navigationController?.pushViewController(cartVC, animated: true)
    }
    
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellMain", for: indexPath) as! TableViewCellMain
        
        cell.delegate = self
        
        if indexPath.section < products.count && indexPath.row < products[indexPath.section].count {
            let productSection = products[indexPath.section]
            let product = productSection[indexPath.row]
            
            cell.priceLabel.text = "Price \(product.price)"
            cell.modelLabel.text = product.brand
            cell.stockLabel.text = "\(product.stock)"
            cell.itemQuantity.text = "1"
            
            cell.quantity = 0
            cell.viewButtons = viewButtons
            cell.indexpath = indexPath
            
            let imageUrlString = product.images.first ?? "https://fastly.picsum.photos/id/424/200/300.jpg"
            let imageUrl = URL(string: imageUrlString)!
            
            let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                guard let imageData = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    cell.customImage.image = UIImage(data: imageData)
                }
            }
            
            task.resume()
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return products[section].first?.category
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension ProductsViewController: TableViewCellMainDelegate {
    func didUpdateQuantity(_ cell: TableViewCellMain, quantity: Int, price: String, indexpath: IndexPath) {
        if let indexPath = tableView.indexPath(for: cell), indexPath.section < products.count && indexPath.row < products[indexPath.section].count {
            let productSection = products[indexPath.section]
            let selectedProduct = productSection[indexPath.row]
            buttonQuantity = quantity
            quantityArray[indexpath.row] = buttonQuantity
            buttonPrice = price // price is a String
            
//            indexForId = indexpath.row
            
            if buttonQuantity > 0 {
                selectedProducts.append(selectedProduct)
            } else if let index = selectedProducts.firstIndex(where: { $0.id == selectedProduct.id }) {
                if buttonQuantity > 0 {
                    selectedProducts[index] = selectedProduct
                } else {
                    selectedProducts.remove(at: index)
                }
            }
                
            
            // sum the quantities of all cells
            buttonQuantity = tableView.visibleCells
                .compactMap { $0 as? TableViewCellMain }
                .reduce(0) { $0 + $1.quantity }
            
            // sum the prices of all cells
            let mainCells = tableView.visibleCells.compactMap { $0 as? TableViewCellMain }
            let totalPrice = mainCells.reduce(0.0) { result, cell in
                if let priceString = cell.priceLabel.text?.replacingOccurrences(of: "Price ", with: ""),
                   let price = Double(priceString) {
                    return result + Double(cell.quantity) * price
                }
                return result
            }
            buttonPrice = String(totalPrice)

            // Find the ViewButtons instance in the subviews array
            if let buttenView = viewButtons.subviews.first(where: { $0 is ViewButtons }) as? ViewButtons {
                buttenView.quantityLabel.text = "\(buttonQuantity)"
                buttenView.priceLabel.text = "\(buttonPrice)"
            }
        }
    }
}
