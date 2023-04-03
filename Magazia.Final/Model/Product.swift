//
//  Product.swift
//  Magazia.Final
//
//  Created by Zuka Papuashvili on 25.03.23.
//

struct Data: Codable {
    
    var products: [Product]
    
    struct Product: Codable {
        let id: Int
        let title: String
        let description: String
        let price: Double
        let discountPercentage: Double?
        let rating: Double
        let stock: Int
        let brand: String
        let category: String
        let images: [String]
        
        enum CodingKeys: String, CodingKey {
                case id
                case title
                case description
                case price
                case discountPercentage
                case rating
                case stock
                case brand
                case category
                case images
            }
    }
}




