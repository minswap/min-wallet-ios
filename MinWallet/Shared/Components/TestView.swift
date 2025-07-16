//import SwiftUI
//
//struct TokenSwapView: View {
//    var body: some View {
//        VStack(spacing: 0) {
//            HStack {
//                TokenBalanceView(
//                    iconName: "moon.fill",
//                    iconColor: .blue,
//                    amount: "235.789",
//                    symbol: "MIN"
//                )
//                Spacer()
//                TokenBalanceView(
//                    iconName: "moon.fill",
//                    iconColor: .blue,
//                    amount: "235.789",
//                    symbol: "MIN"
//                )
//            }
//            VStack(spacing: 0) {
//                SwapRouteView(
//                    percentage: "10%",
//                    intermediateIcon: "drop.fill",
//                    intermediateColor: .blue
//                )
//            }
//        }
//    }
//}
//
//struct TokenBalanceView: View {
//    let iconName: String
//    let iconColor: Color
//    let amount: String
//    let symbol: String
//    
//    var body: some View {
//        HStack(spacing: 0) {
//                // Token icon
//            Image(systemName: iconName)
//                .foregroundColor(iconColor)
//                .font(.system(size: 24, weight: .medium))
//            HStack(spacing: 2) {
//                Text(amount)
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(.primary)
//                
//                Text(symbol)
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.secondary)
//            }
//        }
//    }
//}
//
//struct SwapRouteView: View {
//    let percentage: String
//    let intermediateIcon: String
//    let intermediateColor: Color
//    var hasSecondIntermediate: Bool = false
//    
//    var body: some View {
//        HStack(spacing: 0) {
//            ZStack {
//                RoundedRectangle(cornerRadius: 25)
//                    .fill(Color.white)
//                    .frame(width: 80, height: 50)
//                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
//                
//                Text(percentage)
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(.primary)
//            }
//                // First dashed line
//            DashedLine()
//                .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
//                .frame(height: 2)
//                .frame(width: .infinity)
//            Image(systemName: "arrow.right")
//                .foregroundColor(.gray.opacity(0.5))
//                .font(.system(size: 16, weight: .medium))
//                // First intermediate token
//            TokenIcon(iconName: intermediateIcon, iconColor: intermediateColor)
//            
//                // Second dashed line
//            DashedLine()
//                .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
//                .frame(height: 2)
//                .frame(width: .infinity)
//            Image(systemName: "arrow.right")
//                .foregroundColor(.gray.opacity(0.5))
//                .font(.system(size: 16, weight: .medium))
//            if hasSecondIntermediate {
//                    // Second intermediate token (flame)
//                TokenIcon(iconName: "flame.fill", iconColor: .red)
//                
//                    // Third dashed line
//                DashedLine()
//                    .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
//                    .frame(height: 2)
//                    .frame(width: .infinity)
//                Image(systemName: "arrow.right")
//                    .foregroundColor(.gray.opacity(0.5))
//                    .font(.system(size: 16, weight: .medium))
//            }
//            
//                // Final ADA token
//            TokenIcon(iconName: "circle.grid.hex.fill", iconColor: .blue)
//            
//                // Final dashed line with arrow
//            HStack(spacing: 0) {
//                DashedLine()
//                    .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
//                    .frame(height: 2)
//                    .frame(width: .infinity)
//                
//                Image(systemName: "arrow.right")
//                    .foregroundColor(.gray.opacity(0.5))
//                    .font(.system(size: 16, weight: .medium))
//            }
//        }
//    }
//}
//
//struct TokenIcon: View {
//    let iconName: String
//    let iconColor: Color
//    
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(Color.white)
//                .frame(width: 40, height: 40)
//                .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
//            
//            Image(systemName: iconName)
//                .foregroundColor(iconColor)
//                .font(.system(size: 16, weight: .medium))
//        }
//    }
//}
//
//private struct DashedLine: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.move(to: CGPoint(x: 0, y: rect.midY))
//        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
//        return path
//    }
//}
//
//
//#Preview {
//    TokenSwapView()
//}
//
//
//    //                    SwapRouteView(
//    //                        percentage: "25%",
//    //                        intermediateIcon: "flame.fill",
//    //                        intermediateColor: .red
//    //                    )
//    //                    
//    //                    SwapRouteView(
//    //                        percentage: "65%",
//    //                        intermediateIcon: "bird.fill",
//    //                        intermediateColor: .blue,
//    //                        hasSecondIntermediate: true
////                    )
