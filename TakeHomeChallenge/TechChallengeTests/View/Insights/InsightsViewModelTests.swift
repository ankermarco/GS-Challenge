@testable import TechChallenge
import XCTest

final class InsightsViewModelTests: XCTestCase {
    func test_viewDidLoad_returnsExpectedValue() {
        let sut = makeSUT()
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.categoryTotalListViewData.count, 5)
        XCTAssertEqual(sut.categoryTotalListViewData[0].title, "food")
        XCTAssertEqual(sut.categoryTotalListViewData[0].sum, "$74.28")
        
        XCTAssertEqual(sut.ringViewData.count, 5)
        XCTAssertEqual(sut.ringViewData[0].offset, 0.0)
        XCTAssertEqual(sut.ringViewData[0].ratio, 0.15734621250635483)
    }
    
    private func makeSUT() -> InsightsViewModel {
        InsightsViewModel(transactionsManager: TransactionsManager(transactionLoader: LocalTransactionLoader()))
    }

}
