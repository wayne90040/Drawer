import SwiftUI

struct GeneratedProgressView: View {
    
    @EnvironmentObject var ctx: GenerationContext
    
    var body: some View {
        
        switch ctx.state {
        case .running(let progress):
            if let progress = progress {
                let step = progress.step + 1
                let fraction = Double(step) / Double(progress.stepCount)
                let label = "Step \(step) of \(progress.stepCount)"
                HStack {
                    ProgressView(label, value: fraction, total: 1)
                    Button("Cancel") {
                        ctx.cancelGeneration()
                    }
                }
                .padding()
            }
            else {
                ProgressView()
            }
            
        default:
            EmptyView()
        }
    }
}

#Preview {
    GeneratedProgressView()
}
