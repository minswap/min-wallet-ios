import SwiftUI
import FlowStacks


struct DisconnectWalletView: View {
    enum DisconnectType {
        case logout
        case delete
    }

    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @State
    private var disconnectType: DisconnectType = .logout
    @State
    private var isConfirm: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Disconnect wallet")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            HStack(alignment: .top, spacing: .md) {
                Image(disconnectType == .logout ? .icChecked : .icRadioUncheck)
                    .resizable()
                    .frame(width: 24, height: 24)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Logout")
                        .font(.titleH7)
                        .foregroundStyle(.colorBaseTent)
                    Text("Allows you to reconnect your wallet without having to re-enter your seed phrases.")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                }
                Spacer()
            }
            .padding(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(disconnectType == .logout ? .colorInteractiveTentSecondarySub : .colorBorderPrimaryDefault, lineWidth: disconnectType == .logout ? 2 : 1))
            .contentShape(.rect)
            .padding(.horizontal, .xl)
            .padding(.top, .lg)
            .onTapGesture {
                disconnectType = .logout
            }
            HStack(alignment: .top, spacing: .md) {
                Image(disconnectType == .delete ? .icChecked : .icRadioUncheck)
                    .resizable()
                    .frame(width: 24, height: 24)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Delete")
                        .font(.titleH7)
                        .foregroundStyle(.colorBaseTent)
                    Text("You have to re-enter your seed phrases when reconnecting your wallet.")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                }
                Spacer()
            }
            .padding(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(disconnectType == .delete ? .colorInteractiveTentSecondarySub : .colorBorderPrimaryDefault, lineWidth: disconnectType == .logout ? 2 : 1)).contentShape(.rect)
            .padding(.horizontal, .xl)
            .padding(.top, .lg)
            .onTapGesture {
                disconnectType = .delete
            }

            Spacer()
            if disconnectType == .delete {
                HStack(alignment: .center, spacing: .xl) {
                    Image(isConfirm ? .icSquareCheckBox : .icSquareUncheckBox)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("In case you forgot your seed phrase, Minswap can not retrieve your wallet once you click Disconnect button.")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.xl)
                .contentShape(.rect)
                .onTapGesture {
                    isConfirm.toggle()
                }
            }
            CustomButton(title: "Disconnect", variant: .other(textColor: .colorBaseTent, backgroundColor: .colorInteractiveDangerDefault, borderColor: .clear)) {
                //TODOZ: cuongnv234 disconnect
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
            .disabled(!isConfirm && disconnectType == .delete)
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                }))
    }
}

#Preview {
    DisconnectWalletView()
}
