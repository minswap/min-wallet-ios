import SwiftUI
import FlowStacks


struct ToWalletAddressView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @FocusState
    private var focusedField: Bool
    @StateObject
    private var viewModel: ToWalletAddressViewModel = .init()

    @State
    private var angle: Double = 0.0
    @State
    private var isAnimating = false
    private var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("To wallet address:")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)

            if viewModel.adaAddress == nil {
                TextField("", text: $viewModel.address)
                    .placeholder("Search, enter address or ADAHandle", when: viewModel.address.isEmpty)
                    .lineLimit(1)
                    .focused($focusedField)
                    .padding(.horizontal, focusedField ? 0 : .xl)
                    .padding(.vertical, .lg)
                    .overlay(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorBorderPrimaryDefault, lineWidth: focusedField ? 0 : 1))
                    .padding(.horizontal, .xl)
                    .padding(.top, focusedField ? 0 : .lg)
            }
            itemAddressAda

            Spacer()
            HStack(spacing: .md) {
                Spacer()
                ZStack {
                    if viewModel.isChecking == true {
                        Image(.icLoading)
                            .resizable()
                            .fixSize(20)
                            .rotationEffect(Angle(degrees: isAnimating ? 360.0 : 0.0))
                            .animation(foreverAnimation)
                            .onAppear {
                                isAnimating = true
                            }
                    } else {
                        Text("Check")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                    }
                }
                .frame(width: 85, height: 36)
                .background(.colorBaseBackground)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorInteractiveTentSecondarySub, lineWidth: 1)
                })
                .contentShape(.rect)
                .onTapGesture {
                    guard viewModel.isChecking != true else { return }
                    viewModel.checkAddress()
                }
                Text("Paste")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                    .padding(.horizontal, 20)
                    .frame(height: 36)
                    .background(.colorBaseBackground)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorInteractiveTentSecondarySub, lineWidth: 1)
                    })
                    .contentShape(.rect)
                    .onTapGesture {
                        if let copied = UIPasteboard.general.string, !copied.isEmpty {
                            viewModel.address = copied
                        }
                    }
            }
            .padding(.bottom, 40)
            .opacity(focusedField ? 1 : 0)

            let combinedBinding = Binding<Bool>(
                get: { viewModel.adaAddress != nil },
                set: { _ in }
            )
            CustomButton(title: "Next", isEnable: combinedBinding) {
                navigator.push(.sendToken(.confirm))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .allowsHitTesting(!(viewModel.isChecking == true))
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    focusedField = false
                }
                .foregroundStyle(.colorLabelToolbarDone)
            }
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                }))
    }

    @ViewBuilder
    private var itemAddressAda: some View {
        if let adaAddress = viewModel.adaAddress, let isChecking = viewModel.isChecking, !isChecking {
            VStack(alignment: .leading, spacing: 24) {
                HStack(alignment: .top, spacing: 6) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(adaAddress.name)
                            .lineLimit(1)
                            .font(.paragraphSemi)
                            .foregroundStyle(.colorInteractiveToneHighlight)
                        Text(adaAddress.address)
                            .lineSpacing(4)
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                    }
                    Image(.icDeleteAddress)
                        .resizable()
                        .fixSize(24)
                        .contentShape(.rect)
                        .onTapGesture {
                            viewModel.isChecking = nil
                            viewModel.adaAddress = nil
                        }
                }
                .padding(.horizontal, .xl)
                HStack(spacing: Spacing.md) {
                    Image(.icWarningYellow)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("If this ADA Handle has a typo or belongs to a different person your fund will be lost")
                        .lineLimit(nil)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveToneWarning)
                }
                .padding(.md)
                .background(
                    RoundedRectangle(cornerRadius: .lg).fill(.colorSurfaceWarningDefault)
                )
                .frame(minHeight: 32)
                .padding(.horizontal, .xl)
            }
            .padding(.top, .lg)
        }
    }
}

#Preview {
    ToWalletAddressView()
}
