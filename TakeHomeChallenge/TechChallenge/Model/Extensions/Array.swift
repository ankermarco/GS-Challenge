import Foundation

extension Array where Element == TransactionModel {
    func toTransactionViewData() -> [TransactionViewData] {
        map {
            TransactionViewData(
                id: $0.id,
                name: $0.name,
                category: $0.category,
                amount: $0.amount,
                date: $0.date,
                accountName: $0.accountName,
                provider: $0.provider,
                isPinned: true
            )
        }
    }
}
