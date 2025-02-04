import SwiftUI


//TODO: Hub for error, loading success... etc
class HUDState: ObservableObject {
    @Published
    private(set) var msg: String = ""
    @Published
    var isPresented: Bool = false

    var onAction: (() -> Void)?

    init() {}

    @Published
    var isShowLoading: Bool = false

    func showMsg(msg: String, onAction: (() -> Void)? = nil) {
        self.msg = msg
        self.onAction = onAction
        self.isPresented = true
    }

    func showLoading(isShow: Bool) {
        withAnimation {
            isShowLoading = isShow
        }
    }
}
