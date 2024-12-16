import Foundation


struct MinWalletConstant {
    static let minWalletURL = GetInfoDictionaryString(for: "MIN_BASE_URL", true)
    static let keyChainService = GetInfoDictionaryString(for: "MIN_KEYCHAIN_SERVICE_NAME")
    static let keyChainAccessGroup = GetInfoDictionaryString(for: "MIN_KEYCHAIN_ACCESS_GROUP")
    static let passDefaultForFaceID = GetInfoDictionaryString(for: "MIN_PASS_DEFAULT_FOR_FACE_ID")

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
