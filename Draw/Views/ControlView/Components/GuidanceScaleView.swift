import SwiftUI
import CompactSlider

struct GuidanceScaleView: View {
    
    @EnvironmentObject var context: GenerationContext
    
    var body: some View {
        HStack {
            Text("Guidance Scale")
                .style(.control)
            
            InfoButton {
                VStack {
                    Text("Controls the influence of the text prompt on sampling process (0=random images)")
                }
                .padding()
            }
        }
        
        CompactSlider(value: $context.guidanceScale, in: 1...20, step: 0.5) {
            Text("Guidance Scale")
            Spacer()
            Text("\(context.guidanceScale.format(".1"))")
        }
    }
}

#Preview {
    GuidanceScaleView()
}
