import SwiftUI
import FlowStacks


struct AuthenticationSettingView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Authentication")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            Text("Unlock your wallet using Face ID recognition or a password.")
                .font(.paragraphSmall)
                .foregroundStyle(.colorBaseTent)
                .padding(.horizontal, .xl)
                .padding(.top, .lg)
                .padding(.bottom, ._3xl)
            
            HStack {
                Text("FaceID")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveToneHighlight)
                Spacer()
                Image(.icChecked)
            }
            .padding(.horizontal, .xl)
            .frame(height: 52)
            .contentShape(.rect)
            .onTapGesture {
                
            }
            HStack {
                Text("Password")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorBaseTent)
                Spacer()
//                Image(.icChecked)
            }
            .padding(.horizontal, .xl)
            .frame(height: 52)
            .contentShape(.rect)
            .onTapGesture {
                
            }
            
            Spacer()
        }
        .modifier(BaseContentView(
            screenTitle: " ",
            actionLeft: {
                navigator.pop()
            }))
    }
}

#Preview {
    AuthenticationSettingView()
}
