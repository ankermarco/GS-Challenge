// Facade design pattern
// if we need to connect with another data source
// just create another implementation conforms to this protocol

protocol TransactionLoading {
    func load(completion: @escaping ([TransactionModel]) -> Void)
}

final class LocalTransactionLoader: TransactionLoading {
    func load(completion: @escaping ([TransactionModel]) -> Void ) {
        completion(ModelData.sampleTransactions)
    }
}
