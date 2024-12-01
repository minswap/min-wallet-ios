import SwiftUI

extension Font {
    ///20 semibold
    static let titleH6: Font = .custom("Inter Display", size: 20).weight(.semibold)
    ///16 medium
    static let labelMediumSecondary: Font = .custom("Inter", size: 16).weight(.medium)
    ///16 semibold
    static let labelSemiSecondary: Font = .custom("Inter", size: 16).weight(.semibold)
    ///14 medium
    static let labelSmallSecondary: Font = .custom("Inter", size: 14).weight(.medium)
    ///14 regular
    static let paragraphSmall: Font = .custom("Inter", size: 14).weight(.regular)
    ///12 regular
    static let paragraphXSmall: Font = .custom("Inter", size: 12)
    ///12 medium
    static let paragraphXMediumSmall: Font = .custom("Inter", size: 12).weight(.medium)
    ///24 semibold
    static let titleH5: Font = .custom("Inter", size: 24).weight(.semibold)
    ///40 semibold
    static let titleH3: Font = .custom("Inter", size: 40).weight(.semibold)
    ///32 semibold
    static let titleH4: Font = .custom("Inter", size: 32).weight(.semibold)
    ///18 medium
    static let titleH7: Font = .custom("Inter", size: 18).weight(.medium)
    
}

extension UIFont {
    //static let titleH6: UIFont =  UIFont(name: "Inter Display", size: 20) ?? .systemFont(ofSize: 20)
    //static let labelMediumSecondary: UIFont =  UIFont(name: "Inter Display", size: 16) ?? .systemFont(ofSize: 16)
    //static let labelSmallSecondary: UIFont = .custom("Inter", size: 14).weight(.medium)
    static let paragraphSmall: UIFont = UIFont(name: "Lobster-Regular", size: 14) ?? .systemFont(ofSize: 14)
    //static let paragraphXSmall: UIFont = .custom("Inter", size: 12)
    //static let titleH5: UIFont = .custom("Inter", size: 24).weight(.semibold)
    //static let titleH3: UIFont = .custom("Inter", size: 40).weight(.semibold)
    //static let titleH4: UIFont = .custom("Inter", size: 32).weight(.semibold)
}
