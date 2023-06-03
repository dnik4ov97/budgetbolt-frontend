//
//  TestView.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 5/13/23.
//

import SwiftUI

struct TestView: View {
    
    @State var transactions = [
        Transactions.Transaction(account_id: "dsf432ndsfo3r23", amount: 15.220000000000001, iso_currency_code: "USD", category: ["Shops", "Supermarkets and Groceries"], category_id: "19047000", date: "2023-05-10", name: "Trader Joe's", pending: true, transaction_id: "dvLo4EkMVEc9JDVRQEX7Hz47Dd1YB4sk3kELv"),
        Transactions.Transaction(account_id: "dsf432ndsfo3r23", amount: 13.34, iso_currency_code: "USD", category: ["Shops", "Supermarkets and Groceries"], category_id: "19047000", date: "2023-05-10", name: "Whole Foods", pending: true, transaction_id: "w3R590XrO0t7mnQOaBYqFaM7NvZ4pMUO6O9gp"),
        Transactions.Transaction(account_id: "dsf432ndsfo3r23", amount: -400, iso_currency_code: "USD", category: ["Payment", "Credit Card"], category_id: "16001000", date: "2023-05-10", name: "MOBILE PAYMENT - THANK YOU", pending: true, transaction_id: "Lvqnd3ABa3cvgE45LjbyIdadQ0YBZLUjyXMmBw"),
        Transactions.Transaction(account_id: "dsf432ndsfo3r23", amount: -30, iso_currency_code: "USD", category: ["Payment", "Credit Card"], category_id: "16001000", date: "2023-05-10", name: "ONLINE PAYMENT DEERFIELD IL payment", pending: true, transaction_id: "L6byzDYazvtAoZpbOayYCVoDr3o4mKfjMJLenb"),
        Transactions.Transaction(account_id: "dsf432ndsfo3r23", amount: 24.440000000000001, iso_currency_code: "USD", category: ["Food and Drink", "Restaurants"], category_id: "13005000", date: "2023-05-08", name: "Whole Foods", pending: true, transaction_id: "3onzvJYr8JHDdAor8we4SAwY1bze9Rs0dxLXe"),
    ]
    @State var categories = ["Food", "Bills", "Rent"]
    @State var sports = ["Hockey", "Soccer", "Tennis"]
    
    var body: some View {
        NavigationView {
            VStack {
                List(transactions, id: \.transaction_id, rowContent: {trans in
                    HStack {
                        Text("\(trans.name)")
                        Spacer()
                        Text("\(trans.amount.formatted(.currency(code: "USD")))")
                    }
                })
                
                List(sumUpNames(transactions: transactions), id: \.transaction_id, rowContent: {trans in
                    HStack {
                        Text("\(trans.name)")
                        Spacer()
                        Text("\(trans.amount.formatted(.currency(code: "USD")))")
                    }
                })

//                List(content: {
//                    DisclosureGroup("Categories", content: {
//                        ForEach(categories, id: \.self) { cat in
//                            Text(cat)
//                                .draggable(cat)
//                        }
//                    })
//                    .dropDestination(for: String.self, action: {receivedItem, location in
//                        print("\(receivedItem)")
//                        print("\(location)")
//                        categories.append(receivedItem.first ?? " ")
//                        sports.removeAll(where: {$0 == receivedItem.first!})
//                        return true
//                    })
//                    .border(.red)
//                })
//
//                List(content: {
//                    DisclosureGroup("Sports", content: {
//                        ForEach(sports, id: \.self) { sport in
//                            Text(sport)
//                                .draggable(sport)
//                        }
//                    })
//                    .dropDestination(for: String.self) {receivedItem, location in
//                        print("\(receivedItem)")
//                        print("\(location)")
//                        sports.append(receivedItem.first ?? " ")
//                        categories.removeAll(where: {$0 == receivedItem.first!})
//                        return true
//                    }
//                    .border(.yellow)
//                })
            }
        }
    }
    
    func sumUpNames (transactions: [Transactions.Transaction]) -> [Transactions.Transaction] {
        var newTrans = [Transactions.Transaction]()
        for trans in transactions {
            if newTrans.contains(where: {$0.name == trans.name}) {
                var current = newTrans.first(where: {$0.name == trans.name})
                let newSum = current!.amount + trans.amount
                current!.amount = newSum
                newTrans.removeAll(where: {$0.name == trans.name})
                newTrans.append(current!)
            } else {
                newTrans.append(trans)
            }
        }
        return newTrans
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}


struct TestCategory: Codable {
    var category: String
}

//extension TestCategory: Transferable {
//    static var transferRepresentation: some TransferRepresentation {
//        CodableRepresentation(contentType: .)
//    }
//}
