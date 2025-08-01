import Foundation
import Alamofire
import SwiftyJSON


protocol APIRouter: Alamofire.URLRequestConvertible {
    func baseUrl() -> String
    func headers() -> Alamofire.HTTPHeaders
    func path() -> String
    func method() -> Alamofire.HTTPMethod
    func parameters() -> Alamofire.Parameters
    func encoding() -> ParameterEncoding
    
    func domainAdapter() -> DomainAdapter?
    func domainHeadersContext() -> DomainHeadersContext?
    
    func domainAuthRetrier() -> GDomainAuthRetrier?
}

extension APIRouter {
    
    // MARK: default API
    var defaultEncoding: ParameterEncoding {
        (method() == .get)
            ? URLEncoding.default
            : JSONEncoding.default
    }
    
    var defaultFullURL: String {
        baseUrl().appending(path())
    }
    
    /// Constructs a `URLRequest` using the default base URL, path, HTTP method, headers, and encodes parameters with the specified encoding.
    /// - Returns: A configured `URLRequest` ready for use.
    /// - Throws: An error if the URL or HTTP method is invalid. Parameter encoding errors are caught and logged but do not throw.
    func defaultAsURLRequest() throws -> URLRequest {
        // URL, method, headers
        var urlRequest = try URLRequest(
            url: defaultFullURL,
            method: method(),
            headers: headers())
        
        // parameters
        do {
            let parameters = parameters()
            urlRequest = try encoding().encode(urlRequest, with: parameters)
        } catch {
            print("Encoding fail \(error.localizedDescription)")
        }
        
        return urlRequest
    }
    
    // MARK: adapted API
    var adaptedFullURL: String {
        if let adapter = domainAdapter(),
            !adapter.baseURLString.isEmpty,
            baseUrl().isEmpty
        {
            return adapter.baseURLString.appending(path())
        }
        
        return baseUrl().appending(path())
    }
    
    /// Returns the HTTP headers for the request, using the domain adapter to modify them if available.
    func adaptedHeaders() -> HTTPHeaders {
        if let adapter = domainAdapter() {
            return adapter.adaptHeaders(
                context: domainHeadersContext(),
                headers: headers())
        }
        
        return headers()
    }
    
    /// Constructs a `URLRequest` with the adapted URL and headers if a domain adapter is available.
    /// - Returns: A `URLRequest` with the appropriate URL and headers applied.
    /// - Throws: An error if URL construction fails.
    func adaptedAsURLRequest() throws -> URLRequest {
        var urlRequest: URLRequest = try asURLRequest()
        if let adapter = domainAdapter() {
            // url
            urlRequest.url = try adaptedFullURL.asURL()
            // headers
            let adptHeaders = adapter.adaptHeaders(
                context: domainHeadersContext(),
                headers: .init(urlRequest.allHTTPHeaderFields ?? [:]))
            for (_, header) in adptHeaders.enumerated() {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }
        
        return urlRequest
    }
}

// MARK: - Helper
public
    struct APIRouterCommon
{
    static var logAPIDurationThreshold: TimeInterval? = nil
    static var onLogAPIDuration: ((_ response: AFDataResponse<Data>) -> Void)?
    
