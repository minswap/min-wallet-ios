import SwiftUI
import FlowStacks


struct WalletAccountView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var userInfo: UserInfo
    @State
    private var isVerified: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(.icAvatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())

                if isVerified {
                    Circle()
                        .fill(.colorBaseBackground)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Image(.icVerifiedBadge)
                                .resizable()
                                .frame(width: 12, height: 12)
                        )
                        .overlay(
                            Circle()
                                .stroke(.colorSurfacePrimarySub, lineWidth: 1)
                        )
                        .position(x: 54, y: 54)
                }
            }
            .frame(width: 64, height: 64)
            .padding(.vertical, .lg)
            VStack(alignment: .center, spacing: 4) {
                HStack {
                    Text(userInfo.nickName)
                        .font(.labelSemiSecondary)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                        .lineLimit(1)
                    Text("W01...")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                        .padding(.horizontal, .lg)
                        .padding(.vertical, .xs)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfaceHighlightDefault)
                        )
                        .frame(height: 20)
                }
                Text(userInfo.walletAddress.shortenAddress)
                    .font(.paragraphXSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, .xl)
            VStack(spacing: 4) {
                HStack(spacing: .md) {
                    Text("Account #0")
                        .font(.paragraphSemi)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                    Spacer()
                    Text("Total Funds")
                        .font(.paragraphXSmall)
                        .foregroundStyle(.colorInteractiveToneWarning)
                }
                HStack(spacing: .md) {
                    Text("Active")
                        .font(.paragraphXSmall)
                        .foregroundStyle(.colorInteractiveToneWarning)
                    Spacer()
                    Text("29.253 ₳")
                        .font(.paragraphSemi)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                }
            }
            .padding(.xl)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(.colorBorderPrimarySub, lineWidth: 1))
            .contentShape(.rect)
            .padding(.horizontal, .xl)
            .padding(.top, .lg)
            CustomButton(
                title: "Edit nickname",
                variant: .secondary,
                action: {
                    navigator.push(.walletSetting(.editNickName))
                }
            )
            .frame(height: 36)
            .padding(.xl)
            HStack(spacing: .lg) {
                Image(.icLockPassword)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Change password")
                    .font(.paragraphSemi)
                    .foregroundStyle(.colorBaseTent)
                Spacer()
                Image(.icNext)
                    .frame(width: 20, height: 20)
            }
            .frame(height: 52)
            .padding(.horizontal, .xl)
            .contentShape(.rect)
            .onTapGesture {
                navigator.push(.walletSetting(.changePassword))
            }

            Spacer()

            CustomButton(
                title: "Disconnect",
                action: {
                    navigator.push(.walletSetting(.disconnectWallet))
                }
            )
            .frame(height: 36)
            .padding(.horizontal, .xl)
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
    WalletAccountView()
        .environmentObject(UserInfo())
}
