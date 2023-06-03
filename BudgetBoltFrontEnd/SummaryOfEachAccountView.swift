//
//  SummaryOfEachAccountView.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 4/20/23.
//

import SwiftUI
import Charts

struct SummaryOfEachAccountView: View {
    
    @ObservedObject var cardTrans: CardTransactions
    
    @State private var year: Years = .twenty23
    @State var month: Months = .May
    @State var currentAccount: String = "J9J4BmX3E0Fpp9jBbJbLfqmvyygX66T3oYVJKB"
    
    var body: some View {
//        GeometryReader { geo in
            VStack {
                //            Group {
                //                Spacer()
                //
                //                OpenButton(cardTrans: cardTrans)
                //
                //                Spacer()
                //            }
                
                AccountsView(cardTrans: cardTrans, currentAccount: $currentAccount)
                    .frame(height: 200)
//                    .frame(height: geo.size.height * 0.25)
                
                Spacer()
                
                YearMonthPicker(month: $month, year: $year)
//                    .frame(height: geo.size.height * 0.05)
                
                Spacer()
                
                SummaryView(cardTrans: cardTrans, year: $year, month: $month, currentAccount: $currentAccount)
                    .frame(height: 100)
//                    .frame(height: geo.size.height * 0.11)
                
                Spacer()
                
                TransactionsView(cardTrans: cardTrans, year: $year, month: $month, currentAccount: $currentAccount)
                
                Spacer()
            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let cardTrans = CardTransactions()
        SummaryOfEachAccountView(cardTrans: cardTrans)
            .background(Color("BackGround"))
    }
}

