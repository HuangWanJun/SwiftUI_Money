//
//  DateFilterView.swift
//  ExpenseTracker
//
//  Created by IOS Developer on 15/12/2023.
//

import SwiftUI

struct DateFilterView: View {
    
    @State var start:Date
    @State var end:Date
    var onSubmit:(Date,Date)->()
    var onClose:()->()
    
    var body: some View {
        VStack(spacing:15){
            DatePicker("start Date", selection: $start, displayedComponents: [.date])
            DatePicker("end Date", selection: $end, displayedComponents: [.date])
            
            HStack(spacing:15){
                Button("Cancel"){
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.red)
                
                Button("Filter"){
                    onSubmit(start,end)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(appTint)
                
            }
            .padding(.top,10)
        }
        .padding(15)
        .background(.bar,in:.rect(cornerRadius: 10))
        .padding(.horizontal,30)
        
    }
}

 
