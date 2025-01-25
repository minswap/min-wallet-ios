import SwiftUI
import FlowStacks
import Combine


struct ToWalletAddressView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @StateObject
    private var viewModel: ToWalletAddressViewModel = .init()
    @State
    private var rotateDegree: CGFloat = 0

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
                let combinedBinding = Binding<Bool>(
                    get: { viewModel.isChecking != true },
                    set: { _ in }
                )
                CustomTextField(
                    text: $viewModel.address,
                    enableTextView: combinedBinding,
                    font: .labelSmallSecondary ?? .systemFont(ofSize: 14),
                    textColor: .colorBaseTent,
                    placeHolderTextColor: .colorInteractiveTentPrimarySub,
                    placeHolderText: "Enter address or ADAHandle",
                    onCommit: {}
                )
                .padding(.horizontal, .xl)
                .onChange(of: viewModel.address) { newValue in
                    viewModel.address = newValue.replacingOccurrences(of: " ", with: "")
                }
            }
            errorTypeView
            itemAddressAda

            Spacer()
            HStack(spacing: .md) {
                Spacer()
                if case .handleNotResolved = viewModel.errorType {
                    ZStack {
                        Text("Check")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                            .opacity(viewModel.isChecking == true ? 0 : 1)
                        Image(.icLoading)
                            .resizable()
                            .fixSize(20)
                            .rotationEffect(Angle(degrees: rotateDegree))
                            .onAppear(perform: {
                                withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                                    self.rotateDegree = 360
                                }
                            })
                            .opacity(viewModel.isChecking == true ? 1 : 0)
                    }
                    .frame(width: 85, height: 36)
                    .background(.colorBaseBackground)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorInteractiveTentSecondarySub, lineWidth: 1)
                    })
                    .contentShape(.rect)
                    .onTapGesture {
                        guard viewModel.isChecking != true else { return }
                        hideKeyboard()
                        viewModel.checkAddress()
                    }
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
                            viewModel.reset()
                            viewModel.address = copied.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }
                    .disabled(viewModel.isChecking == true)
            }
            .padding(.bottom, 40)
            .padding(.horizontal, .xl)

            let combinedBinding = Binding<Bool>(
                get: {
                    if viewModel.isChecking == true {
                        return false
                    }
                    return viewModel.adaAddress != nil || !viewModel.address.isEmpty && viewModel.errorType == nil
                },
                set: { _ in }
            )
            CustomButton(title: "Next", isEnable: combinedBinding) {
                guard viewModel.isChecking != true else { return }
                navigator.push(.sendToken(.confirm))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        //.allowsHitTesting(!(viewModel.isChecking == true))
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
            VStack(alignment: .leading, spacing: 30) {
                HStack(alignment: .top, spacing: 6) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(.icAdahandle)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(adaAddress.name)
                                .lineLimit(1)
                                .font(.paragraphSemi)
                                .foregroundStyle(.colorInteractiveToneHighlight)
                        }
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
                            viewModel.reset()
                        }
                }
                .padding(.horizontal, .xl)
                HStack(alignment: .top, spacing: Spacing.md) {
                    Image(.icWarningYellow)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("If this ADA Handle has a typo or belongs to a different person your fund will be lost")
                        .lineLimit(nil)
                        .font(.paragraphXSmall)
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

    @ViewBuilder
    private var errorTypeView: some View {
        if let errorType = viewModel.errorType {
            if case .handleNotResolved = errorType {
                HStack(spacing: 8) {
                    Image(.icHandleNameNotResolve)
                        .fixSize(16)
                    Text(errorType.errorDesc)
                        .font(.paragraphXSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                }
                .padding(.md)
                .frame(minHeight: 32)
                .background(
                    RoundedRectangle(cornerRadius: .lg).fill(.colorSurfacePrimaryDefault)
                )
                .padding(.top, .lg)
                .padding(.horizontal, .xl)

            } else {
                HStack(spacing: 4) {
                    Image(.icWarning)
                        .fixSize(16)
                    Text(errorType.errorDesc)
                        .font(.paragraphXSmall)
                        .foregroundStyle(.colorInteractiveDangerTent)
                }
                .padding(.top, .lg)
                .padding(.horizontal, .xl)
            }
        }
    }
}

#Preview {
    ToWalletAddressView()
}
