import SwiftUI
import Combine

struct DrawView: View {
    @EnvironmentObject var generationContext: GenerationContext
    
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    @State private var lineWidth: Double = 1.0
    
    var drag: some Gesture {
        DragGesture(minimumDistance: .zero, coordinateSpace: .local)
            .onChanged {
                let newPoint = $0.location
                currentLine.points.append(newPoint)
                lines.append(currentLine)
            }
            .onEnded { _ in
                lines.append(currentLine)
                currentLine = .init(points: [], color: currentLine.color, lineWidth: lineWidth)
            }
    }
    
    var drawer: some View {
        Canvas { context, size in
            lines.forEach {
                var path = Path()
                path.addLines($0.points)
                context.stroke(path, with: .color($0.color), lineWidth: $0.lineWidth)
            }
        }
        .frame(width: 512, height: 512)
//        .frame(width: 512, height: 768)
        .gesture(drag)
    }
    
    var body: some View {
        VStack {
            drawer
            HStack {
                Slider(value: $lineWidth, in: 1...20) {
                    Text("Line width")
                }
                .onChange(of: lineWidth) { oldValue, newValue in
                    currentLine.lineWidth = newValue
                }
                Divider()
                ColorPanelView(selected: $currentLine.color)
                    .onChange(of: currentLine.color) { oldValue, newValue in
                        currentLine.color = newValue
                    }
                Divider()
                VStack {
                    Button("Generate") {
                        generate()
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Clear") {
                        lines = []
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
    }

    private func generate() {
        if case .running = generationContext.state { return }
        Task {
            generationContext.state = .running(nil)
            do {
                let renderer = ImageRenderer(content: drawer)
                let result = try await generationContext.textToImage()
                generationContext.state = .complete(generationContext.prompt, result.image, result.lastSeed, result.interval)
            }
            catch {
                generationContext.state = .failed(error)
            }
        }
    }
}

#Preview {
    DrawView()
}
