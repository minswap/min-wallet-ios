import SwiftUI


struct SecurePasswordTextField: View {
    @State private var visibleInput: String = ""
    @State private var isSecured: Bool = true
    
    let placeHolder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("", text: $visibleInput)
                .font(.paragraphSmall)
                .placeholder(placeHolder, when: visibleInput.isEmpty)
                .foregroundStyle(.colorBaseTent)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 50))
                .onChange(of: visibleInput) { newValue in
                    guard isSecured else { text = newValue; return}
                    if newValue.count >= text.count {
                        let newItem = newValue.filter{ $0 != Character("*") }
                        text.append(newItem)
                    } else {
                        text.removeLast()
                    }
                    
                    visibleInput = String(newValue.map { _ in Character("*")})
                }
        }
        .background {
            ZStack {
                HStack {
                    Spacer()
                    
                    Button {
                        isSecured.toggle()
                        visibleInput = isSecured ? String(text.map { _ in Character("*")}) : text
                    } label: {
                        Image(isSecured ? .icEye : .icBack)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
    }
}
