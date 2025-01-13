import Foundation


struct MinWalletConstant {
    static let minGraphQLURL = GetInfoDictionaryString(for: "MIN_GRAPHQL_URL", true)
    static let transactionURL = GetInfoDictionaryString(for: "MIN_TRANSACTION_URL", true)
    static let keyChainService = GetInfoDictionaryString(for: "MIN_KEYCHAIN_SERVICE_NAME")
    static let keyChainAccessGroup = GetInfoDictionaryString(for: "MIN_KEYCHAIN_ACCESS_GROUP")
    static let passDefaultForFaceID = GetInfoDictionaryString(for: "MIN_PASS_DEFAULT_FOR_FACE_ID")
    static let networkID = GetInfoDictionaryString(for: "MIN_PUBLIC_NETWORK_ID")

    private init() {

    }

}


private func GetInfoDictionaryString(for key: String, _ removingBackslashes: Bool = false) -> String {
    let ret = Bundle.main.infoDictionary?[key] as! String
    if removingBackslashes {
        return ret.replacingOccurrences(of: "\\", with: "")
    } else {
        return ret
    }
}
