//
//  AccountsView.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 5/9/23.
//

import SwiftUI


struct AccountsView: View {
    
//    var accounts: [Accounts.Account]
    @ObservedObject var cardTrans: CardTransactions
    @Binding var currentAccount: String
    @State var index: Int = 0
    var count: Int {
        return cardTrans.accounts.count
    }
    var body: some View {
        GeometryReader {
            let size = $0.size
            let pageWidth: CGFloat = size.width - 25
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(cardTrans.accounts, id: \.account_id){ account in
                            AccountView(last4Digits: account.mask ?? "", officalName: account.name, current: account.balances.current ?? 0.0, available: account.balances.available ?? 0.0, limit: account.balances.limit ?? 0.0, currency: account.balances.iso_currency_code ?? "USD", subtype: account.subtype ?? "", institutionName: account.institutionName)
                                .frame(width: pageWidth)
                        }
                    }
                    .padding(.horizontal, size.width * 0.02)
                    .background {
                        SnapHelper(pageWidth: pageWidth, pageCount: count, index: $index)
                    }
                    .onChange(of: index, perform: {newValue in
                        currentAccount = cardTrans.accounts[newValue].account_id
                    })
                }
            }
        }
    }
}

struct SnapHelper: UIViewRepresentable {
    
    var pageWidth: CGFloat
    var pageCount: Int
    @Binding var index: Int
    func makeCoordinator() -> Cordinator {
        return Cordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = .fast
                scrollView.delegate = context.coordinator
                context.coordinator.pageCount = pageCount
                context.coordinator.pageWidth = pageWidth
            }
        }
    }
    
    class Cordinator: NSObject, UIScrollViewDelegate {
        var parent: SnapHelper
        var pageCount: Int = 0
        var pageWidth: CGFloat = 0
        init(parent: SnapHelper) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            print(scrollView.contentOffset.x)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let targetEnd = scrollView.contentOffset.x + (velocity.x * 60)
            print("targetEnd: \(targetEnd)")
            let targetIndex = (targetEnd / parent.pageWidth).rounded()
            print("targetIndex: \(targetIndex)")
//            let index = min(max(Int(targetIndex), 0), parent.pageCount - 1)
//            print("index: \(index)")
            parent.index = Int(targetIndex)
            
            
            targetContentOffset.pointee.x = targetIndex * parent.pageWidth
        }
    }
}

struct AccountView: View {
    var last4Digits: String
    var officalName: String
    var current: Double
    var available: Double
    var limit: Double
    var currency: String
    var subtype: String
    var institutionName: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("CardColor"))
                VStack(alignment: .leading) {
                    Spacer()
                    Text(officalName)
                        .font(.system(size: 25))
                        .padding(.leading)
                        .foregroundColor(.white)
                    Spacer()
                    
                    balance(of: subtype, current: current, available: available, currency: currency)
                    
                    Spacer()
                    
                    HStack {
                        Text("****  ****  ****  \(last4Digits)")
                            .padding(.leading)
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        Spacer()
                        cardCompanyView(name: institutionName)
                            .offset(CGSize(width: -15, height: 0))
                    }
                    Spacer()
                }
            }
            .frame(width: geometry.size.width * 0.98)
        }
    }
}

@ViewBuilder
func balance(of subtype: String, current: Double, available: Double, currency: String) -> some View {
    if subtype == "credit card" {
        HStack {
            Spacer()
            VStack {
                Text("Balance")
                    .foregroundColor(.gray)
                Text("\(current.formatted(.currency(code: currency)))")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            Spacer()
            VStack {
                Text("Available")
                    .foregroundColor(.gray)
                Text("\(available.formatted(.currency(code: currency)))")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            Spacer()
        }
    } else {
        HStack {
            Spacer()
            VStack {
                Text("Avaliable")
                    .foregroundColor(.gray)
                Text("\(current.formatted(.currency(code: currency)))")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            Spacer()
        }
    }
}

@ViewBuilder
func cardCompanyView(name: String) -> some View {
    if name == "Chase" {
        Image("Chase")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    } else if name == "American Express" {
        Image("AmericanExpress")
            .resizable()
            .scaledToFit()
            .frame(width: 55, height: 55)
    } else if name == "Capital One" {
        Image("CapitalOne")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 40)
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        let cardTrans = CardTransactions()
        AccountsView(cardTrans: cardTrans, currentAccount: .constant("dsf432ndsfo3r23")).frame(height: 200)
    }
}
