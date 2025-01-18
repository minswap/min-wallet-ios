import SwiftUI


struct PartialRoundedBorder: Shape {
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Top edge with rounded corners
        let topLeft = CGPoint(x: rect.minX, y: rect.minY + cornerRadius)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY + cornerRadius)
        
        path.move(to: topLeft)
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        // Top right vertical line
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + lineWidth))
        
        // Top left vertical line
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + lineWidth))
        
        return path
    }
}
