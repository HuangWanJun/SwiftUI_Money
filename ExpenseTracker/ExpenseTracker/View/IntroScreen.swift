//
//  Foundation.swift
//  ExpenseTracker
//
//  Created by IOS Developer on 13/12/2023.
//

import SwiftUI

struct IntroScreen: View {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = false
    var body: some View {
        
        VStack(spacing: 15) {
            Text("What's new in the\nExpense Tracker")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top,65)
            .padding(.bottom,35)
            
            VStack(alignment: .leading, spacing: 25) {
                 PointView(symbol: "dollarsign", title: "Transcations", subTtile: "keep track of your earnings and expensee.")
                
                PointView(symbol: "chart.bar.fill", title: "Transcations", subTtile: "keep track of your earnings and expensee.")
                
                PointView(symbol: "magnifyingglass", title: "Transcations", subTtile: "keep track of your earnings and expensee.")
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.horizontal,20)
            
            Spacer(minLength: 10)
            
            Button {
                isFirstTime = false
            } label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,14)
                    .background(appTint.gradient,in:.rect(cornerRadius: 12))
                    .contentShape(.rect)
            }

        }
        .padding(15)
            
    }
    
    @ViewBuilder
    func PointView(symbol:String,title:String,subTtile:String) -> some View {
        HStack(spacing: 20){
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTint.gradient)
                .frame(width: 45)
            
            VStack(alignment: .leading,spacing: 6, content: {
                 Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTtile)
                    .foregroundStyle(.gray)
            })
        }
    }
}

#Preview {
    IntroScreen()
}
