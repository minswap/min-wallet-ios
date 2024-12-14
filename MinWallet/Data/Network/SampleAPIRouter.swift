import Foundation
import Alamofire


enum SampleAPIRouter: GDomainAPIRouter {
    case login(username: String, password: String)

    func path() -> String {
        switch self {
        case .login:
            return "/api/auth/login"
        }
    }

    func method() -> HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }

    func parameters() -> Parameters {
        var params = Parameters()
        switch self {
        case let .login(username, password):
            params["username"] = username
            params["password"] = password
        }

        return params
    }
}
