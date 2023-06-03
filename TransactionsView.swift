//
//  TransactionsView.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 5/9/23.
//

import SwiftUI

struct TransactionsView: View {
    var cardTrans: CardTransactions
    @Binding var year: Years
    @Binding var month: Months
    @Binding var currentAccount: String
    
    var body: some View {
        NavigationStack {
            List(cardTrans.selectedMonthTransactions(year: year.rawValue, month: month, currentAccount: currentAccount), id: \.transaction_id) { transaction in
                GeometryReader { geomtry in
                    HStack(alignment: .center) {
                        Text(returnDate(transaction.authorized_date != nil ? transaction.authorized_date! : transaction.date), format: .dateTime.day().month())
                            .frame(width: geomtry.size.width * 0.2, height: geomtry.size.height)
                        Spacer()
                        Text(transaction.name)
                            .font(.system(size: 15))
                            .frame(width: geomtry.size.width * 0.5, height: geomtry.size.height)
                        Spacer()
                        Text("\(transaction.amount.formatted(.currency(code: transaction.iso_currency_code)))")
                            .foregroundColor(transaction.amount < 0.0 ? Color.red : Color.black)
                            .frame(width: geomtry.size.width * 0.3, height: geomtry.size.height)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Transactions")
        }
    }
}

func returnDate(_ date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: date)!
}


struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        let cardTrans = CardTransactions()
        TransactionsView(cardTrans: cardTrans, year: .constant(.twenty23), month: .constant(.Feb), currentAccount: .constant("dsf432ndsfo3r23"))
    }
}