    /// Parses a JSON response for an error message and throws a server error if found.
    /// - Parameters:
    ///   - jsonData: The JSON object to inspect for error information.
    ///   - alternateMessageIfEmptyError: The message to use if no specific error is found (defaults to a generic error).
    /// - Throws: `APIRouterError.serverError` if the JSON contains an "error" key.
    static func parseDefaultErrorMessage(_ jsonData: JSON, alternateMessageIfEmptyError: String = APIRouterError.GenericError) throws {
        if jsonData["error"].exists() {
            let error = jsonData["error"].stringValue
            let message = jsonData["message"].string ?? error
            
            throw APIRouterError.serverError(message: message)
        }
        return
    }
}

extension Alamofire.AFDataResponse where Success == Data, Failure == AFError {
    /// Logs the API request duration if it exceeds the configured threshold.
    /// - Returns: The response itself, allowing for method chaining.
    @discardableResult
    func logAPIDuration() -> Self {
        guard let threshold = APIRouterCommon.logAPIDurationThreshold,
            let requestDuration = self.metrics?.taskInterval.duration,
            requestDuration >= threshold
        else { return self }
        
        APIRouterCommon.onLogAPIDuration?(self)
        
        return self
    }
}


// MARK: - Promise: async_request
extension APIRouter {
    /// Performs an asynchronous HTTP request using the adapted URL, method, parameters, encoding, and headers, returning the response as JSON.
    /// - Parameters:
    ///   - sessionManager: The Alamofire session to use for the request. Defaults to `Session.default`.
    ///   - debugRequest: If true, logs request details for debugging.
    ///   - debugResponse: If true, logs response details for debugging.
    /// - Returns: The response parsed as a SwiftyJSON `JSON` object.
    /// - Throws: An error if the request fails or the response cannot be parsed as JSON.
    func async_request(
        sessionManager: Session = Session.default,
        debugRequest: Bool = false,
        debugResponse: Bool = false
    ) async throws -> JSON {
        try await _async_requestWithRetry {
            await sessionManager
                .request(
                    adaptedFullURL,
                    method: method(),
                    parameters: parameters(),
                    encoding: encoding(),
                    headers: adaptedHeaders()
                )
                .debugLog(debugRequest)
                .serializingData().response
                .debugLog(debugResponse)
                .logAPIDuration()
        }
        .tryMap({ try JSON(data: $0) })
        .result.get()
    }
    
    /// Performs an asynchronous HTTP request using a manually constructed URLRequest with domain adaptation.
    /// - Parameters:
    ///   - debugRequest: If true, logs request details for debugging.
    ///   - debugResponse: If true, logs response details for debugging.
    /// - Returns: The response data parsed as JSON.
    /// - Throws: An error if the request fails or the response cannot be parsed as JSON.
    func async_requestWithManualURLRequest(
        sessionManager: Session = Session.default,
        debugRequest: Bool = false,
        debugResponse: Bool = false
    ) async throws -> JSON {
        try await _async_requestWithRetry {
            await sessionManager
                .request(try adaptedAsURLRequest())
                .debugLog(debugRequest)
                .serializingData().response
                .debugLog(debugResponse)
                .logAPIDuration()
        }
        .tryMap({ try JSON(data: $0) })
        .result.get()
    }
    
    /// Performs an asynchronous multipart form data upload request with retry logic.
    /// - Parameters:
    ///   - multipartFormData: Closure to construct the multipart form data for the upload.
    ///   - updateProgress: Optional closure called with upload progress updates.
    ///   - debugRequest: Whether to log request details for debugging.
    ///   - debugResponse: Whether to log response details for debugging.
    /// - Returns: The parsed JSON response.
    /// - Throws: An error if the upload or response parsing fails.
    func async_uploadRequest(
        sessionManager: Session = Session.default,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        updateProgress: ((Progress) -> Void)? = nil,
        debugRequest: Bool = false,
        debugResponse: Bool = false
    ) async throws -> JSON {
        try await _async_requestWithRetry {
            await sessionManager
                .upload(
                    multipartFormData: multipartFormData,
                    to: adaptedFullURL,
                    method: method(),
                    headers: adaptedHeaders()
                )
                .debugLog(debugRequest)
                .uploadProgress {
                    updateProgress?($0)
                }
                .serializingData().response
                .debugLog(debugResponse)
                .logAPIDuration()
        }
        .tryMap({ try JSON(data: $0) })
        .result.get()
    }
    
    /// Performs an asynchronous multipart form data upload using a manually constructed URLRequest, with optional debug logging for the request and response.
    /// - Parameters:
    ///   - multipartFormData: A closure to append data to the multipart form.
    ///   - debugRequest: Set to `true` to enable debug logging of the request.
    ///   - debugResponse: Set to `true` to enable debug logging of the response.
    /// - Returns: The parsed JSON response from the server.
    /// - Throws: An error if the upload or response parsing fails.
    func async_uploadRequestWithManualURLRequest(
        sessionManager: Session = Session.default,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        debugRequest: Bool = false,
        debugResponse: Bool = false
    ) async throws -> JSON {
        try await _async_requestWithRetry {
            await sessionManager
                .upload(
                    multipartFormData: multipartFormData,
                    with: try adaptedAsURLRequest()
                )
                .debugLog(debugRequest)
                .serializingData().response
                .debugLog(debugResponse)
                .logAPIDuration()
        }
        .tryMap({ try JSON(data: $0) })
        .result.get()
    }
}
