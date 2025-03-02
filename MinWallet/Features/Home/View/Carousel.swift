import SwiftUI

private struct Data {
    let title: String
    let description: String
}

struct CarouselView: View {
    private let data = [
        Data(
            title: "Get your first token now",
            description: "Let's grow your property"),
        Data(title: "Join the latest IDO today?", description: "Get your tokens early"),
        Data(title: "Join the latest IDO today?", description: "Get your tokens early"),
    ]

    @State private var scrollIndex: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                IndicatorView(count: data.count, scrollIndex: scrollIndex)
                    .offset(x: Spacing.xl, y: -Spacing.xl)
                TabView(selection: $scrollIndex) {
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
                                    width: 98, height: 98)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: scrollIndex) { newValue in
                    if newValue == data.count {
                        scrollIndex = 0
                    } else if newValue == -1 {
                        scrollIndex = data.count - 1
                    }
                }
            }
            .cornerRadius(BorderRadius._3xl)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius._3xl).stroke(.colorBorderPrimarySub, lineWidth: 1)
            )
            .padding(0)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                withAnimation {
                    scrollIndex = (scrollIndex + 1) % data.count
                }
            }
        }
    }
}

private struct IndicatorView: View {
    let count: Int
    let scrollIndex: Int

    var body: some View {
        HStack(spacing: Spacing.xs) {
            ForEach(0..<count, id: \.self) {
                indicator in
                let index = scrollIndex
                Rectangle()
                    .frame(
                        width: indicator == index ? 12 : 6, height: 4
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
    VStack(spacing: 0) {
        CarouselView()
            .frame(height: 98)
            .padding(.horizontal, .xl)

    }
}
