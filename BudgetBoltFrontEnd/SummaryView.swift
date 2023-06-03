//
//  SummaryView.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 5/9/23.
//

import SwiftUI
import Charts

struct SummaryView: View {
        var cardTrans: CardTransactions
        @Binding var year: Years
        @Binding var month: Months
        @Binding var currentAccount: String
    
    var body: some View {
        HStack {
            Spacer()
            Summary(cardTrans: cardTrans, year: $year, month: $month, currentAccount: $currentAccount)
            Spacer()
        }
        .frame(height: 70)
    }
}

struct Summary: View {
    var cardTrans: CardTransactions
    @Binding var year: Years
    @Binding var month: Months
    @Binding var currentAccount: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("Summary"))
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        Text("\(cardTrans.totalVal(trans: cardTrans, year: year, month: month, currentAccount: currentAccount).spent.formatted(.currency(code: "USD")))")
                            .font(.system(size: 20))
                        Text("Spent")
                            .font(.system(size: 15))
                    }
                    
                    Spacer()
                    VStack {
                        Text("\((cardTrans.totalVal(trans: cardTrans, year: year, month: month, currentAccount: currentAccount).payed * -1).formatted(.currency(code: "USD")))")
                            .font(.system(size: 20))
                        PayedOrMade(currentAccount, cardTrans.accounts)
                            .font(.system(size: 15))
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
//                                                    .frame(width: geo.size.width, height: geo.size.height)
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.mint)
//                                                    .frame(width: geo.size.width * 0.755, height: geo.size.height)
                            .frame(width: 100)
                        Text("75.5%")
                    }
                
                Spacer()
            }
            .padding(.horizontal, 3.0)
        }
    }
}

@ViewBuilder
func PayedOrMade(_ currentAccount: String, _ accounts: [Accounts.Account]) -> some View {
    let accountFound = accounts.first(where: {$0.account_id == currentAccount})
    if accountFound == nil {
        Text("Payed")
    }
    else if accountFound!.type == "depository" {
        Text("Made")
    } else {
       Text("Payed")
    }
}

//struct Percentage: View {
//    var cardTrans: CardTransactions
//    @Binding var year: Years
//    @Binding var month: Months
//    @Binding var currentAccount: String
//    
//    @State private var isShowingPopover = false
//    
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundColor(Color("Summary"))
//            
//            HStack {
//                Image(systemName: "arrow.up.circle")
//                VStack {
//                    Text("\(cardTrans.percentageUsage(spent: cardTrans.totalVal(trans: cardTrans, year: year, month: month, currentAccount: currentAccount).spent, avaliable: cardTrans.totalVal(trans: cardTrans, year: year, month: month, currentAccount: currentAccount).payed))")
//                    Text("usage only")
//                }
//            }
//            .font(.system(size: 20))
//        }
//    }
//}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let cardTrans = CardTransactions()
        SummaryView(cardTrans: cardTrans, year: .constant(.twenty23), month: .constant(.Jan), currentAccount: .constant("dsf432ndsfo3r23"))
            .frame(height: 150)
    }
}
