//
//  NewSubscriptionManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/09/2024.
//

import Foundation
import StoreKit

@MainActor
class PurchasesManager: NSObject, ObservableObject {
    let productIDs: [String] = ["cashflow_199_1m_3d0", "com.Sementa.CashFlow.lifetime"]
    var purchasedProductIDs: Set<String> = []
    
    @Published var products: [Product] = []
    
    @Published var isCashFlowPro: Bool = false
    private var updates: Task<Void, Never>? = nil
    
    var subscription: Product? {
        return self.products.first
    }
    
    var lifetime: Product? {
        return self.products.last
    }
    
    // init
    override init() {
        super.init()
        self.updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }
    
    deinit { updates?.cancel() }
}

// MARK: - C.R.U.D
extension PurchasesManager {
    func loadProducts() async {
        do {
            self.products = try await Product.products(for: productIDs)
                .sorted(by: { $0.price < $1.price })
        } catch {
            print("Failed to fetch products!")
        }
    }
    
    func buyProduct(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            case let .success(.verified(transaction)):
                // Successful purhcase
                await transaction.finish()
                await self.updatePurchasedProducts()
            case let .success(.unverified(_, error)):
                // Successful purchase but transaction/receipt can't be verified
                // Could be a jailbroken phone
                print("Unverified purchase. Might be jailbroken. Error: \(error)")
                break
            case .pending:
                // Transaction waiting on SCA (Strong Customer Authentication) or
                // approval from Ask to Buy
                break
            case .userCancelled:
                print("User cancelled!")
                break
            @unknown default:
                print("Failed to purchase the product!")
                break
            }
        } catch {
            print("Failed to purchase the product!")
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
        
        self.isCashFlowPro = !self.purchasedProductIDs.isEmpty
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
        } catch {
            print(error)
        }
    }
}

// MARK: - Utils
extension PurchasesManager {
    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
    
    func getSubscriptionStatus() async {
        guard let subscription = subscription?.subscription else { return }
        
        do {
            let statuses = try await subscription.status
            
            for status in statuses {
                let info = try status.renewalInfo.payloadValue
                
                switch status.state {
                case .subscribed:
                    if info.willAutoRenew {
                        isCashFlowPro = true
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
                    isCashFlowPro = false
                    debugPrint("getSubscriptionStatus user subscription is expired.")
                    return
                case .revoked:
                    debugPrint("getSubscriptionStatus user subscription was revoked.")
                    return
                default:
                    fatalError("getSubscriptionStatus WARNING STATE NOT CONSIDERED.")
                }
            }
        } catch { }
        return
    }
    
    func getLifetimeStatus() async {
        guard let lifetime else { return }
        
        do {
            if try await lifetime.currentEntitlement?.payloadValue != nil {
                isCashFlowPro = true
            }
        } catch {
            
        }
    }
}

// MARK: - SKPaymentTransactionObserver
extension PurchasesManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
