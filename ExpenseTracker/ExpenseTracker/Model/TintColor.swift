//
//  TintColor.swift
//  ExpenseTracker
//
//  Created by IOS Developer on 14/12/2023.
//

import SwiftUI

struct TintColor: Identifiable{
    let id:UUID = .init()
    var color:String
    var value:Color
    
}

var tints:[TintColor] = [
    .init(color: "Red", value: .red),
    .init(color: "Blue", value: .blue),
    .init(color: "Pink", value: .pink),
    .init(color: "Purple", value: .purple),
    .init(color: "Brown", value: .brown),
    .init(color: "Orange", value: .orange)
]
