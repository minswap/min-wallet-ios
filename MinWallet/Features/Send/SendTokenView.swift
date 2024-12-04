import SwiftUI
import FlowStacks


struct SendTokenView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @FocusState
    private var focusedField: Bool

    @State
    private var amount: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("You want to send:")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)

            HStack(spacing: .md) {
                TextField("", text: $amount)
                    .placeholder("0.0", when: amount.isEmpty)
                    .lineLimit(1)
                    .focused($focusedField)
                Text("Max")
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
            Button(
                action: {
                    navigator.presentSheet(.selectToken)
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
            Spacer()
            CustomButton(title: "Next") {
                navigator.push(.sendToken(.toWallet))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
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
}

#Preview {
    SendTokenView()
}
