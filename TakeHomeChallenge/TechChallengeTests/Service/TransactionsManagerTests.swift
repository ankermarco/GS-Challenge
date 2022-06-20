@testable import TechChallenge
import XCTest

final class TransactionsManagerTests: XCTestCase {
    
    func test_init() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.transactions.count, 13)
        XCTAssertEqual(sut.cachedSumOfPinnedTransactions, cachedTotal)
        XCTAssertEqual(sut.cachedSumOfEachCategory.count, 5)
        XCTAssertEqual(sut.cachedSumOfEachCategory[.entertainment], 82.99)
    }
    
    func test_filteredTransactionsByCategory_returnsExpectedTransactions() {
        let sut = makeSUT()
        
        let trans = sut.filteredTransactionsByCategory(transactions: sut.transactions, category: .entertainment)
        
        XCTAssertEqual(trans.count, 1)
        XCTAssertEqual(trans[0].id, 1)
        XCTAssertEqual(trans[0].name, "Movie Night")
        XCTAssertEqual(trans[0].amount, 82.99)
        XCTAssertEqual(trans[0].category, .entertainment)
    }
    
    func test_filteredPinned_returnsExpectedTransactions() {
        let sut = makeSUT()
        
        let trans = sut.filteredPinned(from: sut.transactions)
        
        XCTAssertEqual(trans.count, 13)
        
        sut.transactions[0].isPinned = false
        
        let trans2 = sut.filteredPinned(from: sut.transactions)
        
        XCTAssertEqual(trans2.count, 12)
    }
    
    func test_filteredTransactions_returnsExpectedTransactions() {
        let sut = makeSUT()
        
        let trans = sut.filteredTransactions(by: nil)
        
        XCTAssertEqual(trans.count, 13)
        
        let trans2 = sut.filteredTransactions(by: .entertainment)
        
        XCTAssertEqual(trans2.count, 1)
    }
    
    func test_calculateTotal_retunsSumOfTransactions() {
        let sut = makeSUT()
        
        let sum = sut.calculateTotal(from: sut.transactions)
        XCTAssertEqual(sum, 472.0799999999999)
    }
    
    func test_updateTransaction_changesTransactionIsPinnedValue() {
        let sut = makeSUT()
        XCTAssertEqual(sut.transactions[0].isPinned, true)
        
        sut.updateTransaction(with: 1, isPinned: false)
        
        XCTAssertEqual(sut.transactions[0].isPinned, false)
    }
    
    func test_ratio_returnsValuesFromCache() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.ratio(for: 2), 82.99/cachedTotal)
    }
    
    func test_offset_returnsValuesFromCache() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.offset(for: 1), 74.28/cachedTotal)
    }
    
    func test_sumOfTransactionsAndTransctions_returnsExpectedValues() {
        let sut = makeSUT()
        
        let (total, transactions) = sut.sumOfTransactionsAndTransctions(in: .entertainment)
        
        XCTAssertEqual(sut.selectedCategory, .entertainment)
        XCTAssertEqual(total, 82.99)
        XCTAssertEqual(transactions[0].category, .entertainment)
        
        sut.updateTransaction(with: 1, isPinned: false)
        let (totalAfterUnpinItem, transactionsAfterUnpinItem) = sut.sumOfTransactionsAndTransctions(in: .entertainment)
        
        XCTAssertEqual(sut.selectedCategory, .entertainment)
        XCTAssertEqual(totalAfterUnpinItem, 0.0)
        XCTAssertEqual(transactionsAfterUnpinItem[0].category, .entertainment)
    }
    
    func test_sumOfTransactionsWithCaching_cachesSumOfTransactionsInCategory() {
        let sut = makeSUT()
        
        let total = sut.sumOfTransactionsWithCaching(in: .entertainment)
        
        XCTAssertEqual(sut.selectedCategory, nil)
        XCTAssertEqual(total.rounded(.toNearestOrAwayFromZero), cachedTotal.rounded(.toNearestOrAwayFromZero))
        XCTAssertEqual(sut.cachedSumOfEachCategory[.entertainment], 82.99)
        
        sut.updateTransaction(with: 1, isPinned: false)
        let totalAfterUnpinItem = sut.sumOfTransactionsWithCaching(in: .entertainment)
        
        XCTAssertEqual(sut.selectedCategory, nil)
        XCTAssertEqual(totalAfterUnpinItem.rounded(.toNearestOrAwayFromZero), (cachedTotal - 82.99).rounded(.toNearestOrAwayFromZero))
        XCTAssertEqual(sut.cachedSumOfEachCategory[.entertainment], 0.0)
        
    }
    
    // Mark: - helpers
    private var sampleTransactions = {
        [TransactionViewData(id: 1,
                             name: "Movie night",
                             category: .entertainment,
                             amount: 70.00,
                             date: Date(string: "2021-03-05")!,
                             accountName: "",
                             provider: nil,
                             isPinned: true)]
    }()
    
    private let cachedTotal = 472.08000000000004
    
    func makeSUT() -> TransactionsManager {
        TransactionsManager(transactionLoader: LocalTransactionLoader())
    }
}
