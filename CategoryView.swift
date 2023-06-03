//
//  CategoryView.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 5/2/23.
//

import SwiftUI

struct CategoryView: View {
    @ObservedObject var cardTrans: CardTransactions
    
    @State private var year: Years = .twenty23
    @State var month: Months = .Jan
    
    var body: some View {
        VStack {
            YearMonthPicker(month: $month, year: $year).frame(height: 50).padding()
            
            List(category(trans: cardTrans, year: year, month: month), id: \.cat) { cate in
                Text("\(cate.cat):    \(cate.amount.formatted(.currency(code: "USD")))")
            }
        }
        .task {
            await cardTrans.upLoad()
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let cardTrans = CardTransactions()
        CategoryView(cardTrans: cardTrans)
    }
}



func category (trans: CardTransactions, year: Years, month: Months) -> [(cat: String, amount: Double)] {
    let filterTrans = trans.transactions.filter({
        let current = "\(year.rawValue)-\(month.rawValue)-"
        return $0.date[$0.date.startIndex...$0.date.lastIndex(of: "-")!] == current
    })
    
    let groceryCategory = ["Trader Joe's", "Whole Foods", "NUGGET MARKETS", "Safeway", "RALEYS", "Sprouts Farmers Market", "BEL AIR"]
    var list = [(cat: String, amount: Double)]()
    for groceryStore in groceryCategory {
        var sum = 0.0
        for trans in filterTrans {
            if trans.name == groceryStore {
                sum += trans.amount
            }
        }
        list.append((groceryStore, sum))
    }
    var total = 0.0
    for item in list {
        total += item.amount
    }
    list.append(("Total", total))
    return list
}
