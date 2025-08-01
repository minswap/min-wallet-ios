import Foundation
import Alamofire
import Combine
import SwiftyJSON


/// Executes an asynchronous throwing operation, retrying up to a specified maximum count with a delay between attempts if an error occurs.
/// - Parameters:
///   - maximumRetryCount: The maximum number of attempts to execute the operation. Defaults to 1 (no retries).
///   - delayBeforeRetry: The delay between retry attempts. Defaults to 2 seconds.
///   - body: The asynchronous throwing closure to execute.
/// - Returns: The result of the successful operation.
/// - Throws: The last error encountered if all retry attempts fail.
func attempts<T>(
    maximumRetryCount: Int = 1,
    delayBeforeRetry: DispatchTimeInterval = .seconds(2),
    _ body: @escaping () async throws -> T
) async throws -> T {
    var attempts = 0
    func attempt() async throws -> T {
        attempts += 1
        do {
            return try await body()
        } catch {
            guard attempts < maximumRetryCount else { throw error }
            // Delay the task by 1 second:
            try? await Task.sleep(nanoseconds: delayBeforeRetry.nanoseconds)
            return try await attempt()
        }
    }
    return try await attempt()
}

/// Executes an asynchronous throwing operation with retry logic, retrying only if the error satisfies a given condition.
/// - Parameters:
///   - maximumRetryCount: The maximum number of attempts to perform.
///   - delayBeforeRetry: The delay between retry attempts.
///   - errorCondition: A closure that determines whether an encountered error should trigger a retry.
///   - body: The asynchronous throwing operation to execute.
/// - Returns: The result of the successful operation.
/// - Throws: The last encountered error if the maximum retry count is reached or the error does not satisfy the retry condition.
func attempts<T>(
    maximumRetryCount: Int = 1,
    delayBeforeRetry: DispatchTimeInterval = .seconds(2),
    errorCondition: @escaping (Error) -> Bool,
    _ body: @escaping () async throws -> T
) async throws -> T {
    var attempts = 0
    func attempt() async throws -> T {
        attempts += 1
        do {
            return try await body()
        } catch {
            guard errorCondition(error),
                attempts < maximumRetryCount
            else { throw error }
            try? await Task.sleep(nanoseconds: delayBeforeRetry.nanoseconds)
            return try await attempt()
        }
    }
    return try await attempt()
}


// MARK: - Alamofire debug log
extension Alamofire.Request {
    /// Prints the cURL representation of the request for debugging if `printFlag` is true.
    /// - Parameter printFlag: If true, outputs the cURL command to the console.
    /// - Returns: The original request instance for method chaining.
    func debugLog(_ printFlag: Bool = false) -> Self {
        if printFlag {
            print(">>>> Request -LOG-START- >>>>")
            return cURLDescription { curl in
                print(curl)
                print(">>>> Request -LOG-END- >>>>")
            }
        }
        return self
    }
}

extension Alamofire.DataResponse {
    /// Prints detailed debug information about the response, including the request URL and a pretty-printed JSON body if available, when `printFlag` is true.
    /// - Parameter printFlag: If true, prints debug output for the response.
    /// - Returns: The response instance, allowing for method chaining.
    @discardableResult
    func debugLog(_ printFlag: Bool = false) -> Self {
        if printFlag {
            print(">>>> Response -LOG-START- >>>>")
            print("==== Response Request: ", request?.url ?? "", " ====")
            switch result {
            case let .success(data):
                guard let data = data as? Data,
                    let value = try? JSONSerialization.jsonObject(with: data)
                else {
                    print("Error: Response isn't JSON Object")
                    return self
                }
                
                if !JSONSerialization.isValidJSONObject(value) {
                    print("Error: Response isn't JSON Object")
                } else if let jsonData = try? JSONSerialization.data(withJSONObject: value as AnyObject, options: [.prettyPrinted]),
                    let jsonString = String(data: jsonData, encoding: .utf8)
                {
                    print(jsonString)
                } else {
                    print("Error: Can't parse response to JSON")
                }
            case let .failure(error):
                print("Error: ", error.localizedDescription)
            }
            print(">>>> Response -LOG-END- >>>>")
        }
        
        return self
    }
}

extension DispatchTimeInterval {
    var nanoseconds: UInt64 {
        let now = DispatchTime.now()
        let later = now + self
        return later.uptimeNanoseconds - now.uptimeNanoseconds
    }
}
