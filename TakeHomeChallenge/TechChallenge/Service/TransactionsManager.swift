/// TransactionsManager manages the transactions
///
/// Extracts all the logics to manipulate transactions e.g. filter transactions by category, fitler transactions by `isPinned`
/// so that it can be used in different viewModels, and keep the transactions in sync between different viewModels
///
final class TransactionsManager {
    private let transactionLoader: TransactionLoading
    
    private(set) var transactions = [TransactionViewData]()
    private(set) var selectedCategory: Category? = nil
    
    // Using this to reduce the number of calls to fetch the data
    private(set) var storedTransactions = [TransactionViewData]()
    
    // cached sum
    var cachedSumOfPinnedTransactions: Double = 0.0
    
    // cached sum of all pinned transactions for each category
    var cachedSumOfEachCategory = [Category: Double]()
    
    init(transactionLoader: TransactionLoading) {
        self.transactionLoader = transactionLoader
        loadAllTransactions()
    }
    
    private func loadAllTransactions() {
        transactionLoader.load { [weak self] model in
            guard let self = self else {
                return
            }
            
            let transactions = model.toTransactionViewData()
            
            self.transactions = transactions
            self.storedTransactions = transactions
            
            self.initialiseCachedSumOfEachCategory(from: transactions)
        }
    }

    private func resetTransactions() {
        transactions = storedTransactions
    }
    
    private func initialiseCachedSumOfEachCategory(from allTransactions: [TransactionViewData]) {
        for categoryModel in ModelData.categories {
            guard let category = categoryModel.category else {
                fatalError("Category doesn't exist")
            }
            
            let transactions = filteredTransactionsByCategory(transactions: allTransactions, category: category)
            let totalForEachCategory = calculateTotal(from: transactions)
            cachedSumOfEachCategory[category] = totalForEachCategory
            
            cachedSumOfPinnedTransactions += totalForEachCategory
        }
    }
    
    /// This function returns all the transactions in the category
    ///
    /// - Parameter: transactions - collection of transactions
    /// - Parameter: category - Category
    /// - Returns: all the transactions in the given category
    ///
    func filteredTransactionsByCategory(transactions: [TransactionViewData], category: Category?) -> [TransactionViewData] {
        transactions.filter { transaction in
            transaction.category == category
        }
    }
    
    /// This function returns all the transactions which is pinned
    ///
    /// - Parameter: transactions - collection of transactions
    /// - Returns: all the transactions which is pinned
    ///
    func filteredPinned(from transactions: [TransactionViewData]) -> [TransactionViewData] {
        transactions.filter { transaction in
            transaction.isPinned
        }
    }
    
    /// This function returns all the transactions in the category
    ///
    /// - Parameter: category - Category
    /// - Returns: all the transactions in the category
    ///
    func filteredTransactions(by category: Category? = nil) -> [TransactionViewData] {
        if category != selectedCategory {
            resetTransactions()
        }
        
        if let category = category {
            return filteredTransactionsByCategory(transactions: transactions, category: category)
        }
        
        return transactions
    }
    
    /// This function calculates the sum of all transactions
    ///
    /// - Parameter: transactions - collection of transactions
    /// - Returns: sum of the transactions
    ///
    func calculateTotal(from transactions: [TransactionViewData]) -> Double {
        transactions.map { $0.amount }.reduce(0, +)
    }
    
    /// This function gets the index of transactions matching given id
    ///
    /// - Parameter: id - Int the transaction id
    /// - Returns: index of the matched transaction
    ///
    private func indexOfTransactionMatching(_ id: Int) -> Int? {
        transactions.firstIndex(where: { $0.id == id })
    }
    
    /// This function caches the sum of pinned transactions
    ///
    ///
    private func cacheSumOfPinnedTransactions() {
        let pinnedTransactions = filteredPinned(from: transactions)
        let total = calculateTotal(from: pinnedTransactions)
        
        cachedSumOfPinnedTransactions = total
    }
    
    /// This function sets transaction pinned status for all the transactions
    ///
    /// - Parameter: id - transaction id
    /// - Parameter: isPinned - is transaction pinned
    ///
    func updateTransaction(with id: Int, isPinned: Bool) {
        guard let index = indexOfTransactionMatching(id) else {
            return
        }
        
        transactions[index].isPinned = isPinned
        
        cacheSumOfPinnedTransactions()
    }
    
    /// This function caches sum for given transactions in the given category
    ///
    /// - Parameter: transactions - collection of transactions
    /// - Parameter: category - Category
    ///
    private func cacheSumOf(transactions: [TransactionViewData], category: Category) {
        cachedSumOfEachCategory[category] = calculateTotal(from: transactions)
    }

    /// This function calculates the ratio for given category from cache
    ///
    /// - Parameter: categoryIndex - category index in Enum Category
    /// - Returns: the ratio
    ///
    func ratio(for categoryIndex: Int) -> Double {
        // ratio = sum of transactions in category / sum of all transactions
        if cachedSumOfPinnedTransactions == 0.0 {
            return 0.0
        }
        return (cachedSumOfEachCategory[Category.allCases[categoryIndex]] ?? 0.0) / cachedSumOfPinnedTransactions
    }

    /// This function calculates the offset for given category from cache
    ///
    /// - Parameter: categoryIndex - category index in Enum Category
    /// - Returns: the offset
    ///
    func offset(for categoryIndex: Int) -> Double {
        // offset = previous offset + previous ratio
        if categoryIndex > 0 {
            let prevRatio = ratio(for: categoryIndex - 1)
            return offset(for: categoryIndex - 1) + prevRatio
        } else {
            return 0.0
        }
    }

    /// This function calculates the sum of transactions without caching
    ///
    /// - parameter: category - Category
    /// - returns: sum and transactions in category
    ///
    func sumOfTransactionsAndTransctions(in category: Category?) -> (Double, [TransactionViewData]) {
        selectedCategory = category
        
        let transactionsInCategory = filteredTransactions(by: category)
        let pinned = filteredPinned(from: transactionsInCategory)
        let total = calculateTotal(from: pinned)
        
        return (total, transactionsInCategory)
    }
    
    /// This function calculates the sum of pinned transactions in given category
    /// and caches the sum
    /// if the selected category is nil, then calculate the sum of all pinned transactions
    ///
    /// - parameter: category - Category
    /// - returns: sum of the pinned transactions
    ///
    func sumOfTransactionsWithCaching(in category: Category) -> Double {
        
        let transactionsInCategory = filteredTransactions(by: category)
        let pinnedTransactions = filteredPinned(from: transactionsInCategory)
        
        cacheSumOf(transactions: pinnedTransactions, category: category)
        
        if selectedCategory != nil {
            return calculateTotal(from: pinnedTransactions)
        } else {
            return calculateTotal(from: filteredPinned(from: transactions))
        }
    }
}
