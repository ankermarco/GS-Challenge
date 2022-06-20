import Combine
import Foundation
import SwiftUI

final class InsightsViewModel: ObservableObject {
    private let transactionsManager: TransactionsManager
    
    init(transactionsManager: TransactionsManager) {
        self.transactionsManager = transactionsManager
    }
    
    // ViewData to build ringView
    // on insightsView
    @Published
    var ringViewData = [RingViewData]()
    
    // ViewData to build category list with sum
    // on insightsView
    @Published
    var categoryTotalListViewData = [CategoryTotalListViewData]()
    
    // Mark: - Public
    func viewDidLoad() {
        updateRingViewData()
        updateCategoryTotalListViewData()
    }
    
    // Mark: - Helpers
    private func updateCategoryTotalListViewData() {
        categoryTotalListViewData =
        ModelData.categories.map {
            guard let category = $0.category else {
                fatalError("Category doesn't exist")
            }
            let total = transactionsManager.cachedSumOfEachCategory[category]
            return CategoryTotalListViewData(
                title: $0.title,
                color: $0.color,
                sum: "\((total ?? 0.0).toPrice())"
            )
        }
    }
    
    private func updateRingViewData() {
        ringViewData = ModelData.categories.enumerated().map { (index, category) in
            RingViewData(offset: offset(for: index),
                         ratio: ratio(for: index),
                         color: category.color)
        }
    }
    
    private func ratio(for categoryIndex: Int) -> Double {
        transactionsManager.ratio(for: categoryIndex)
    }

    private func offset(for categoryIndex: Int) -> Double {
        transactionsManager.offset(for: categoryIndex)
    }
    
}
