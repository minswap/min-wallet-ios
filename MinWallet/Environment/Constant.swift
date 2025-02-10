import Foundation


struct MinWalletConstant {
    static let minURL = GetInfoDictionaryString(for: "MIN_URL", true)
    static let transactionURL = GetInfoDictionaryString(for: "MIN_TRANSACTION_URL", true)
    static let handleAdaNameURL = GetInfoDictionaryString(for: "MIN_HANDLE_ADA_NAME_URL", true)
    static let keyChainService = GetInfoDictionaryString(for: "MIN_KEYCHAIN_SERVICE_NAME")
    static let keyChainAccessGroup = GetInfoDictionaryString(for: "MIN_KEYCHAIN_ACCESS_GROUP")
    static let passDefaultForFaceID = GetInfoDictionaryString(for: "MIN_PASS_DEFAULT_FOR_FACE_ID")
    static let networkID = GetInfoDictionaryString(for: "MIN_PUBLIC_NETWORK_ID")
    static let minToken = GetInfoDictionaryString(for: "MIN_MIN_TOKEN")
    static let lpToken = GetInfoDictionaryString(for: "MIN_LP_TOKEN")
    static let adaToken = GetInfoDictionaryString(for: "MIN_ADA_TOKEN")
    static let mintToken = GetInfoDictionaryString(for: "MIN_MINT_TOKEN")
    static let adaCurrency = GetInfoDictionaryString(for: "MIN_ADA_CURRENCY")
    static let minOneSignalAppID = GetInfoDictionaryString(for: "MIN_ONE_SIGNAL_APP_ID")
    static let minswapScheme = "minswap"
    static let addressPrefix = GetInfoDictionaryString(for: "MIN_ADDRESS_PREFIX")
    static let adaHandleRegex = #"^\$[a-z0-9._-]+$"#
    static let IPFS_PREFIX = "ipfs://"
    static let IPFS_GATEWAY = "https://ipfs.minswap.org/ipfs/"
    static let suspiciousTokenURL = "https://raw.githubusercontent.com/cardano-galactic-police/suspicious-tokens/refs/heads/main/tokens.txt"

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
