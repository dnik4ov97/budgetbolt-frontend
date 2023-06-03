//
//  OpenButton.swift
//  BudgetBoltFrontEnd
//
//  Created by David Nikiforov on 5/3/23.
//
import LinkKit
import SwiftUI

struct OpenButton: View {
    @ObservedObject var cardTrans: CardTransactions
    
//    static let color = Color(
//        red: 0,
//        green: 191 / 256,
//        blue: 250 / 256,
//        opacity: 1
//    )

    @State private var showLink = false

//    #warning("Replace <#GENERATED_LINK_TOKEN#> below with your link_token")
    @State private var linkToken = "link-development-e5a51cb7-e7e6-4dcf-b869-009c8b988331"

    var body: some View {
        Button(action: {
            // create linkToken
            Task {
                self.linkToken = await cardTrans.createLinkToken()
//                if linkToken != ""{
                print("LinkToke Task: \(linkToken)")
                    self.showLink = true
//                } else {
//                    print("error here!")
//                }
            }
        }) {
            Text("+")
                .font(.system(size: 17, weight: .medium))
        }
        .padding()
        .foregroundColor(.red)
        .cornerRadius(4)
        .sheet(isPresented: self.$showLink,
            onDismiss: {
                self.showLink = false
            }, content: {
                PlaidLinkFlow(
                    linkTokenConfiguration: createLinkTokenConfiguration(),
                    showLink: $showLink
                )
            }
        )
    }

    private func createLinkTokenConfiguration() -> LinkTokenConfiguration {
        print("LinkToken  in func: \(linkToken)")
        var configuration = LinkTokenConfiguration(
            token: linkToken,
            onSuccess: { success in
                // public exchange
                Task {
                    await cardTrans.publicTokenExchange(email: "david.niki4ov97@gmail.com", publicKey: success.publicToken, institutionId: success.metadata.institution.id, institutionName: success.metadata.institution.name)
                }
                print("public-token: \(success.publicToken) metadata: \(success.metadata)")
                showLink = false
            }
        )

        configuration.onEvent = { event in
            print("Link Event: \(event)")
        }

        configuration.onExit = { exit in
            if let error = exit.error {
                print("exit with \(error)\n\(exit.metadata)")
            } else {
                print("exit with \(exit.metadata)")
            }
            
            showLink = false
        }

        return configuration
    }
}


private struct PlaidLinkFlow: View {
    @Binding var showLink: Bool
    private let linkTokenConfiguration: LinkTokenConfiguration

    init(linkTokenConfiguration: LinkTokenConfiguration, showLink: Binding<Bool>) {
        self.linkTokenConfiguration = linkTokenConfiguration
        self._showLink = showLink
    }

    var body: some View {
        let linkController = LinkController(
            configuration: .linkToken(linkTokenConfiguration)
        ) { createError in
            print("Link Creation Error: \(createError)")
            self.showLink = false
        }

        return linkController
            .onOpenURL { url in
                linkController.linkHandler?.resumeAfterTermination(from: url)
            }
    }
}



struct OpenButton_Previews: PreviewProvider {
    static var previews: some View {
        let cardTrans = CardTransactions()
        OpenButton(cardTrans: cardTrans)
    }
}


// The Controller that bridges from SwiftUI to UIKit.
@available(iOS 13, *)
struct LinkController {
    // A wrapper enum for either a public key or link token based configuration
    enum LinkConfigurationType {
        case publicKey(LinkPublicKeyConfiguration)
        case linkToken(LinkTokenConfiguration)
    }

    // The `configuration` to start Link with
    let configuration: LinkConfigurationType

    // The closure to invoke if there is an error creating the Handler
    let onCreateError: ((Plaid.CreateError) -> Void)?

    // A reference to the `Handler`, if one has been created.
    @State private(set) var linkHandler: Handler?

    init(
        configuration: LinkConfigurationType,
        onCreateError: ((Plaid.CreateError) -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onCreateError = onCreateError
    }
}

// MARK: LinkController SwiftUI <-> UIKit bridge
@available(iOS 13, *)
extension LinkController: UIViewControllerRepresentable {

    final class Coordinator: NSObject {
        private(set) var parent: LinkController
        private(set) var handler: Handler?

        fileprivate init(_ parent: LinkController) {
            self.parent = parent
        }

        fileprivate func createHandler() -> Result<Handler, Plaid.CreateError> {
            switch parent.configuration {
            case .publicKey(let configuration):
                return Plaid.create(configuration)
            case .linkToken(let configuration):
                return Plaid.create(configuration)
            }
        }

        fileprivate func present(_ handler: Handler, in viewController: UIViewController) -> Void {
            guard self.handler == nil else {
                // Already presented a handler!
                return
            }
            self.handler = handler

            handler.open(presentUsing: .custom({ linkViewController in
                viewController.addChild(linkViewController)
                viewController.view.addSubview(linkViewController.view)
                linkViewController.view.translatesAutoresizingMaskIntoConstraints = false
                linkViewController.view.frame = viewController.view.bounds
                NSLayoutConstraint.activate([
                    linkViewController.view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
                    linkViewController.view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
                    linkViewController.view.widthAnchor.constraint(equalTo: viewController.view.widthAnchor),
                    linkViewController.view.heightAnchor.constraint(equalTo: viewController.view.heightAnchor),
                ])
                linkViewController.didMove(toParent: viewController)
            }))
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()

        let handlerResult = context.coordinator.createHandler()
        switch handlerResult {
        case .success(let handler):
            context.coordinator.present(handler, in: viewController)
            linkHandler = handler
        case .failure(let createError):
            onCreateError?(createError)
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Empty implementation
    }
}

