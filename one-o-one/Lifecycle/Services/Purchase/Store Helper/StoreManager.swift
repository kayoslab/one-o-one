import StoreKit
import Foundation

/// An enumeration of all the types of products or purchases.
enum SectionType: String, CustomStringConvertible {

    // swiftlint:disable duplicate_enum_cases
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
    // swiftlint:enable duplicate_enum_cases

    case download = "DOWNLOAD"
    case originalTransaction = "ORIGINAL TRANSACTION"
    case productIdentifier = "PRODUCT IDENTIFIER"
    case transactionDate = "TRANSACTION DATE"
    case transactionIdentifier = "TRANSACTION ID"

    var description: String {
        return self.rawValue
    }
}

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

// MARK: - SKProductsRequestDelegate

/// Extends StoreManager to conform to SKProductsRequestDelegate.
extension StoreManager: SKProductsRequestDelegate {

    // Used to get the App Store's response to your request and notify your observer.
    // - Tag: ProductRequest
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        storeResponse.removeAll()

        // products contains products whose identifiers have been recognized
        // by the App Store. As such, they can be purchased.
        availableProducts = response.products

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

                self?.delegate?.storeManagerDidReceiveResponse(
                    storeResponse
                )
            }
        }
    }
}

// MARK: - SKRequestDelegate

/// Extends StoreManager to conform to SKRequestDelegate.
extension StoreManager: SKRequestDelegate {

    func requestDidFinish(_ request: SKRequest) {

    }

    // Called when the product request failed.
    func request(
        _ request: SKRequest,
        didFailWithError error: Error
    ) {
        dump(error)
    }
}
