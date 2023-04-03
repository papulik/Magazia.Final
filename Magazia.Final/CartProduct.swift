//
//  CartProduct.swift
//  Magazia.Final
//
//  Created by Zuka Papuashvili on 31.03.23.
//

import Foundation

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
    
}
