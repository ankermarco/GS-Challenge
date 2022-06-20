//
//  TransactionListView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import Combine
import SwiftUI

struct TransactionListView: View {
    @ObservedObject
    private var viewModel: TransactionListViewModel
    
    // Add init and make viewModel private
    // to prevent user modify viewModel directly
    init(viewModel: TransactionListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            // Filter bar
            filterBar(viewModel: viewModel)
            
            List {
                ForEach(viewModel.transactions) { transaction in
                    TransactionView(transaction: transaction) { (id, isPinned, category) in
                        viewModel.tappedPinButtonWith(transactionId: id, isPinned: isPinned, category: category)
                    }
                }
            }
            .animation(.easeIn)
            .listStyle(PlainListStyle())
            
            // Summary box
            summaryBox(viewModel: viewModel)
                .padding(.horizontal, 8)
            
        }
        .navigationBarTitle("Transactions", displayMode: .inline)
    }
    
    @ViewBuilder
    private func filterBar(viewModel: TransactionListViewModel) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.categories) { categoryModel in
                    FilterView(viewData: FilterViewData(categoryModel: categoryModel)) { category in
                        viewModel.switchCategory(category)
                    }
                }
            }
        }
        .padding()
        .background(Color.accentColor.opacity(0.8))
    }
    
    @ViewBuilder
    private func summaryBox(viewModel: TransactionListViewModel) -> some View {
        HStack(alignment: .bottom) {
            Text("Total spent:")
                .fontWeight(.regular)
                .secondary()
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.selectedCategory?.rawValue ?? "all")
                    .font(.system(.headline))
                    .foregroundColor(viewModel.selectedCategory?.color ?? .black)
                
                Text(viewModel.sum)
                    .fontWeight(.bold)
                    .secondary()
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.accentColor, lineWidth: 2.0)
        )
    }
}

#if DEBUG
struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(
            viewModel:
                TransactionListViewModel(
                    transactionsManager: TransactionsManager(transactionLoader: LocalTransactionLoader())
                )
        )
    }
}
#endif
