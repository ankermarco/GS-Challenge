//
//  RingView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 29/7/21.
//

import SwiftUI

// ViewData to build RingView
struct RingViewData: Identifiable {
    let id = UUID()
    let offset: Double
    let ratio: Double
    let color: Color
}

struct RingView: View {

    let viewData: [RingViewData]

    private func gradient(color: Color, offset: Double, ratio: Double) -> AngularGradient {
        
        return AngularGradient(
            gradient: Gradient(colors: [color.unsaturated, color]),
            center: .center,
            startAngle: .init(
                offset: offset,
                ratio: 0
            ),
            endAngle: .init(
                offset: offset,
                ratio: ratio
            )
        )
    }
    
    private func percentageText(from ratio: Double) -> String? {
        if ratio == 0 {
            return nil
        }
        return "\((ratio * 100).formatted(hasDecimals: false))%"
    }
    
    var body: some View {
        ZStack {
            ForEach(viewData) {
                PartialCircleShape(offset: $0.offset, ratio: $0.ratio)
                    .stroke(
                        gradient(color: $0.color, offset: $0.offset, ratio: $0.ratio),
                        style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                    )
                    .overlay(
                        PercentageText(
                            offset: $0.offset,
                            ratio: $0.ratio,
                            text: percentageText(from: $0.ratio)
                        )
                    )
                    .scaleEffect(0.85)
            }
        }
    }
}

extension RingView {
    struct PartialCircleShape: Shape {
        let offset: Double
        let ratio: Double
        
        func path(in rect: CGRect) -> Path {
            Path(offset: offset, ratio: ratio, in: rect)
        }
    }
    
    struct PercentageText: View {
        let offset: Double
        let ratio: Double
        let text: String?
        
        private func position(for geometry: GeometryProxy) -> CGPoint {
            let rect = geometry.frame(in: .local)
            let path = Path(offset: offset, ratio: ratio / 2.0, in: rect)
            return path.currentPoint ?? .zero
        }
        
        var body: some View {
            GeometryReader { geometry in
                if let text = text {
                    Text(text)
                        .percentage()
                        .position(position(for: geometry))
                }
            }
        }
    }
}

#if DEBUG
struct RingView_Previews: PreviewProvider {
    static var sampleRing: some View {
        ZStack {
            RingView.PartialCircleShape(offset: 0.0, ratio: 0.15)
                .stroke(
                    Color.red,
                    style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                )
            
            RingView.PartialCircleShape(offset: 0.15, ratio: 0.5)
                .stroke(
                    Color.green,
                    style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                )
                
            RingView.PartialCircleShape(offset: 0.65, ratio: 0.35)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                )
        }
    }
    
    static var previews: some View {
        VStack {
            sampleRing
                .scaledToFit()
            RingView(viewData: ModelData.sampleTransactions.map { RingViewData(offset: 0.2, ratio: 0.2, color: $0.category.color) }).scaledToFit()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
