import SwiftUI

// ViewData for building transaction view
// Comparing with the original code
// We don't want to tight coupled with the TransactionModel
final class TransactionViewData: Identifiable, ObservableObject {
    let id: Int
    let name: String
    let category: Category
    let amount: Double
    let date: Date
    let accountName: String
    let provider: TransactionModel.Provider?
    var isPinned: Bool
    
    init(id: Int,
         name: String,
         category: Category,
         amount: Double,
         date: Date,
         accountName: String,
         provider: TransactionModel.Provider?,
         isPinned: Bool)
    {
        self.id = id
        self.name = name
        self.category = category
        self.amount = amount
        self.date = date
        self.accountName = accountName
        self.provider = provider
        self.isPinned = isPinned
    }
}

extension TransactionViewData {
    var image: Image {
        guard
            let provider = provider,
            let uiImage = UIImage(named: provider.rawValue)
        else {
            return Image(systemName: "questionmark.circle.fill")
        }
        
        return Image(uiImage: uiImage)
    }
}
