import SwiftUI


//TODO: Hub for error, loading success... etc
@MainActor
class HUDState: ObservableObject {
    @Published
    private(set) var msg: String = ""
    @Published
    private(set) var title: LocalizedStringKey = ""
    @Published
    private(set) var okTitle: LocalizedStringKey = ""
    @Published
    var isPresented: Bool = false
    @Published
    var isShowLoading: Bool = false
    
    var onAction: (() -> Void)?
    
    init() {}
    
    /// Displays a message HUD with the specified title, message, OK button title, and optional action.
    /// - Parameters:
    ///   - title: The title to display in the HUD. Defaults to "Notice".
    ///   - msg: The message content to display.
    ///   - okTitle: The title for the OK button. Defaults to "Got it".
    ///   - onAction: An optional closure to execute when the user acknowledges the HUD.
    func showMsg(
        title: LocalizedStringKey = "Notice",
        msg: String,
        okTitle: LocalizedStringKey = "Got it",
        onAction: (() -> Void)? = nil
    ) {
        self.msg = msg
        self.title = title
        self.okTitle = okTitle
        self.onAction = onAction
        self.isPresented = true
    }
    
    /// Animates the display or hiding of the loading indicator.
    /// - Parameter isShow: A Boolean value indicating whether to show (`true`) or hide (`false`) the loading indicator.
    func showLoading(_ isShow: Bool) {
        withAnimation {
            isShowLoading = isShow
        }
    }
}
