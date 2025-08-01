import Foundation
import Apollo
import MinWalletAPI
import OSLog
import SwiftyJSON


class MinWalletService {
    static let shared: MinWalletService = .init()
    
    private let apolloClient: ApolloClient
    
    private init() {
        apolloClient = ApolloClient(url: URL(string: MinWalletConstant.minURL + "/graphql")!)
    }
    
    /// Executes a GraphQL query asynchronously and returns the resulting data.
    /// - Parameter query: The GraphQL query to execute.
    /// - Returns: The data returned by the query, or `nil` if no data is present.
    /// - Throws: An `AppGeneralError.serverError` if the query fails or if GraphQL errors are returned.
    func fetch<Query: GraphQLQuery>(query: Query) async throws -> Query.Data? {
        #if DEBUG
            os_log("\(query.description) BEGIN")
        #endif
        return try await withCheckedThrowingContinuation { continuation in
            apolloClient.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in
                #if DEBUG
                    os_log("\(query.description) END")
                #endif
                switch result {
                case let .success(response):
                    if let errors = response.errors, !errors.isEmpty {
                        let msgError = errors.map({ $0.message ?? $0.description }).joined(separator: "\n")
                        continuation.resume(throwing: AppGeneralError.serverError(message: msgError))
                    } else {
                        continuation.resume(returning: response.data)
                    }
                case let .failure(error):
                    continuation.resume(throwing: AppGeneralError.serverError(message: Self.extractError(error)))
                }
            }
        }
    }
    
    /// Executes a GraphQL mutation asynchronously and returns the resulting data.
    /// - Parameter mutation: The GraphQL mutation to perform.
    /// - Returns: The data returned by the mutation, or `nil` if no data is present.
    /// - Throws: `AppGeneralError.serverError` if the mutation fails or if GraphQL errors are returned.
    func mutation<Mutation: GraphQLMutation>(mutation: Mutation) async throws -> Mutation.Data? {
        #if DEBUG
            os_log("\(mutation.description) BEGIN")
        #endif
        return try await withCheckedThrowingContinuation { continuation in
            apolloClient.perform(mutation: mutation) { result in
                #if DEBUG
                    os_log("\(mutation.description) END")
                #endif
                switch result {
                case let .success(response):
                    if let errors = response.errors, !errors.isEmpty {
                        let msgError = errors.map({ $0.message ?? $0.description }).joined(separator: "\n")
                        continuation.resume(throwing: AppGeneralError.serverError(message: msgError))
                    } else {
                        continuation.resume(returning: response.data)
                    }
                case let .failure(error):
                    continuation.resume(throwing: AppGeneralError.serverError(message: Self.extractError(error)))
                }
            }
        }
    }
}

extension GraphQLOperation {
    var description: String {
        /*
        let operation = "------Oper------:\n" + "\(String(describing: self))"
        let variables = "------Vars------:\n" + "\(self.__variables as AnyObject)"
        return operation + variables
         */
        return String(describing: self)
    }
}


extension MinWalletService {
    /// Extracts and concatenates error messages from a GraphQL error response if available.
    /// - Parameter error: The error to extract messages from.
    /// - Returns: A string containing concatenated error messages from the response, or the error's localized description if extraction fails.
    static func extractError(_ error: Error) -> String {
        guard let error = error as? ResponseCodeInterceptor.ResponseCodeError else { return error.localizedDescription }
        guard case let .invalidResponseCode(_, rawData) = error else { return error.localizedDescription }
        guard let data = rawData else { return error.localizedDescription }
        let json = JSON(data)
        let messages: [String] = json["errors"].arrayValue.compactMap { json in json["message"].string }
        guard !messages.isEmpty else { return error.localizedDescription }
        return messages.joined(separator: ", ")
    }
}

extension Error {
    var rawError: String {
        guard let error = self as? ResponseCodeInterceptor.ResponseCodeError else { return self.localizedDescription }
        guard case let .invalidResponseCode(_, rawData) = error else { return error.localizedDescription }
        guard let data = rawData else { return error.localizedDescription }
        let json = JSON(data)
        let messages: [String] = json["errors"].arrayValue.compactMap { json in json["message"].string }
        guard !messages.isEmpty else { return error.localizedDescription }
        return messages.joined(separator: ", ")
    }
}
