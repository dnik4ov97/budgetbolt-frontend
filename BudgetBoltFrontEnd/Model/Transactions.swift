//
//  Transactions.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 4/20/23.
//

import Foundation

struct Transactions {
    private(set) var transactions: [Transaction]
    
//    private(set) var monthTransactions: [Transaction]
    
    private(set) var categories: [Category]
    
    init() {
        self.transactions = [
            Transaction(account_id: "J9J4BmX3E0Fpp9jBbJbLfqmvyygX66T3oYVJKB", amount: 244.21000000000001, iso_currency_code: "USD", category: ["Interest","Interest Charged"], category_id: "15002000", date: "2023-05-23", name: "INTEREST CHARGE:PURCHASES", pending: false, transaction_id: "Don3ma0n0OHEYOLnwNgZu1q3MKYrzvCYokZg6"),
            Transaction(account_id: "J9J4BmX3E0Fpp9jBbJbLfqmvyygX66T3oYVJKB", amount: 1.99, iso_currency_code: "USD", category: ["Service","Insurance"], category_id: "18030000", date: "2023-05-23", name: "Peacock 7CFFD Premium", pending: false, transaction_id: "1EZjgdrZr7swPKajDdEoTMnoVEbB16ib1kmA6"),
            Transaction(account_id: "J9J4BmX3E0Fpp9jBbJbLfqmvyygX66T3oYVJKB", amount: 36.219999999999999, iso_currency_code: "USD", category: ["Shops","Supermarkets and Groceries"], category_id: "19047000", date: "2023-05-23", name: "Whole Foods", pending: true, transaction_id: "zkagj4nxp4Hmp36w8KemTb4pypZ5yPCaZv6vM"),
            Transaction(account_id: "J9J4BmX3E0Fpp9jBbJbLfqmvyygX66T3oYVJKB", amount: 71.290000000000006, iso_currency_code: "USD", category: ["Travel","Gas Stations"], category_id: "22009000", date: "2023-05-23", name: "Costco Gas", pending: false, transaction_id: "oydBe4PbPJiMxDbKAYEEU1aVKobKP7UQjRMQe"),
            Transaction(account_id: "J9J4BmX3E0Fpp9jBbJbLfqmvyygX66T3oYVJKB", amount: 600, iso_currency_code: "USD", category: ["Payment", "Credit Card"], category_id: "16001000", date: "2023-05-23", name: "AMERICAN EXPRESS ACH PMT M0552 WEB ID: 2005032111", pending: false, transaction_id: "bmY1e8ZAZnSzRxned9OOfRgB4v34ZoTr7kLrB")
        ]
//        self.monthTransactions = [Transaction]()
        self.categories = [Category]()
    }
    
    mutating func upLoad () async -> Void {
        let body = ["address": "david.niki4ov97@gmail.com"]
                let bodyData = try? JSONSerialization.data(withJSONObject: body)
                let url = URL(string: "http://127.0.0.1:8080/get_account_transaction")!
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = bodyData
        
                do {
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let decodedResponse = try? JSONDecoder().decode([Transaction].self, from: data)
                    print(decodedResponse!)
                    self.transactions = transactions + decodedResponse!
                    print(transactions)
                } catch {
                    print(error)
                }
    }
    
//    mutating func getAllCategories() async -> Void {
//        let url = URL(string: "http://127.0.0.1:8080/get_categories")!
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//
//        do {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            let decodedResponse = try? JSONDecoder().decode([Category].self, from: data)
//            categories = decodedResponse!
//        } catch {
//            print(error)
//        }
//    }
    
    struct Transaction: Codable{
        var account_id: String
        var amount: Double
        var iso_currency_code: String
        var unofficial_currency_code: String?
        var category: [String]
        var category_id: String
        var date: String
        var name: String
        var authorized_date: String?
        var merchant_name: String?
        var pending: Bool
        var transaction_id: String
    }
    
    struct Category: Codable {
        var category_id: String
        var group: String
        var hierarchy: [String]
    }
}
