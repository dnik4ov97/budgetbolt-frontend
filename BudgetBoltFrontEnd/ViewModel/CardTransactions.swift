//
//  CardTransactions.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 4/26/23.
//

import SwiftUI

class CardTransactions: ObservableObject {
    
    @Published private var usersTransactions = Transactions()
    
    @Published private var usersAccounts = Accounts()
    
    var transactions: [Transactions.Transaction] {
        usersTransactions.transactions
    }
    
    var accounts: [Accounts.Account] {
        usersAccounts.accounts
    }
    
    var categories: [Transactions.Category] {
        usersTransactions.categories
    }
    
    var total: Double {
        var sum = 0.0
        for transaction in transactions {
            sum += transaction.amount
        }
        return sum
    }
    
    // MARK: - Intent(s)
    
    func upLoad() async {
        Task { @MainActor in
            await usersAccounts.upLoad()
            await usersTransactions.upLoad()
//            await usersTransactions.getAllCategories()
        }
    }
    
    func selectedMonthTransactions (year: String, month: Months, currentAccount: String) -> [Transactions.Transaction] {
        return transactions.filter({
            let current = "\(year)-\(covertingMonthsToString(month: month))-"
            let whichDate = $0.authorized_date != nil ? $0.authorized_date! : $0.date
            return whichDate[whichDate.startIndex...whichDate.lastIndex(of: "-")!] == current && $0.account_id == currentAccount
        }).sorted(by: {($0.authorized_date != nil ? $0.authorized_date! : $0.date) > ($1.authorized_date != nil ? $1.authorized_date! : $1.date)})
    }
    
    func selectedMonthTransactions2 (year: String, month: Months) -> [Transactions.Transaction] {
        return transactions.filter({
            let current = "\(year)-\(covertingMonthsToString(month: month))-"
            let whichDate = $0.authorized_date != nil ? $0.authorized_date! : $0.date
            return whichDate[whichDate.startIndex...whichDate.lastIndex(of: "-")!] == current
        }).sorted(by: {($0.authorized_date != nil ? $0.authorized_date! : $0.date) > ($1.authorized_date != nil ? $1.authorized_date! : $1.date)})
    }
    
    func totalVal (trans: CardTransactions, year: Years, month: Months, currentAccount: String) -> (total: Double, spent: Double, payed: Double) {
        let filterTrans = trans.transactions.filter({
            let current = "\(year.rawValue)-\(covertingMonthsToString(month: month))-"
            let whichDate = $0.authorized_date != nil ? $0.authorized_date! : $0.date
            return whichDate[whichDate.startIndex...whichDate.lastIndex(of: "-")!] == current && $0.account_id == currentAccount
        })
        var total = 0.0
        var spent = 0.0
        var payed = 0.0
        for transaction in filterTrans {
            total += transaction.amount
            if transaction.amount < 0.0 {
                payed += transaction.amount
            } else {
                spent += transaction.amount
            }
        }

        return (total: total, spent: spent, payed: payed)
    }
    
    func categoryTotal (trans: CardTransactions, year: Years, month: Months) -> [(category: String, total: Double, items: [Transactions.Transaction])] {
        let categoryIDS = trans.categories
        var outputArray = [(category: String, total: Double, items: [Transactions.Transaction])]()
        for categoryId in categoryIDS {
            let filterTrans = trans.transactions.filter({
                let current = "\(year.rawValue)-\(covertingMonthsToString(month: month))-"
                let whichDate = $0.authorized_date ?? $0.date
                return whichDate[whichDate.startIndex...whichDate.lastIndex(of: "-")!] == current && $0.category_id == categoryId.category_id
            })
            if !filterTrans.isEmpty {
                var sum = 0.0
                for transaction in filterTrans {
                    sum += transaction.amount
                }
                outputArray.append((categoryId.hierarchy.last ?? "", sum, filterTrans))
            }
        }
        
        return outputArray
    }
    
    func totalSpending (list: [(category: String, total: Double, items: [Transactions.Transaction])]) -> Double {
        var total = 0.0
        for item in list {
            if item.category != "Credit Card" && item.category != "Credit" && item.category != "Payroll"{
                total += item.total
            }
        }
        return total
    }
    
    func totalIncome(list: [(category: String, total: Double, items: [Transactions.Transaction])]) -> Double {
        var total = 0.0
        for item in list {
            if item.category == "Credit" || item.category == "Payroll"{
                total += item.total
            }
        }
        return (-1 * total)
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
    
    
//    func percentageUsage (spent: Double, avaliable: Double) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .percent
//        formatter.maximumFractionDigits = 2
//        let newAvaliable = avaliable < 0.0 ? -1 * avaliable : avaliable
//        if spent > newAvaliable {
//            let number = NSNumber(value: newAvaliable / spent)
//            return formatter.string(from: (number))!
//        } else {
//            let number = NSNumber(value: spent / newAvaliable)
//            return formatter.string(from: (number))!
//        }
//    }
    
    func createLinkToken() async -> String {
                let url = URL(string: "http://127.0.0.1:8080/create_link_token")!
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
        
                do {
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let decodedResponse = try? JSONDecoder().decode(LinkToken.self, from: data)
                    print(decodedResponse ?? "nil value")
//                    return decodedResponse!
                    return decodedResponse!.link_token
                } catch {
                    print(error)
                    return "error"
                }
    }
    
    func publicTokenExchange(email: String, publicKey: String,  institutionId: String, institutionName: String) async -> Void {
        let body = ["email": email, "publicKey": publicKey, "institutionId": institutionId, "institutionName": institutionName]
        let bodyData = try? JSONSerialization.data(withJSONObject: body)
        let url = URL(string: "http://127.0.0.1:8080/item_public_token_exchange")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = bodyData

        do {
            let (_, _) = try await URLSession.shared.data(for: request)
//            let decodedResponse = try? JSONDecoder().decode(String.self, from: data)
        } catch {
            print(error)
        }
    }
    
    func covertingMonthsToString (month: Months) -> String {
        switch month {
        case .Jan: return "01"
        case .Feb: return "02"
        case .Mar: return "03"
        case .Apr: return "04"
        case .May: return "05"
        case .Jun: return "06"
        case .Jul: return "07"
        case .Aug: return "08"
        case .Sep: return "09"
        case .Oct: return "10"
        case .Nov: return "11"
        case .Dec: return "12"
        }
    }
    
}

struct PublicExchange: Codable {
    var access_token: String
}

struct LinkToken: Codable {
    var link_token: String
}

//enum CategoryNames: String, CaseIterable, Identifiable {
//    case Groceries = "19047000"
//    case Payment = "16001000"
//    case Restaurants = "13005000"
//    case Shops = "19019000"
//    var id: Self { self }
//}
