import StoreKit
import Foundation

// swiftlint:disable duplicate_enum_cases
/// An enumeration of all the types of products or purchases.
enum SectionType: String, CustomStringConvertible {
    #if os (macOS)
    case availableProducts = "Available Products"
    case invalidProductIdentifiers = "Invalid Product Identifiers"
    case purchased = "Purchased"
    case restored = "Restored"
    #else
    case availableProducts = "AVAILABLE PRODUCTS"
    case invalidProductIdentifiers = "INVALID PRODUCT IDENTIFIERS"
    case purchased = "PURCHASED"
    case restored = "RESTORED"
    #endif
    case download = "DOWNLOAD"
    case originalTransaction = "ORIGINAL TRANSACTION"
    case productIdentifier = "PRODUCT IDENTIFIER"
    case transactionDate = "TRANSACTION DATE"
    case transactionIdentifier = "TRANSACTION ID"

    var description: String {
        return self.rawValue
    }
}
// swiftlint:enable duplicate_enum_cases

/// A structure that is used to represent a list of products or purchases.
struct Section {
    /// Products/Purchases are organized by category.
    var type: SectionType
    /// List of products/purchases.
    var elements = [Any]()
}
protocol StoreManagerDelegate: AnyObject {
    /// Provides the delegate with the App Store's response.
    func storeManagerDidReceiveResponse(_ response: [Section])
}

class StoreManager: NSObject {

    static let shared: StoreManager = .init()

    // MARK: - Properties

    /// Keeps track of all valid products. These products are available for sale in the App Store.
    private var availableProducts = [SKProduct]()

    /// Keeps track of all invalid product identifiers.
    private var invalidProductIdentifiers = [String]()

    /// Keeps a strong reference to the product request.
    private var productRequest: SKProductsRequest?

    /// Keeps track of all valid products (these products are available for sale in the App Store)
    /// and of all invalid product identifiers.
    private var storeResponse = [Section]()

    weak var delegate: StoreManagerDelegate?

    override private init() {
        super.init()
    }

    // MARK: - Request Product Information

    /// Starts the product request with the specified identifiers.
    func startProductRequest(with identifiers: [String]) {
        fetchProducts(matchingIdentifiers: identifiers)
    }

    /// Fetches information about your products from the App Store.
    /// - Tag: FetchProductInformation
    private func fetchProducts(matchingIdentifiers identifiers: [String]) {
        // Create a set for the product identifiers.
        let productIdentifiers = Set(identifiers)

        // Initialize the product request with the above identifiers.
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest?.delegate = self

        // Send the request to the App Store.
        productRequest?.start()
    }
}

extension StoreManager {

//    /// - returns: Existing product's title matching the specified product identifier.
//    private func title(
//        matchingIdentifier identifier: String
//    ) -> String? {
//        guard !availableProducts.isEmpty else { return nil }
//        
//        // Search availableProducts for a product whose productIdentifier
//        // property matches identifier. Return its localized title when found.
//        let result = availableProducts.filter {
//            $0.productIdentifier == identifier
//        }
//        
//        return result.first?.localizedTitle
//    }
//    
//    /// - returns: Existing product's title associated with the specified payment transaction.
//    private func title(
//        matchingPaymentTransaction transaction: SKPaymentTransaction
//    ) -> String {
//        let title = self.title(matchingIdentifier: transaction.payment.productIdentifier)
//        return title ?? transaction.payment.productIdentifier
//    }
}

// MARK: - SKProductsRequestDelegate

/// Extends StoreManager to conform to SKProductsRequestDelegate.
extension StoreManager: SKProductsRequestDelegate {

    // Used to get the App Store's response to your request and notify your observer.
    // - Tag: ProductRequest
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        if !storeResponse.isEmpty {
            storeResponse.removeAll()
        }

        // products contains products whose identifiers have been recognized
        // by the App Store. As such, they can be purchased.
        if !response.products.isEmpty {
            availableProducts = response.products
        }

        // invalidProductIdentifiers contains all product identifiers not
        // recognized by the App Store.
        if !response.invalidProductIdentifiers.isEmpty {
            invalidProductIdentifiers = response.invalidProductIdentifiers
        }

        if !availableProducts.isEmpty {
            storeResponse.append(
                .init(
                    type: .availableProducts,
                    elements: availableProducts
                )
            )
        }

        if !invalidProductIdentifiers.isEmpty {
            storeResponse.append(
                .init(
                    type: .invalidProductIdentifiers,
                    elements: invalidProductIdentifiers
                )
            )
        }

        if !storeResponse.isEmpty {
            DispatchQueue.main.async { [weak self] in
                guard let storeResponse = self?.storeResponse else {
                    return
                }

                self?.delegate?.storeManagerDidReceiveResponse(storeResponse)
            }
        }
    }
}

// MARK: - SKRequestDelegate

/// Extends StoreManager to conform to SKRequestDelegate.
extension StoreManager: SKRequestDelegate {

    // Called when the product request failed.
    func request(_ request: SKRequest, didFailWithError error: Error) {

    }
}
