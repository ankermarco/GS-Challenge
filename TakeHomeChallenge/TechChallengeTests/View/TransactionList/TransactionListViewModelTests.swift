import XCTest
@testable import TechChallenge

final class TransactionListViewModelTests: XCTestCase {
    func test_init_transactionsIsLoadedFromTransactionLoader() {
        let transactionsManager = TransactionsManager(transactionLoader: LocalTransactionLoader())
        let sut = makeSUT(transactionsManager: transactionsManager)
        
        XCTAssertFalse(sut.transactions.isEmpty)
    }
    
    func test_switchCategory_filtersTransactionsAndCalculateSumAsExpected() {
        let transactionsManager = TransactionsManager(transactionLoader: LocalTransactionLoader())
        let sut = makeSUT(transactionsManager: transactionsManager)
        
        sut.switchCategory(.entertainment)
        
        XCTAssertEqual(sut.transactions.count, 1)
        
        XCTAssertEqual(sut.sum, "$82.99")
    }
    
    func test_switchCategory_filtersTransactionsAndCalculateSumForAllTransactions() {
        let transactionsManager = TransactionsManager(transactionLoader: LocalTransactionLoader())
        let sut = makeSUT(transactionsManager: transactionsManager)
        
        sut.switchCategory()
        
        XCTAssertEqual(sut.transactions.count, 13)
        
        XCTAssertEqual(sut.sum, "$472.08")
    }
    
    func test_tappedPinButtonWith_filtersTransactionsAndCalculateSumAsExpected() {
        let transactionsManager = TransactionsManager(transactionLoader: LocalTransactionLoader())
        let sut = makeSUT(transactionsManager: transactionsManager)
        
        sut.tappedPinButtonWith(transactionId: 1, isPinned: false, category: .entertainment)
        XCTAssertEqual(sut.sum, "$389.09")
        
        XCTAssertEqual(transactionsManager.cachedSumOfPinnedTransactions, 389.0899999999999)
        XCTAssertEqual(transactionsManager.cachedSumOfEachCategory[.entertainment], 0.00)
        
        
        sut.tappedPinButtonWith(transactionId: 1, isPinned: true, category: .entertainment)
        XCTAssertEqual(sut.sum, "$472.08")
        
        XCTAssertEqual(transactionsManager.cachedSumOfPinnedTransactions, 472.0799999999999)
        XCTAssertEqual(transactionsManager.cachedSumOfEachCategory[.entertainment], 82.99)
    }
    
    // Mark: - Helpers
    func makeSUT(transactionsManager: TransactionsManager) -> TransactionListViewModel {
        TransactionListViewModel(transactionsManager: transactionsManager)
    }
}
