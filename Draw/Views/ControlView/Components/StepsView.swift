import SwiftUI
import CompactSlider

struct StepsView: View {
    
    @EnvironmentObject var context: GenerationContext
    
    var body: some View {
        HStack {
            Text("Steps")
                .style(.control)
            
            InfoButton {
                VStack {
                    Text("Number of inference steps to perform")
                }
                .padding()
            }
        }
        
        CompactSlider(value: $context.steps, in: 1...20, step: 1.0) {
            Text("Steps")
            Spacer()
            Text("\(context.steps.format(".1"))")
        }
    }
}

#Preview {
    StepsView()
}
