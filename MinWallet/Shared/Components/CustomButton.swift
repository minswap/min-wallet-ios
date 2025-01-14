import SwiftUI


struct CustomButton: View {
    var title: LocalizedStringKey
    var variant: Varriant = .primary
    var frameType: FrameType = .matchParent
    var icon: ImageResource? = nil
    var iconRight: ImageResource? = nil

    var action: () -> Void

    @Binding
    private var isEnable: Bool

    init(
        title: LocalizedStringKey,
        variant: Varriant = .primary,
        frameType: FrameType = .matchParent,
        icon: ImageResource? = nil,
        iconRight: ImageResource? = nil,
        isEnable: Binding<Bool> = .constant(true),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.frameType = frameType
        self.icon = icon
        self.iconRight = iconRight
        self.action = action
        self._isEnable = isEnable
    }

    var body: some View {
        Button(action: {
            guard isEnable else { return }
            action()
        }) {
            HStack(spacing: Spacing.md) {
                if let icon = icon {
                    Image(icon)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text(title)
                    .font(.labelMediumSecondary)
                    .foregroundStyle(variant.textColor)
                    .lineLimit(1)
                    .layoutPriority(1)
                if let iconRight = iconRight {
                    Image(iconRight)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .frame(maxWidth: frameType == .matchParent ? .infinity : nil, maxHeight: .infinity)
            .padding(.horizontal, 10)
            .background(isEnable ? variant.backgroundColor : .colorSurfacePrimaryDefault)
            .shadow(radius: 50).cornerRadius(BorderRadius.full)
            .overlay(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(variant.borderColor, lineWidth: 1))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        CustomButton(
            title: "Swap",
            variant: .primary,
            icon: .icReceive, action: {}
        )
        .frame(height: 40)
        CustomButton(
            title: "Swap",
            variant: .secondary,
            frameType: .matchParent,
            icon: .icSend, iconRight: .icUp, action: {}
        )
        .frame(height: 40)
    }
    .padding()
}


extension CustomButton {
    enum Varriant {
        case primary
        case secondary
        case other(textColor: Color, backgroundColor: Color, borderColor: Color)

        var textColor: Color {
            switch self {
            case .primary:
                return .colorBaseTentNoDarkMode
            case .secondary:
                return .colorInteractiveTentSecondaryDefault
            case .other(let textColor, _, _):
                return textColor
            }
        }

        var backgroundColor: Color {
            switch self {
            case .primary:
                return .colorInteractiveTonePrimary
            case .secondary:
                return .clear
            case .other(_, let backgroundColor, _):
                return backgroundColor
            }
        }

        var borderColor: Color {
            switch self {
            case .primary:
                return .clear
            case .secondary:
                return .colorInteractiveTentSecondarySub
            case .other(_, _, let borderColor):
                return borderColor
            }
        }
    }

    enum FrameType {
        case wrapContent
        case matchParent
    }
}
