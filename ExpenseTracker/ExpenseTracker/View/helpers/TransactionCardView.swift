//
//  TransactionCardView.swift
//  ExpenseTracker
//
//  Created by IOS Developer on 15/12/2023.
//

import SwiftUI

struct TransactionCardView: View {
    var transaction: Transaction
    var body: some View {
        HStack(spacing:12){
            Text("\(String(transaction.title.prefix(1)).uppercased())")
                .font(.title)
                .fontWeight(.semibold)
                .frame(width: 45, height: 45, alignment: .center)
                .foregroundStyle(.white)
                .background(transaction.color.gradient,in: .circle)
            
            VStack(alignment: .leading,spacing:4 ){
                Text("\(transaction.title)")
                    .foregroundStyle(Color.primary)
                
                Text("\(transaction.title)")
                    .font(.caption)
                    .foregroundStyle(Color.primary.secondary)
                
                Text(format(date:transaction.dateAdded ,format:"dd MMM YYYY"))
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .lineLimit(1)
            .hSpacing(.leading)
            
            Text(currencyString(transaction.amount,allowedDigits:1))
                .fontWeight(.semibold)
            
        }
        .padding(.horizontal,15)
        .padding(.vertical,10)
        .background(.background,in: .rect(cornerRadius: 10))
    }
}

#Preview {
    TransactionCardView(transaction: sampleTransaction.randomElement()!)
}
