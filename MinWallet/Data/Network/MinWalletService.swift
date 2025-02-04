import Foundation
import Apollo
import MinWalletAPI


class MinWalletService {
    static let shared: MinWalletService = .init()

    private let apolloClient: ApolloClient

    private init() {
        apolloClient = ApolloClient(url: URL(string: MinWalletConstant.minURL + "/graphql")!)
    }

    func fetch<Query: GraphQLQuery>(query: Query) async throws -> Query.Data? {
        try await withCheckedThrowingContinuation { continuation in
            apolloClient.fetch(query: query) { result in
                switch result {
                case let .success(response):
                    if let errors = response.errors, !errors.isEmpty {
                        let msgError = errors.map({ $0.message ?? $0.description }).joined(separator: "\n")
                        continuation.resume(throwing: AppGeneralError.serverError(message: msgError))
                    } else {
                        continuation.resume(returning: response.data)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func mutation<Mutation: GraphQLMutation>(mutation: Mutation) async throws -> Mutation.Data? {
        try await withCheckedThrowingContinuation { continuation in
            apolloClient.perform(mutation: mutation) { result in
                switch result {
                case let .success(response):
                    if let errors = response.errors, !errors.isEmpty {
                        let msgError = errors.map({ $0.message ?? $0.description }).joined(separator: "\n")
                        continuation.resume(throwing: AppGeneralError.serverError(message: msgError))
                    } else {
                        continuation.resume(returning: response.data)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
