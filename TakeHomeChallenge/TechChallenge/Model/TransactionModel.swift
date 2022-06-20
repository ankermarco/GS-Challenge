//
//  TransactionModel.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import Foundation

// MARK: - TransactionModel

struct TransactionModel: Equatable {
    enum Category: String, CaseIterable {
        case food
        case health
        case entertainment
        case shopping
        case travel
    }
    
    enum Provider: String {
        case amazon
        case americanAirlines
        case burgerKing
        case cvs
        case exxonmobil
        case jCrew
        case starbucks
        case timeWarner
        case traderJoes
        case uber
        case wawa
        case wendys
    }
    
    let id: Int
    let name: String
    let category: Category
    let amount: Double
    let date: Date
    let accountName: String
    let provider: Provider?
}

extension TransactionModel: Identifiable {}

// MARK: - Category

extension Category: Identifiable {
    var id: String {
        rawValue
    }
}

extension Category {
    static subscript(index: Int) -> Self? {
        guard
            index >= 0 &&
            index < Category.allCases.count
        else {
            return nil
        }
        
        return Category.allCases[index]
    }
}
