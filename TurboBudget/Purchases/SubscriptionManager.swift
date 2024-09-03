//
//  SubscriptionManager.swift
//  CashFlow
//
//  Created by KaayZenn on 03/09/2023.
//

import StoreKit

typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

class SubscriptionManager: NSObject, ObservableObject {
    static let shared = SubscriptionManager()
    
    @Published var allRecipes = [Purchase]()
    
    @Published var isCashFlowPro: Bool = false
    
    private let allProductIdentifiers = Set([
        "cashflow_199_1m_3d0"
    ])
    
    private var completedPurchases = [String]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                for index in self.allRecipes.indices {
                    self.allRecipes[index].isLocked = !self.completedPurchases.contains(self.allRecipes[index].id)
                }
            }
        }
    }
    
    private var productsRequest: SKProductsRequest?
    private var fetchedProducts = [SKProduct]()
    private var fetchedCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    private let userDefaultsKey = "completedPurchases2"
    
    override init() {
        super.init()
        
        startObservingPaymentQueue()
        
        fetchProducts { products in
            self.allRecipes = products.map { Purchase(product: $0) }
        }
    }
    
    func loadStoredPurchases() {
        if let storedPurchases = UserDefaults.standard.object(forKey: userDefaultsKey) as? [String] {
            self.completedPurchases = storedPurchases
        }
    }
    
    private func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    private func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
        guard self.productsRequest == nil else { return }
        fetchedCompletionHandler = completion
        
        productsRequest = SKProductsRequest(productIdentifiers: allProductIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    private func buy(_ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        purchaseCompletionHandler = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension SubscriptionManager {
    
    func product(for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: { $0.productIdentifier == identifier })
    }
    
    func purchaseProduct(_ product: SKProduct) {
        startObservingPaymentQueue()
        buy(product) { _ in
            
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension SubscriptionManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var shouldFinishTransaction = false
            switch transaction.transactionState {
            case .purchased, .restored:
                completedPurchases.append(transaction.payment.productIdentifier)
                shouldFinishTransaction = true
                isCashFlowPro = true
            case .failed:
                shouldFinishTransaction = true
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
            
            if shouldFinishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
            
        }
        
        if !completedPurchases.isEmpty {
            UserDefaults.standard.setValue(completedPurchases, forKey: userDefaultsKey)
        }
        
    }
}

extension SubscriptionManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else {
            print("Could not load the products !")
            if !invalidProducts.isEmpty {
                print("Invalid products found : \(invalidProducts)")
            }
            productsRequest = nil
            return
        }
        
        //Cache the fetched products
        fetchedProducts = loadedProducts
        
        //Notify anyone waiting on the product load
        DispatchQueue.main.async {
            self.fetchedCompletionHandler?(loadedProducts)
            
            self.fetchedCompletionHandler = nil
            self.productsRequest = nil
        }
    }
}

extension SubscriptionManager {
    func getSubscriptionStatus(product: Product) async {
            guard let subscription = product.subscription else {
                // Not a subscription
                return
            }
        
            do {
                
                let statuses = try await subscription.status

                for status in statuses {
                    let info = try status.renewalInfo.payloadValue
                    
                    switch status.state {
                    case .subscribed:
                        if info.willAutoRenew {
                            debugPrint("getSubscriptionStatus user subscription is active.")
                            return
                        } else {
                            debugPrint("getSubscriptionStatus user subscription is expiring.")
                            return
                        }
                    case .inBillingRetryPeriod:
                        debugPrint("getSubscriptionStatus user subscription is in billing retry period.")
                        return
                    case .inGracePeriod:
                        debugPrint("getSubscriptionStatus user subscription is in grace period.")
                        return
                    case .expired:
                        debugPrint("getSubscriptionStatus user subscription is expired.")
                        return
                    case .revoked:
                        debugPrint("getSubscriptionStatus user subscription was revoked.")
                        return
                    default:
                        fatalError("getSubscriptionStatus WARNING STATE NOT CONSIDERED.")
                    }
                }
            } catch {
                // do nothing
            }
            return
        }
}
