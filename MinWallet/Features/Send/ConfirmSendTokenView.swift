import SwiftUI
import FlowStacks


struct ConfirmSendTokenView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Confirmation")
                        .font(.titleH5)
                        .foregroundStyle(.colorBaseTent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, .lg)
                        .padding(.bottom, .xl)
                        .padding(.horizontal, .xl)
                    HStack(spacing: 8) {
                        Text("235.789")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)

                        Spacer()
                        Image(.ada)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("ADA")
                            .font(.labelSemiSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .padding(.horizontal, .xl)
                    .padding(.top, .lg)
                    HStack(spacing: 8) {
                        Text("235.789")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)

                        Spacer()
                        Image(.ada)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("MIN")
                            .font(.labelSemiSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .padding(.horizontal, .xl)
                    .padding(.top, .lg)
                    HStack(spacing: 8) {
                        Text("235.789")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)

                        Spacer()
                        Image(.ada)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("LIQ")
                            .font(.labelSemiSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .padding(.horizontal, .xl)
                    .padding(.top, .lg)

                    Color.colorBorderPrimarySub
                        .frame(height: 1)
                        .padding(.horizontal, .xl)
                        .padding(.vertical, .xl)
                    HStack {
                        Text("To")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                        Image(.icCopy)
                            .resizable()
                            .frame(width: 16, height: 16)
                        Spacer()
                    }
                    .padding(.horizontal, .xl)
                    Text("addr1qxjd7yhl8d8aezz0spg4zghgtn7rx7zun7fkekrtk2zvw9vsxg93khf9crelj4wp6kkmyvarlrdvtq49akzc8g58w9cq5svq4r")
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .padding(.horizontal, .xl)
                        .padding(.top, .lg)

                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Select your route")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                        }
                        .padding(.horizontal, .xl)
                        .padding(.top, .xl)
                        HStack {
                            Text("Best router")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                            Spacer()
                        }
                        .padding(.horizontal, .xl)
                        .padding(.top, .lg)
                        Color.colorBorderPrimarySub
                            .frame(height: 1)
                            .padding(.vertical, .xl)
                        HStack(spacing: 4) {
                            Text("Transaction Id")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Text("178b...ac17")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                            Image(.icCopy)
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        .padding(.horizontal, .xl)
                        .padding(.bottom, .lg)
                        HStack(spacing: 4) {
                            Text("Tx Size")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Text("11817")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                        }
                        .padding(.horizontal, .xl)
                        .padding(.bottom, .lg)
                        HStack(spacing: 4) {
                            Text("Fee")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Text("0.3 ₳")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                        }
                        .padding(.horizontal, .xl)
                        .padding(.bottom, .xl)

                        Text("A small fee (max 0.3₳) may be deducted from your batcher fee for automatically cancellation.")
                            .font(.paragraphXMediumSmall)
                            .foregroundStyle(.colorInteractiveToneWarning)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.md)
                            .background(RoundedRectangle(cornerRadius: 8).fill(.colorSurfaceWarningDefault))
                            .padding(.horizontal, .xl)
                            .padding(.bottom, .xl)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
                    .padding(.xl)
                }
            }

            Spacer()
            CustomButton(title: "Next") {
                navigator.presentSheet(
                    .sendToken(
                        .signContract(onSuccess: {

                        })))
            }
            .frame(height: 56)
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
    ConfirmSendTokenView()
}
