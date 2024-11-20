import SwiftUI

private struct Data {
  let title: String
  let description: String
}

struct Carousel: View {
  private let data = [
    Data(
      title: "Get your first token now",
      description: "Let's grow your property"),
    Data(title: "Join the latest IDO today?", description: "Get your tokens early"),
    Data(title: "Join the latest IDO today?", description: "Get your tokens early"),
  ]

  @State private var scrollIndex: Int?

  var body: some View {
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
                Text(item.title).font(.labelMediumSecondary)
                Spacer().frame(height: Spacing.xs)
                Text(item.description).font(.paragraphXSmall)
                  .foregroundColor(
                    .appInteractiveTentPrimarySub)
              }
              .padding(.top, Spacing.xl)
              .padding(.leading, Spacing.xl)

              Spacer()

              Image("coming-soon").resizable().frame(
                width: 98, height: 98)
            }.containerRelativeFrame(.horizontal)
              .scrollTransition(.animated, axis: .horizontal) {
                content, phase in
                content.opacity(phase.isIdentity ? 1.0 : 0)
              }
          }
        }.scrollTargetLayout()
      }.scrollPosition(id: $scrollIndex).scrollTargetBehavior(.paging)
        .disableBounces()
    }
    .cornerRadius(BorderRadius._3xl)
    .overlay(
      RoundedRectangle(cornerRadius: BorderRadius._3xl)
        .stroke(
          Color.appBorderPrimarySub,
          lineWidth: 1)
    )
    .padding(0)
    .fixedSize(horizontal: false, vertical: true)

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
        Rectangle().frame(
          width: indicator == index ? 12 : 6, height: 4
        ).foregroundColor(
          indicator == index
            ? .appSecondary : .appSurfacePrimaryDefault
        ).cornerRadius(BorderRadius.full)
          .animation(.easeInOut(duration: 0.3), value: scrollIndex)
      }
    }
  }
}

struct Carousel_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      Carousel()
    }.padding(20)
  }
}
