import Foundation
import Alamofire


protocol GDomainAPIRouter: GAPIRouter {}

extension GDomainAPIRouter {
    // -- dùng domainAdapter
    func baseUrl() -> String { "" }
    func headers() -> HTTPHeaders { .init() }
    // -- dùng domainAdapter

    func encoding() -> ParameterEncoding { defaultEncoding }

    func asURLRequest() throws -> URLRequest { try defaultAsURLRequest() }

    // -- implement domainAdapter => trỏ tới domain phù hợp

    func domainHeadersContext() -> GDomainHeadersContext? { nil }

    func domainAuthRetrier() -> GDomainAuthRetrier? { GDomainRefreshRetrierNoOpDefault.sharedAuthRetrier }
}
