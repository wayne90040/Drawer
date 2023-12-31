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
        CompactSlider(value: $context.steps,
                      in: Constants.Steps.MIN...Constants.Steps.MAX,
                      step: 1.0) {
            Text("Steps")
            Spacer()
            Text("\(context.steps.format(".0"))")
        }
    }
}

#Preview {
    StepsView()
}
