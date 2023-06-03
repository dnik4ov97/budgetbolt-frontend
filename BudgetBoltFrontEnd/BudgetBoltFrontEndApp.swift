//
//  BudgetBoltFrontEndApp.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 4/20/23.
//

import SwiftUI

@main
struct BudgetBoltFrontEndApp: App {
    
    private let cardTrans = CardTransactions()
    @State private var year: Years = .twenty23
    @State var month: Months = .May
    
    var body: some Scene {
        WindowGroup {
            TabView {
                SummaryOfEachAccountView(cardTrans: cardTrans)
                    .tabItem {
                        Label("Accounts", systemImage: "creditcard")
                    }
                MonthlyEarningsAndExpensesView(transactions: cardTrans, year: $year, month: $month)
                    .tabItem {
                        Label("Category", systemImage: "banknote")
                    }
                
            }
            .background(.mint)
            .task({
                await cardTrans.upLoad()
            })
        }
    }
}
