//
//  Double.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import Foundation

extension Double {
    func formatted(hasDecimals: Bool = true) -> String {
        String(format: hasDecimals ? "%.2f" : "%.0f", self)
    }
    
    func toPrice(currencyCode: String = Currency.usd.rawValue) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.maximumFractionDigits = 2

        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }
}

enum Currency: String {
    case eur
    case usd
}
