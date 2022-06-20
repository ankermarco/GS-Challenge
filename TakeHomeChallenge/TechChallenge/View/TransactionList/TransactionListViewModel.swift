import Combine
import Foundation
import SwiftUI

final class TransactionListViewModel: ObservableObject {
    @Published
    var transactions = [TransactionViewData]()
    
    @Published
    var selectedCategory: Category? = nil
    
    @Published
    var sum: String = ""
    
    let categories = [CategoryModel()] + ModelData.categories
    
    private let transactionsManager: TransactionsManager
    
    private func initialiseValues() {
        transactions = transactionsManager.transactions
        selectedCategory = transactionsManager.selectedCategory
        
        let total = transactionsManager.calculateTotal(from: transactions)
        sum = "\(total.toPrice())"
    }
    
    init(transactionsManager: TransactionsManager) {
        self.transactionsManager = transactionsManager

        initialiseValues()
    }
    
    // Mark: - Public
    func switchCategory(_ category: Category? = nil) {
        selectedCategory = category
        
        let (total, transactionsByCategory) = transactionsManager.sumOfTransactionsAndTransctions(in: category)
        sum = total.toPrice()
        transactions = transactionsByCategory
    }
    
    func tappedPinButtonWith(transactionId: Int, isPinned: Bool, category: Category) {
        transactionsManager.updateTransaction(with: transactionId,
                                              isPinned: isPinned)
        sum = transactionsManager.sumOfTransactionsWithCaching(in: category).toPrice()
    }
}


