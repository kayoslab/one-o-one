import Foundation
import StoreKit

/// Defines the interaction between the `AppDelegate` and the `PurchaseService`.
/// This protocol contains functions that take care of the `SKPaymentQueue`.
protocol PurchaseServiceApplicationMainInteraction {
    /// Starts the purchase service. This function adds an observer to the
    /// `SKPaymentQueue.default()` queue.
    ///
    /// - Note: Your application should add an observer to the payment queue during
    ///         application initialization. If there are no observers attached to the queue,
    ///         the payment queue does not synchronize its list of pending transactions
    ///         with the Apple App Store, because there is no observer to respond to
    ///         updated transactions.
    ///         If an application quits when transactions are still being processed,
    ///         those transactions are not lost. The next time the application launches,
    ///         the payment queue resumes processing the transactions. Your application
    ///         should always expect to be notified of completed transactions.
    ///         If more than one transaction observer is attached to the payment queue,
    ///         no guarantees are made as to the order which they will be called.
    ///         It is safe for multiple observers to call `finishTransaction(_:)`,
    ///         but not recommended. It is recommended that you use a single observer
    ///         to process and finish the transaction.
    func start()

    /// Stops the purchase service. This function removes the observer from the
    /// `SKPaymentQueue.default()` queue.
    ///
    /// - Note: If there are no observers attached to the queue, the payment queue does
    ///         not synchronize its list of pending transactions with the Apple App Store,
    ///         because there is no observer to respond to updated transactions.
    func stop()
}

protocol PurchaseServices {

    /// Attempts to buy a product via an InApp purchase.
    ///
    /// - Parameter product: The product that should be bought.
    /// - Parameter completion: A completion that will be called when the operation finishes.
    ///                         The completion operation will be called immediately if a secon
    ///                         operation is already in progress.
    /// - Parameter didExecute: Informs if the execution of the operation was possible.
    func buy(product: Product, completion: @escaping (_ didExecute: Bool) -> Void)

    func restorePurchase(completion: @escaping (_ didExecute: Bool) -> Void)
}

class PurchaseService {
    static var shared: PurchaseService = .init()

    private let storeObserver: StoreObserver = .init()
    private let storeManager: StoreManager = .init()
    /// A list of available products according to the AppStore.
    private var availableProducts: [SKProduct] = []

    /// A completion that is used by the `buy(product: Product)`
    /// call to inform the caller that the attempt to purchase has finished.
    ///
    /// - Parameter didExecute: Informs if the execution of the
    ///                         operation was possible.
    private var purchaseCompletion: ((_ didExecute: Bool) -> Void)?

    /// A completion that is used by the `restorePurchase()`
    /// call to inform the caller that the attempt to restore has finished.
    ///
    /// - Parameter didExecute: Informs if the execution of the
    ///                         operation was possible.
    private var restoreCompletion: ((_ didExecute: Bool) -> Void)?

    private init() { }
}

extension PurchaseService: PurchaseServices {

    func buy(product: Product, completion: @escaping (_ didExecute: Bool) -> Void) {
        // Make sure the product is not yet purchased.
        guard !product.isPurchased else {
            return completion(true)
        }

        // Make sure there's no other purchase operation ongoing.
        guard purchaseCompletion == nil else {
            return completion(false)
        }

        // Make sure the product is available for purchase.
        guard let availableProduct = availableProducts
            .first(where: { $0.productIdentifier == product.rawValue })
        else {
            // Refreshing the products at this point could solve
            // some issues that might occur on second try.
            storeManager.startProductRequest(
                with: Product.allCases.map { $0.rawValue }
            )
            return completion(false)
        }

        purchaseCompletion = completion
        storeObserver.buy(availableProduct)
    }

    func restorePurchase(completion: @escaping (_ didExecute: Bool) -> Void) {
        guard restoreCompletion == nil else {
            return completion(false)
        }

        restoreCompletion = completion

        storeObserver.delegate = self
        storeObserver.restore()
    }
}

extension PurchaseService: StoreObserverDelegate {

    func purchaseExecuted(transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            guard transaction.error == nil,
                transaction.transactionState == .purchased || transaction.transactionState == .restored
            else {
                continue
            }

            let productIdentifier = transaction.payment.productIdentifier
            Product(rawValue: productIdentifier)?.updatePurchaseStatus(isPurchased: true)
        }

        purchaseCompletion?(true)
        purchaseCompletion = nil
    }

    func purchaseFailed() {
        purchaseCompletion?(false)
        purchaseCompletion = nil
    }

    func storeObserverRestored(transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            guard transaction.error == nil,
                transaction.transactionState == .purchased || transaction.transactionState == .restored
            else {
                continue
            }

            let productIdentifier = transaction.payment.productIdentifier
            Product(rawValue: productIdentifier)?.updatePurchaseStatus(isPurchased: true)
        }

        restoreCompletion?(true)
        restoreCompletion = nil
    }

    func storeObserverFailedRestore() {
        restoreCompletion?(false)
        restoreCompletion = nil
    }
}

extension PurchaseService: StoreManagerDelegate {
    func storeManagerDidReceiveResponse(_ response: [Section]) {
        availableProducts = response
            .filter { $0.type == .availableProducts }
            .compactMap { $0.elements as? [SKProduct] }
            .flatMap { $0 }
    }
}

extension PurchaseService: PurchaseServiceApplicationMainInteraction {
    func start() {
        SKPaymentQueue.default().add(storeObserver)
        storeManager.startProductRequest(
            with: Product.allCases.map { $0.rawValue }
        )
    }

    func stop() {
        SKPaymentQueue.default().remove(storeObserver)
        restoreCompletion = nil
        purchaseCompletion = nil
    }
}
