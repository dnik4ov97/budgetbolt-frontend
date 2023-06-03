//
//  Accounts.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 4/27/23.
//

import Foundation

struct Accounts {
    private(set) var accounts: [Account]
    
    init() {
//        self.accounts = [Account]()
        self.accounts = [
            Account(
                account_id: "J9J4BmX3E0Fpp9jBbJbLfqmvyygX66T3oYVJKB",
                balances: Balance(current: 2233.38, iso_currency_code: "USD", available: 2233.38),
                mask: "1477",
                name: "Chase Total Checking",
                subtype: "checking",
                type: "depository",
                institutionName: "Chase"
            ),
            Account(
                account_id: "8Kkn5wVE0ZhQQjqKpVp5IpPxzzB6JJhkQdrboX",
                balances: Balance(current: 610.26, iso_currency_code: "USD", available: 1389.74, limit: 2000),
                mask: "3161",
                name: "Chase Freedom Unlimited",
                subtype: "credit card",
                type: "credit",
                institutionName: "Chase"
            )
        ]
    }
    
    mutating func upLoad () async -> Void {
        let body = ["address": "david.niki4ov97@gmail.com"]
                let bodyData = try? JSONSerialization.data(withJSONObject: body)
                let url = URL(string: "http://127.0.0.1:8080/get_account_balances")!
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = bodyData
        
                do {
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let decodedResponse = try? JSONDecoder().decode([Account].self, from: data)
                    self.accounts = accounts + decodedResponse!
//                    self.accounts = accounts + [Account(official_name: "Discover it chrome Card", mask: "5589", account_id: "k4NY3zyYrATm5OOqOg6es", name: "Discover it chrome Card", subtype: "credit card", balances: Balance(current: 1439.91, iso_currency_code: "USD", available: 60, limit: 1500))]
                } catch {
                    print(error)
                }
    }
    
    struct Account: Codable {
        var account_id: String
        var balances: Balance
        var mask: String?
        var name: String
        var subtype: String?
        var type: String
        var institutionName: String
    }
    
    struct Balance: Codable {
        var current:  Double?
        var iso_currency_code: String?
        var available: Double?
        var limit: Double?
    }
}
