//
//  Transaction.swift
//  ExpenseTracker
//
//  Created by IOS Developer on 14/12/2023.
//

import SwiftUI

struct
Transaction:
    Identifiable {
    
    let id:UUID = .init()
    
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var category:String
    var tintColor:String

    init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    var color:Color {
        return tints.first(where: {$0.color == tintColor })?.value ?? appTint
    }
}

///sample
var sampleTransaction:[Transaction] = [
    .init(title: "Magic keyboard", remarks: "Apple Product", amount: 129, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "Apple music", remarks: "Subscription", amount: 0.57, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "icloud+", remarks: "Apple Product", amount: 10.99, dateAdded: .now, category: .income, tintColor: tints.randomElement()!),
    .init(title: "Payment", remarks: "Apple Product", amount: 2499, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
]
