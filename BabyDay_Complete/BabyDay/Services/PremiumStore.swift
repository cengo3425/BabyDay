import Foundation
import StoreKit

@MainActor
final class PremiumStore: ObservableObject {
    static let premiumProductID = "com.babyday.premium.monthly"

    @Published private(set) var product: Product?
    @Published private(set) var isPremium = false
    @Published private(set) var isLoading = false

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task {
            await loadProduct()
            await observeTransactions()
        }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProduct() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let products = try await Product.products(for: [Self.premiumProductID])
            product = products.first
        } catch {
            product = nil
        }
    }

    func purchase() async {
        guard let product else { return }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    isPremium = true
                    await transaction.finish()
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            // Production: show localized purchase error.
        }
    }

    private func observeTransactions() async {
        for await update in Transaction.updates {
            if case .verified(let transaction) = update {
                if transaction.productID == Self.premiumProductID {
                    isPremium = transaction.revocationDate == nil
                }
                await transaction.finish()
            }
        }
    }
}
