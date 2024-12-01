import SwiftUI

extension View {
  func disableBounces() -> some View {
    modifier(DisableBouncesModifier())
  }
}

struct DisableBouncesModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .onAppear {
        UIScrollView.appearance().bounces = false
      }
      .onDisappear {
        UIScrollView.appearance().bounces = true
      }
  }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func placeholder(
        _ text: String,
        font: Font = .paragraphSmall,
        when shouldShow: Bool,
        alignment: Alignment = .leading) -> some View {
            
            placeholder(when: shouldShow, alignment: alignment) { Text(text).font(font).foregroundColor(.colorInteractiveTentPrimarySub) }
        }
}


//TODO: Cuongnv check have value sau
extension EnvironmentObject {
    var hasValue: Bool {
        !String(describing: self).contains("_store: nil")
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
