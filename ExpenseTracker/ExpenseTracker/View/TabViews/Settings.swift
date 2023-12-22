//
//  Settings.swift
//  ExpenseTracker
//
//  Created by IOS Developer on 14/12/2023.
//

import SwiftUI

struct Settings: View {
    
    @AppStorage("userName") private var userName:String = "Tom"
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled:Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground:Bool = false
    var body: some View {
        NavigationStack{
            List{
                Section("userName"){
                    TextField("Tom",text:$userName)
                }
                
                Section("App Lock"){
                    Toggle("Enable App Lock",isOn:$isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle("loc kWhen App Goes Background",isOn: $lockWhenAppGoesBackground)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
