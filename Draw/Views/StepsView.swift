import SwiftUI
import CompactSlider

struct StepsView: View {
    
    @EnvironmentObject var context: GenerationContext
    
    var body: some View {
        
        Text("Steps")
            .style(.control)
        
        CompactSlider(value: $context.steps, in: 1...20, step: 1.0) {
            Text("Steps")
            Spacer()
            Text("\(context.steps)")
        }
    }
}

#Preview {
    StepsView()
}
