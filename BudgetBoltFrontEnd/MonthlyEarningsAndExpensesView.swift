//
//  MonthlyEarningsAndExpensesView.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 5/11/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct MonthlyEarningsAndExpensesView: View {
    @ObservedObject var transactions: CardTransactions
    @Binding var year: Years
    @Binding var month: Months
    
    var body: some View {
        VStack {
            Text("Total Spending: \(transactions.totalSpending(list: transactions.categoryTotal(trans: transactions, year: year, month: month)).formatted(.currency(code: "USD")))")
            
            Text("Total Income: \(transactions.totalIncome(list: transactions.categoryTotal(trans: transactions, year: year, month: month)).formatted(.currency(code: "USD")))")
            
            YearMonthPicker(month: $month, year: $year)
            
            NavigationView {
                VStack {
                    List(transactions.categoryTotal(trans: transactions, year: year, month: month), id: \.category) { cat in
                        DisclosureGroup{
                            ForEach(transactions.sumUpNames(transactions: cat.items), id: \.transaction_id) {transaction in
                                categoryRow(category: transaction)
                            }
                        } label: {
                            HStack{
                                Text(cat.category)
                                Spacer()
                                Text("\(cat.total.formatted(.currency(code: "USD")))")
                            }
                        }
                    }
                }
                .navigationTitle("Expenses")
            }
            
        }
    }
}

struct categoryRow: View {
    
    let category: Transactions.Transaction
    var body: some View {
        GeometryReader { geomtry in
            HStack {
                Text(category.merchant_name ?? category.name )
                    .font(.system(size: 15))
                    .frame(width: geomtry.size.width * 0.5, height: geomtry.size.height)
                Spacer()
                Text("\(category.amount.formatted(.currency(code: category.iso_currency_code)))")
                    .foregroundColor(category.amount < 0.0 ? Color.red : Color.black)
                    .frame(width: geomtry.size.width * 0.25, height: geomtry.size.height)
            }
        }
    }
}


struct MonthlyCategories_Previews: PreviewProvider {
    static var previews: some View {
        let cardTrans = CardTransactions()
        MonthlyEarningsAndExpensesView(transactions: cardTrans, year: .constant(Years.twenty23), month: .constant(Months.May))
    }
}

//extension Transactions.Transaction: Transferable {
//    static var transferRepresentation: some TransferRepresentation {
//        CodableRepresentation(contentType: .transaction)
//    }
//}
//
//extension UTType {
//    static var transaction = UTType(exportedAs: "com.budgetbolt.transaction")
//}
