//
//  LocalTransactionLoaderTests.swift
//  TechChallengeTests

@testable import TechChallenge
import XCTest

final class LocalTransactionLoaderTests: XCTestCase {
    func test_load_loadsDataFromModelData() {
        let sut = makeSUT()
        let exp = XCTestExpectation(description: "Wait for loading")
        sut.load { transactions in
            XCTAssertEqual(ModelData.sampleTransactions, transactions)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    // Mark: - Helpers
    private func makeSUT() -> LocalTransactionLoader {
        LocalTransactionLoader()
    }
}
