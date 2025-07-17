import SwiftUI

struct GaugeView: View {
    let score: Int
    let category: String?
    @State private var animatedScore: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Background arc - semicircle
                SemicircleArc()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 16)
                    .frame(width: 280, height: 140)
                
                // Animated fill arc
                SemicircleArc()
                    .trim(from: 0, to: animatedScore / 100)
                    .stroke(Color.orange, lineWidth: 16)
                    .frame(width: 280, height: 140)
                    .animation(.easeOut(duration: 1.5), value: animatedScore)
                
                // Score labels positioned around the arc
                ZStack {
                    // Left label (0)
                    Text("0")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                        .position(x: 25, y: 125)
                    
                    // Top label (50)
                    Text("50")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                        .position(x: 140, y: 15)
                    
                    // Right label (100)
                    Text("100")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.27, green: 0.15, blue: 0.05))
                        .position(x: 255, y: 125)
                }
                .frame(width: 280, height: 140)
                
                // Center score display
                VStack(spacing: 4) {
                    Text("\(Int(animatedScore))%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.orange)
                    
                    if let category = category {
                        Text(category)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.orange)
                    }
                }
                .position(x: 140, y: 90) // Center it in the arc
            }
            .frame(width: 280, height: 140)
        }
        .frame(height: 180) // Total container height
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animatedScore = Double(score)
            }
        }
        .onChange(of: score) { _, newValue in
            withAnimation(.easeOut(duration: 1.5)) {
                animatedScore = Double(newValue)
            }
        }
    }
}

struct SemicircleArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let radius = min(rect.width, rect.height * 2) / 2
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        return path
    }
} 