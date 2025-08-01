import SwiftUI


class BannerState: ObservableObject {
    @Published
    var isShowingBanner: Bool = false
    
    @Published
    var infoContent: (() -> AnyView)?
    
    init() {}
    
    /// Returns a default informational banner view indicating successful transaction submission.
    /// - Parameter onViewTransaction: An optional closure triggered when the user taps "View on explorer" or the arrow icon.
    /// - Returns: An `AnyView` displaying a styled success banner with transaction details and an interactive explorer link.
    func infoContentDefault(onViewTransaction: (() -> Void)?) -> AnyView {
        AnyView(
            HStack(alignment: .top) {
                Image(.icCheckSuccess)
                    .fixSize(24)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Transaction Submitted")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorInteractiveToneSuccess)
                    Text("Your transaction has been submitted successfully")
                        .lineLimit(nil)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    HStack(spacing: 4) {
                        Text("View on explorer")
                            .underline()
                            .baselineOffset(4)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                            .onTapGesture {
                                onViewTransaction?()
                            }
                        Image(.icArrowUp)
                            .fixSize(.xl)
                            .onTapGesture {
                                onViewTransaction?()
                            }
                    }
                    .padding(.top, 4)
                }
                Spacer(minLength: 0)
            }
            .padding()
            .background(.colorBaseBackground)
            .clipped()
            .cornerRadius(._3xl)
            .overlay(RoundedRectangle(cornerRadius: ._3xl).stroke(.colorBaseSuccessSub, lineWidth: 1))
            .shadow(radius: 5, x: 0, y: 5)
        )
    }
    
    /// Creates a styled error banner view displaying an error message and a close button.
    /// - Parameter error: The error message to display in the banner.
    /// - Returns: An `AnyView` containing the error banner UI.
    private func errorDefault(_ error: String) -> AnyView {
        AnyView(
            HStack(alignment: .centerIconAlignment) {
                Image(.icCloseToast)
                    .fixSize(24)
                    .alignmentGuide(.centerIconAlignment) { d in d[VerticalAlignment.center] }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Error")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorInteractiveToneDanger)
                        .alignmentGuide(.centerIconAlignment) { d in d[VerticalAlignment.center] }
                    Text(error)
                        .lineLimit(nil)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                }
                Spacer(minLength: 0)
                Image(.icClose)
                    .fixSize(24)
                    .alignmentGuide(.centerIconAlignment) { d in d[VerticalAlignment.center] }
                    .onTapGesture {
                        withAnimation {
                            self.isShowingBanner = false
                        }
                    }
            }
            .padding()
            .background(.colorBaseBackground)
            .clipped()
            .cornerRadius(.lg)
            .overlay(RoundedRectangle(cornerRadius: .lg).stroke(.colorBorderDangerSub, lineWidth: 1))
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.15), radius: 5, x: 0, y: 5)
        )
    }
    
    /// Animates the visibility of the banner after a short delay.
    /// - Parameter isShow: A Boolean value indicating whether the banner should be shown or hidden.
    func showBanner(isShow: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            withAnimation {
                self.isShowingBanner = isShow
            }
        }
    }
    
    /// Displays an error banner with the provided error message.
    /// - Parameter error: The error message to display in the banner.
    func showBannerError(_ error: String) {
        self.infoContent = { [weak self] in
            guard let self = self else { return AnyView(Text("")) }
            return self.errorDefault(error)
        }
        self.showBanner(isShow: true)
    }
}


private extension VerticalAlignment {
    struct CenterIconAlignment: AlignmentID {
        /// Returns the top edge value from the given view dimensions.
        /// - Parameter context: The view dimensions context.
        /// - Returns: The value corresponding to the top edge.
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }
    
    static let centerIconAlignment = VerticalAlignment(CenterIconAlignment.self)
}
