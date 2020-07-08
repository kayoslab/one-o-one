import Foundation
import StoreKit

// MARK: - StoreManagerDelegate


// MARK: - StoreObserverDelegate

protocol StoreObserverDelegate: AnyObject {
    /// Tells the delegate that the restore operation was successful.
    func storeObserverRestoreDidSucceed()
}


class StoreObserver: NSObject {
    
    static let shared: StoreObserver = .init()
    
    /**
     Indicates whether the user is allowed to make payments.
     - returns: true if the user is allowed to make payments and false, otherwise.
     Tell StoreManager to query the App Store when the user is
     allowed to make payments and there are product identifiers to be queried.
     */
    private var isAuthorizedForPayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    /// Keeps track of all purchases.
    private var purchased = [SKPaymentTransaction]()
    
    /// Keeps track of all restored purchases.
    private var restored = [SKPaymentTransaction]()
    
    /// Indicates whether there are restorable purchases.
    private var hasRestorablePurchases = false
    
    weak var delegate: StoreObserverDelegate?
    
    private override init() {
        super.init()
    }

    /// Create and add a payment request to the payment queue.
    func buy(_ product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - Restore All Restorable Purchases
    
    /// Restores all previously completed purchases.
    func restore() {
        if !restored.isEmpty {
            restored.removeAll()
        }
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func handlePurchased(_ transaction: SKPaymentTransaction) {
        purchased.append(transaction)
        // Finish the successful transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    /// Handles failed purchase transactions.
    private func handleFailed(_ transaction: SKPaymentTransaction) {
        if let error = transaction.error {
            print(error.localizedDescription)
        }
        
        // Do not send any notifications when the user cancels the purchase.
        if (transaction.error as? SKError)?.code != .paymentCancelled {
            
        }
        // Finish the failed transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    /// Handles restored purchase transactions.
    private func handleRestored(_ transaction: SKPaymentTransaction) {
        hasRestorablePurchases = true
        restored.append(transaction)
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.storeObserverRestoreDidSucceed()
        }
        // Finishes the restored transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

extension StoreObserver: SKPaymentTransactionObserver {
    // Called when there are transactions in the payment queue.
    func paymentQueue(
        _ queue: SKPaymentQueue,
        updatedTransactions transactions: [SKPaymentTransaction]
    ) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
            case .deferred:
                // Do not block the UI. Allow the user to continue using the app.
                print("Deferred")
            case .purchased:
                // The purchase was successful.
                handlePurchased(transaction)
            case .failed:
                // The transaction failed.
                handleFailed(transaction)
            case .restored:
                // There're restored products.
                handleRestored(transaction)
            @unknown default:
                // This should be remote loged
                print("unknown payment transaction")
            }
        }
    }
    
    // Logs all transactions that have been removed from the payment queue.
    func paymentQueue(
        _ queue: SKPaymentQueue,
        removedTransactions transactions: [SKPaymentTransaction]
    ) {
        
    }
    
    // Called when an error occur while restoring purchases. Notify the user about the error.
    func paymentQueue(
        _ queue: SKPaymentQueue,
        restoreCompletedTransactionsFailedWithError error: Error
    ) {
        if let error = error as? SKError, error.code != .paymentCancelled {
            
        }
    }
    
    // Called when all restorable transactions have been processed by the payment queue.
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if !hasRestorablePurchases {
            // Nothing to restore
        }
    }
}
