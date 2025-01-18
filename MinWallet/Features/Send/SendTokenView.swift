import SwiftUI
import FlowStacks


struct SendTokenView: View {
    enum Focusable: Hashable {
        case none
        case row(id: String)
    }

    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @FocusState
    private var focusedField: Focusable?

    @State
    private var amount: String = ""
    @StateObject
    private var viewModel = SendTokenViewModel()

    @EnvironmentObject
    var tokenManager: TokenManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                LazyVStack(
                    spacing: 0,
                    content: {
                        Text("You want to send:")
                            .font(.titleH5)
                            .foregroundStyle(.colorBaseTent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, .lg)
                            .padding(.bottom, .xl)
                            .padding(.horizontal, .xl)
                        /*
                        HStack(spacing: .md) {
                            AmountTextField(value: $viewModel.amountDefault)
                                .focused($focusedField, equals: Focusable.row(id: "-1"))
                            Text("Max")
                                .font(.labelMediumSecondary)
                                .foregroundStyle(.colorInteractiveToneHighlight)
                                .onTapGesture {

                                }
                            Image(.ada)
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("ADA")
                                .font(.labelSemiSecondary)
                                .foregroundStyle(.colorBaseTent)
                        }
                        .padding(.horizontal, .xl)
                        .padding(.vertical, .lg)
                        .overlay(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
                        .padding(.horizontal, .xl)
                        .padding(.top, .lg)
                         */
                        ForEach(0..<viewModel.tokens.count, id: \.self) { index in
                            let item = viewModel.tokens[index]
                            let amountBinding = Binding<String>(
                                get: { viewModel.tokens[index].amount },
                                set: { newValue in
                                    viewModel.tokens[index].amount = newValue
                                }
                            )
                            HStack(spacing: .md) {
                                AmountTextField(value: amountBinding, maxValue: item.token.amount)
                                    .focused($focusedField, equals: .row(id: item.token.uniqueID))
                                Text("Max")
                                    .font(.labelMediumSecondary)
                                    .foregroundStyle(.colorInteractiveToneHighlight)
                                    .onTapGesture {
                                        viewModel.tokens[index].amount = item.token.amount.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: 15)
                                    }
                                TokenLogoView(currencySymbol: item.token.currencySymbol, tokenName: item.token.tokenName, isVerified: false, size: .init(width: 24, height: 24))
                                Text(item.token.adaName)
                                    .font(.labelSemiSecondary)
                                    .foregroundStyle(.colorBaseTent)
                            }
                            .padding(.horizontal, .xl)
                            .padding(.vertical, .lg)
                            .overlay(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
                            .padding(.horizontal, .xl)
                            .padding(.top, .lg)
                        }

                        Button(
                            action: {
                                navigator.presentSheet(
                                    .selectToken(
                                        tokensSelected: viewModel.tokens.map({ $0.token }),
                                        onSelectToken: { tokens in
                                            viewModel.addToken(tokens: tokens)
                                        }))
                            },
                            label: {
                                Text("Add Token")
                                    .font(.labelSmallSecondary)
                                    .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(content: {
                                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfacePrimaryDefault)
                                    })
                            }
                        )
                        .frame(height: 36)
                        .padding(.horizontal, .xl)
                        .padding(.top, .md)
                        .buttonStyle(.plain)
                    })
            }
            Spacer()
            let combinedBinding = Binding<Bool>(
                get: { viewModel.tokens.allSatisfy { !$0.amount.isBlank } },
                set: { _ in }
            )
            CustomButton(title: "Next", isEnable: combinedBinding) {
                navigator.push(.sendToken(.toWallet))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    focusedField = nil
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
}

#Preview {
    SendTokenView()
        .environmentObject(TokenManager.shared)
}
