import SwiftUI

struct TestView: View {
    enum PopoverTarget: Hashable {
        case text1, text2, text3
        
        var anchorForPopover: UnitPoint {
            switch self {
                case .text1: .top
                case .text2: .bottom
                case .text3: .bottom
            }
        }
    }
    
    @State private var popoverTarget: PopoverTarget?
    @Namespace private var nsPopover
    
    private func showPopover(target: PopoverTarget) {
        if popoverTarget != nil {
            popoverTarget = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                popoverTarget = target
            }
        } else {
            popoverTarget = target
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            popoverTarget = nil
        }
    }
    
    @ViewBuilder
    private var customPopover: some View {
        if let popoverTarget {
            Text("Popover for \(popoverTarget)")
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .shadow(radius: 5)
                )
                .foregroundColor(.black)
                .matchedGeometryEffect(
                    id: popoverTarget,
                    in: nsPopover,
                    properties: .position,
                    anchor: popoverTarget.anchorForPopover,
                    isSource: false
                )
                .transition(.opacity.combined(with: .scale))
                .zIndex(1)
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 60) {
                    Group {
                        HStack {
                            Text("Text 1")
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 50)
                            Text("Text 145454545")
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .onTapGesture { showPopover(target: .text1) }
                                .matchedGeometryEffect(id: PopoverTarget.text1, in: nsPopover, anchor: .bottom)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 50)
                        }
                        Text("Text 2")
                            .padding()
                            .background(.orange)
                            .foregroundColor(.white)
                            .onTapGesture { showPopover(target: .text2) }
                            .matchedGeometryEffect(id: PopoverTarget.text2, in: nsPopover, anchor: .topLeading)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 50)
                        
                        Text("Text 3")
                            .padding()
                            .background(.green)
                            .foregroundColor(.white)
                            .onTapGesture { showPopover(target: .text3) }
                            .matchedGeometryEffect(id: PopoverTarget.text3, in: nsPopover, anchor: .top)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.vertical, 80)
                .padding(.horizontal, 20)
            }
            
            customPopover
        }
        .contentShape(Rectangle())
        .onTapGesture {
            popoverTarget = nil
        }
    }
}
