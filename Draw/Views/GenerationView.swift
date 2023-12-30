import SwiftUI
import StableDiffusion

struct GenerationView: View {
    @EnvironmentObject var generationContext: GenerationContext
    
    @ViewBuilder
    var body: some View {

        switch generationContext.state {
        case .startup:
            Text("start up")
            
        case .running(let progress):
            if let progress = progress {
                let step = progress.step + 1
                let fraction = Double(step) / Double(progress.stepCount)
                let label = "Step \(step) of \(progress.stepCount)"
                HStack {
                    ProgressView(label, value: fraction, total: 1)
                    Button("Cancel") {
                        generationContext.cancelGeneration()
                    }
                }
                .padding()
            }
            else {
                ProgressView()
            }
            
        case .complete(_, let cgImage, _, _):
            if let cgImage = cgImage {
                Image(cgImage, scale: 1, label: Text(""))
                    .resizable()
            }
            else {
                Text("Complete")
            }
            
        case .userCanceled:
            Text("User cancel")
            
        case .failed(let error):
            if let error = error {
                Text("Failed \(error.localizedDescription)")
            }
            else {
                Text("Failed")
            }
        }
    }
}

#Preview {
    GenerationView()
}
