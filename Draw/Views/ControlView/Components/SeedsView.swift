import SwiftUI
import CompactSlider

struct SeedsView: View {
    
    @EnvironmentObject var context: GenerationContext
    
    var body: some View {
        HStack {
            Text("Seeds")
                .style(.control)
            InfoButton {
                VStack {
                    Text("Random seed which to start generation")
                }
                .padding()
            }
        }
        createSeedSlider()
    }
    
    private func createSeedSlider() -> some View {
        let seedBinding = Binding<Double> {
            Double(context.seed)
        } set: {
            context.seed = .init($0)
        }
        
        return CompactSlider(value: seedBinding, in: 1...20, step: 1) {
            Text("Seeds")
            Spacer()
            Text("\(context.seed)")
        }
        .padding(.bottom, 5)
    }
}

#Preview {
    SeedsView()
}
