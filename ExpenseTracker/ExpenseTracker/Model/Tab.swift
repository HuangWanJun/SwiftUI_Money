//
//  Tab.swift
//  ExpenseTracker
//
//  Created by IOS Developer on 13/12/2023.
//

import SwiftUI

enum Tab: String {
    case recents = "Recents"
    case search = "Filter"
    case charts = "Charts"
    case Settings = "Settings"
    
    @ViewBuilder
    var tabContent:some View {
        switch self {
        case .recents:
            Image (systemName:"calendar")
            Text (self.rawValue)
        case .search:
            Image (systemName:"magnifyingglass")
            Text (self.rawValue)
            
        case .charts:
            Image (systemName:"chart.bar.xaxis")
            Text (self.rawValue)
        case .Settings:
            Image (systemName:"gearshape")
            Text (self.rawValue)
        }
    }
}
    
