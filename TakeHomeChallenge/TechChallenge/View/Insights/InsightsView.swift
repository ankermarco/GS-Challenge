//
//  InsightsView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 29/7/21.
//

import SwiftUI

/// ViewData to build categoy list with sum for each category
struct CategoryTotalListViewData: Identifiable {
    let id = UUID()
    
    let title: String
    let color: Color
    let sum: String
}

struct InsightsView: View {
    
    @ObservedObject
    private var viewModel: InsightsViewModel
    
    // Add init and make viewModel private
    // to prevent user modify viewModel directly
    init(viewModel: InsightsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            RingView(viewData: viewModel.ringViewData)
                .scaledToFit()
                .scaleEffect(0.9)
            
            CategoryList(viewModel)
        }
        .onAppear {
            viewModel.viewDidLoad()
        }
        .navigationTitle("Insights")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func CategoryList(_ viewModel: InsightsViewModel) -> some View {
        ForEach(viewModel.categoryTotalListViewData) { viewData in
            HStack {
                Text(viewData.title)
                    .font(.headline)
                    .foregroundColor(viewData.color)
                Spacer()
                
                Text(viewData.sum)
                    .bold()
                    .secondary()
            }
        }
    }
}

#if DEBUG
struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView(viewModel: InsightsViewModel(transactionsManager: TransactionsManager(transactionLoader: LocalTransactionLoader()) ))
            .previewLayout(.sizeThatFits)
    }
}
#endif
