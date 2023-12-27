//
//  NewExpenseView.swift
//  ExpenseTracker
//
//  Created by IOS Developer on 27/12/2023.
//

import SwiftUI

struct TransactionView: View {
    ///Env
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title:String = ""
    @State private var remarks:String = ""
    @State private var amount:Double = .zero
    @State private var dateAdded:Date = .now
    @State private var category:Category = .expense
    
    var editTranscation:Transaction?
    @State var tint:TintColor = tints.randomElement()!
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing:15){
                Text("preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                //preview transaction card view
                TransactionCardView(transaction: .init(
                    title: title.isEmpty ? "Title" : title,
                    remarks: remarks.isEmpty ? "Remarks" : remarks,
                    amount: amount,
                    dateAdded: dateAdded, category: category, tintColor: tint
                ))
                
                customSection("Title","Magic Keyborad", value: $title)
                customSection("Remark","Apple Product", value: $remarks)
                
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Amount a Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    HStack(spacing:15){
                        HStack(spacing:4){
                            
                            Text(currencySymbol)
                                .font(.callout.bold() )
                            
                            TextField("0.0", value: $amount, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                        }
                        
                            .padding(.horizontal,15)
                            .padding(.vertical,12)
                            .background(.background,in:.rect(cornerRadius: 10))
                            .frame(maxWidth: 130)
                           
                        
                        ///custom check box
                        categoryCheckBox()
                    }
                })
                
                //Date picker
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal,15)
                        .padding(.vertical,12)
                        .background(.background,in: .rect(cornerRadius: 10))
                    
                })
               
            }
            .padding(15)
        }
        .navigationTitle("\(editTranscation == nil ? "Add" : "Edit") Transcation")
        .background(.gray.opacity(0.15))
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    save()
                }
            }
        })
        .onAppear{
            if let editTranscation {
                title = editTranscation.title
                remarks = editTranscation.remarks
                dateAdded = editTranscation.dateAdded
                if let category = editTranscation.rawCategory {
                    self.category = category
                }
                
                amount = editTranscation.amount
                if let tint = editTranscation.tint {
                    self.tint = tint
                }
               
            }
        }
    }
    
    ///saving data
    func save(){
        ///saving item to swiftdata
        if editTranscation != nil{
            editTranscation?.title = title
            editTranscation?.remarks = remarks
            editTranscation?.amount = amount
            editTranscation?.dateAdded = dateAdded
            editTranscation?.category = category.rawValue
            //editTranscation?.tint = tint.raw
        }else{
            let tran  = Transaction(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            context.insert(tran)
        }
       
        dismiss()
    }
    
    @ViewBuilder
    func categoryCheckBox() -> some View {
        HStack(spacing:10){
            ForEach(Category.allCases,id: \.rawValue) { category in
                HStack(spacing:5){
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTint)
                        
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(appTint)
                        }
                        
                    }
                    Text(category.rawValue)
                        .font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture(perform: {
                    self.category = category
                })
            }
        }
        .padding(.horizontal,16)
        .padding(.vertical,12)
        .hSpacing(.leading)
        .background(.background,in:.rect(cornerRadius: 8))
    }
    
    @ViewBuilder
    func customSection(_ title:String,_ hint:String, value:Binding<String>)-> some View{
        
        VStack(alignment: .leading,spacing: 10, content: {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            
            TextField(hint,text:value )
                .padding(.horizontal,15)
                .padding(.vertical,12)
                .background(.background,in:.rect(cornerRadius: 10))
        })
    }
    
    ///number fortmater
    var numberFormatter:NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    NavigationStack{
        TransactionView()
    }
}
