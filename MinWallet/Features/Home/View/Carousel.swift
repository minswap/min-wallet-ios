import SwiftUI

private struct Data {
    let title: String
    let description: String
}

struct Carousel: View {
    private let data = [
        Data(
            title: "Get your first token now",
            description: "Let's grow your property"
        ),
        Data(title: "Join the latest IDO today?", description: "Get your tokens early"),
        Data(title: "Join the latest IDO today?", description: "Get your tokens early"),
    ]

    @State private var scrollIndex: Int?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                IndicatorView(count: data.count, scrollIndex: scrollIndex)
                    .offset(x: Spacing.xl, y: -Spacing.xl)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<data.count, id: \.self) {
                            index in
                            let item = data[index]
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.labelMediumSecondary)
                                        .foregroundStyle(.colorBaseTent)
                                    Spacer()
                                        .frame(height: Spacing.xs)
                                    Text(item.description).font(.paragraphXSmall)
                                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                                }
                                .padding(.top, Spacing.xl)
                                .padding(.leading, Spacing.xl)

                                Spacer()

                                Image(.comingSoon).resizable()
                                    .frame(
                                        width: 98,
                                        height: 98
                                    )
                            }
                            .frame(
                                width: geometry.size.width,  // 80% of container's width
                                height: geometry.size.height  // 20% of container's height
                            )
                            //                            .position(
                            //                                x: geometry.size.width / 2, // Center horizontally
                            //                                y: geometry.size.height / 2 // Center vertically
                            //                            )
                            //                        .containerRelativeFrame(.horizontal)
                            //                                                    .scrollTransition(.animated, axis: .horizontal) {
                            //                                                        content, phase in
                            //                                                        content.opacity(phase.isIdentity ? 1.0 : 0)
                            //                                                    }
                        }
                    }
                    //                .scrollTargetLayout()
                }
                .disableBounces()
            }
            .cornerRadius(BorderRadius._3xl)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius._3xl).stroke(.colorBorderPrimarySub, lineWidth: 1)
            )
            .padding(0)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct IndicatorView: View {
    let count: Int
    let scrollIndex: Int?

    var body: some View {
        HStack(spacing: Spacing.xs) {
            ForEach(0..<count, id: \.self) {
                indicator in
                let index = scrollIndex ?? 0
                Rectangle()
                    .frame(
                        width: indicator == index ? 12 : 6,
                        height: 4
                    )
                    .foregroundColor(
                        indicator == index
                            ? .colorInteractiveTentSecondarySub : .colorSurfacePrimaryDefault
                    )
                    .cornerRadius(BorderRadius.full)
                    .animation(.easeInOut(duration: 0.3), value: scrollIndex)
            }
        }
    }
}


#Preview {
    Carousel()
        .frame(height: 150)
}
