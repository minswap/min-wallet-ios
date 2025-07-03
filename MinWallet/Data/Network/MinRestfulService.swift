import Foundation
import OSLog
import SwiftyJSON

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - RESTful Request Protocol
protocol RESTfulRequest {
    associatedtype Response: Codable

    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }

    var description: String { get }
}

// MARK: - Default Implementation
extension RESTfulRequest {
    var parameters: [String: Any]? { nil }
    var headers: [String: String]? { nil }
    var body: Data? { nil }

    var description: String {
        return "\(method.rawValue) \(path)"
    }
}

// MARK: - RESTful Service
class MinRestfulService {
    static let shared: MinRestfulService = .init()

    private let session: URLSession
    private let baseURL: String

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        session = URLSession(configuration: config)
        baseURL = MinWalletConstant.minURL + "/aggregator"
    }

    // MARK: - Generic Request Method
    func request<Request: RESTfulRequest>(_ request: Request) async throws -> Request.Response? {
        #if DEBUG
            os_log("\(request.description) BEGIN")
        #endif

        let urlRequest = try buildURLRequest(from: request)

        do {
            let (data, response) = try await session.data(for: urlRequest)

            #if DEBUG
                os_log("\(request.description) END")
            #endif

            try validateResponse(response, data: data)

            guard !data.isEmpty else {
                return nil
            }

            let decoder = JSONDecoder()
            let result = try decoder.decode(Request.Response.self, from: data)
            return result

        } catch {
            #if DEBUG
                os_log("\(request.description) FAILED: \(error.localizedDescription)")
            #endif
            throw AppGeneralError.serverError(message: Self.extractError(error, data: nil))
        }
    }

    // MARK: - Convenience Methods
    func get<T: Codable>(
        _ path: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T? {
        let request = GenericRequest<T>(
            path: path,
            method: .GET,
            parameters: parameters,
            headers: headers
        )
        return try await self.request(request)
    }

    func post<T: Codable>(
        _ path: String,
        headers: [String: String]? = nil,
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T? {
        let request = GenericRequest<T>(
            path: path,
            method: .POST,
            parameters: nil,
            headers: headers,
            body: body
        )
        return try await self.request(request)
    }

    func put<T: Codable>(
        _ path: String,
        headers: [String: String]? = nil,
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T? {
        let request = GenericRequest<T>(
            path: path,
            method: .PUT,
            parameters: nil,
            headers: headers,
            body: body
        )
        return try await self.request(request)
    }

    func delete<T: Codable>(
        _ path: String,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T? {
        let request = GenericRequest<T>(
            path: path,
            method: .DELETE,
            headers: headers
        )
        return try await self.request(request)
    }

    // MARK: - Private Methods
    private func buildURLRequest<Request: RESTfulRequest>(from request: Request) throws -> URLRequest {
        var urlComponents = URLComponents(string: baseURL + request.path)!

        // Add query parameters for GET requests
        if request.method == .GET, let parameters = request.parameters {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }

        guard let url = urlComponents.url else {
            throw AppGeneralError.serverError(message: "Invalid URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        // Set headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        request.headers?
            .forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }

        // Set body for non-GET requests
        if request.method != .GET {
            if let body = request.body {
                urlRequest.httpBody = body
            } else if let parameters = request.parameters {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                urlRequest.httpBody = jsonData
            }
        }

        return urlRequest
    }

    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppGeneralError.serverError(message: "Invalid response")
        }

        guard 200...299 ~= httpResponse.statusCode else {
            let errorMessage = Self.extractError(
                NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: nil),
                data: data
            )
            throw AppGeneralError.serverError(message: errorMessage)
        }
    }
}

// MARK: - Generic Request Implementation
private struct GenericRequest<T: Codable>: RESTfulRequest {
    typealias Response = T

    let path: String
    let method: HTTPMethod
    let parameters: [String: Any]?
    let headers: [String: String]?
    let body: Data?

    init(
        path: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }
}

// MARK: - Error Extraction
extension MinRestfulService {
    private static func extractError(_ error: Error, data: Data?) -> String {
        // Try to extract error from response data first
        if let data = data, !data.isEmpty {
            let json = JSON(data)

            // Check for standard error formats
            if let message = json["message"].string {
                return message
            }

            if let error = json["error"].string {
                return error
            }

            // Check for errors array (similar to GraphQL)
            let messages: [String] = json["errors"].arrayValue
                .compactMap { json in
                    json["message"].string
                }
            if !messages.isEmpty {
                return messages.joined(separator: ", ")
            }

            // Check for detail field (common in REST APIs)
            if let detail = json["detail"].string {
                return detail
            }
        }

        // Fall back to error's localized description
        return error.localizedDescription
    }
}
