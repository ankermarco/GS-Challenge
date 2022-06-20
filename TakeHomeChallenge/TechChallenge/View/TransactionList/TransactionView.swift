//
//  TransactionView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

struct TransactionView: View {
    let transaction: TransactionViewData
    let tapPin: (Int, Bool, Category) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(transaction.category.rawValue)
                    .font(.headline)
                    .foregroundColor(transaction.category.color)
                Spacer()
                Button {
                    transaction.isPinned.toggle()
                    tapPin(transaction.id, transaction.isPinned, transaction.category)
                } label: {
                    Image(systemName: transaction.isPinned ? "pin.fill" : "pin.slash.fill")
                }
            }

            if transaction.isPinned {
                HStack {
                    transaction.image
                        .resizable()
                        .frame(
                            width: 60.0,
                            height: 60.0,
                            alignment: .top
                        )

                    VStack(alignment: .leading) {
                        Text(transaction.name)
                            .secondary()
                        Text(transaction.accountName)
                            .tertiary()
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("\(transaction.amount.toPrice())")
                            .bold()
                            .secondary()
                        Text(transaction.date.formatted)
                            .tertiary()
                    }
                }
            }

        }
        .padding(8.0)
        .background(Color.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
    }
}

#if DEBUG
struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TransactionView(transaction: ModelData.sampleTransactions.toTransactionViewData()[0]) { _, _, _ in }
            TransactionView(transaction: ModelData.sampleTransactions.toTransactionViewData()[1]) { _, _, _ in }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

#endif
