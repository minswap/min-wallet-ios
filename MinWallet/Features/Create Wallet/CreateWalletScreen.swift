import SwiftUI

private enum Step {
  case beforeYouStart
  case revealingSeedPharse
  case reInputSeedPhrase
  case enterUsernameAndPassword
}

struct CreateWalletScreen: View {
  @State private var step: Step = .beforeYouStart

  private var title: String {
    switch step {
    case .beforeYouStart: return "Create new wallet"
    case .revealingSeedPharse: return "Create new wallet"
    case .reInputSeedPhrase: return "Re-input your seedphrase"
    case .enterUsernameAndPassword: return "Enter username and password"
    }
  }

  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        VStack {
          HStack {
            AppIconButton(icon: .arrowLeft, action: toPreviousStep)
            Spacer()
          }.padding(.horizontal, Spacing.xl).padding(.vertical, Spacing.xs)

          Group {
            Text(title).font(.labelXLargePrimary).foregroundColor(.appTentPrimary)
              .frame(
                maxWidth: .infinity, alignment: .leading)
          }.padding(.top, Spacing.lg).padding(.horizontal, Spacing.xl).padding(.bottom, Spacing.xl)

          switch step {
          case .beforeYouStart:
            BeforeYouStart(onNext: toNextStep)
          case .revealingSeedPharse:
            RevealSeedPhrase(onBack: toPreviousStep, onNext: toNextStep)
          case .reInputSeedPhrase:
            ReInputSeedPhrase(onBack: toPreviousStep, onNext: toNextStep)
          case .enterUsernameAndPassword:
            VStack {
              Text("Yeah....")
            }
          }
        }.frame(minHeight: geometry.size.height)
      }.disableBounces()
    }
  }

  private func toPreviousStep() {
    switch step {
    case .beforeYouStart:
      break
    case .revealingSeedPharse:
      step = .beforeYouStart
    case .reInputSeedPhrase:
      step = .revealingSeedPharse
    case .enterUsernameAndPassword:
      step = .enterUsernameAndPassword
    }
  }

  private func toNextStep() {
    switch step {
    case .beforeYouStart:
      step = .revealingSeedPharse

    case .revealingSeedPharse:
      step = .reInputSeedPhrase

    case .reInputSeedPhrase:
      step = .enterUsernameAndPassword

    case .enterUsernameAndPassword:
      break

    }
  }
}

struct CreateWalletScreen_Previews: PreviewProvider {
  static var previews: some View {
    CreateWalletScreen()
  }
}
