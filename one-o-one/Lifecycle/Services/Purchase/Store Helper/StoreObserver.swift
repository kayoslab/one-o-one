import Foundation
import StoreKit

protocol StoreObserverDelegate: AnyObject {
    /// The purchase succeeded with a list of transactions.
    ///
    /// - Parameter transactions: A list of purchased transactions.
    func purchaseExecuted(transactions: [SKPaymentTransaction])

    /// Handling the purchase has failed due to an unexpected error.
    func purchaseFailed()

    /// Tells the delegate that the restore operation was successful with a list of transactions.
    ///
    /// - Parameter transactions: A list of restored transactions.
    func storeObserverRestored(transactions: [SKPaymentTransaction])

    /// Restoring the purchase failed due to an unexpected error.
    func storeObserverFailedRestore()
}

class StoreObserver: NSObject {

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

    weak var delegate: StoreObserverDelegate?

    /// Create and add a payment request to the payment queue.
    func buy(_ product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    // MARK: - Restore All Restorable Purchases

    /// Restores all previously completed purchases.
    func restore() {
        restored.removeAll()
        SKPaymentQueue.default()
            .restoreCompletedTransactions()
    }

    private func handlePurchased(_ transaction: SKPaymentTransaction) {
        purchased.append(transaction)

        // Inform the purchase was done.
        DispatchQueue.main.async { [weak self] in
            guard let purchased = self?.purchased else {
                self?.delegate?.purchaseFailed()
                return
            }

            self?.delegate?.purchaseExecuted(transactions: purchased)
        }

        // Finish the successful transaction.
        SKPaymentQueue.default()
            .finishTransaction(transaction)
    }

    /// Handles failed purchase transactions.
    private func handleFailed(_ transaction: SKPaymentTransaction) {
        // Do not send any notifications when the user cancels the purchase.
        if (transaction.error as? SKError)?.code != .paymentCancelled {
            // Inform that an unexpected error occured.
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.purchaseFailed()
            }
        }

        // Finish the failed transaction.
        SKPaymentQueue.default()
            .finishTransaction(transaction)
    }

    /// Handles restored purchase transactions.
    private func handleRestored(_ transaction: SKPaymentTransaction) {
        restored.append(transaction)

        // Finishes the restored transaction.
        SKPaymentQueue.default()
            .finishTransaction(transaction)
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

    // Called when an error occur while restoring purchases.
    // Notify the user about the error.
    func paymentQueue(
        _ queue: SKPaymentQueue,
        restoreCompletedTransactionsFailedWithError error: Error
    ) {
        if let error = error as? SKError, error.code != .paymentCancelled {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.storeObserverFailedRestore()
            }
        }
    }

    // Called when all restorable transactions have been processed by the payment queue.
    func paymentQueueRestoreCompletedTransactionsFinished(
        _ queue: SKPaymentQueue
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let restored = self?.restored else {
                self?.delegate?.storeObserverFailedRestore()
                return
            }

            self?.delegate?.storeObserverRestored(transactions: restored)
        }
    }
}
