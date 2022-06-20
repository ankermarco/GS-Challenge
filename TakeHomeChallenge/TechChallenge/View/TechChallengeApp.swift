//
//  TechChallengeApp.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

@main
struct TechChallengeApp: App {
    let transactionManager = TransactionsManager(transactionLoader: LocalTransactionLoader())
    var transactionListViewModel: TransactionListViewModel {
        .init(transactionsManager: transactionManager)
    }
    
    var insightsViewModel: InsightsViewModel {
        .init(transactionsManager: transactionManager)
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    TransactionListView(viewModel: transactionListViewModel)
                }
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet")
                }
                
                NavigationView {
                    InsightsView(viewModel: insightsViewModel)
                }
                .tabItem {
                    Label("Insights", systemImage: "chart.pie.fill")
                }
            }
        }
    }
}
