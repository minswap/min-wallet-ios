import SwiftUI


struct CustomButton: View {
    var title     : LocalizedStringKey
    var variant   : Varriant        = .primary
    var frameType : FrameType       = .matchParent
    var icon      : ImageResource?  = nil
    var iconRight : ImageResource?  = nil
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
            .background(variant.backgroundColor)
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
            icon: .icReceive, action: { })
        .frame(height: 40)
        CustomButton(
            title: "Swap", 
            variant: .secondary,
            frameType: .matchParent,
            icon: .icSend, iconRight: .icUp, action: { })
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
                return .color050B18
            case .secondary:
                return .color001947FFFFFF78
            case .other(let textColor,_ , _):
                return textColor
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return .color89AAFF
            case .secondary:
                return .clear
            case .other(_, let backgroundColor , _):
                return backgroundColor
            }
        }
        
        var borderColor: Color {
            switch self {
            case .primary:
                return .clear
            case .secondary:
                return .color00194770DAE2FF56
            case .other(_,_ , let borderColor):
                return borderColor
            }
        }
    }
    
    enum FrameType {
        case wrapContent
        case matchParent
    }
}
